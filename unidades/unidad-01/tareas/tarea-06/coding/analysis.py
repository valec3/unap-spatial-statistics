"""Altitud, pisos y recomendaciones para ENA.

Pipeline:
1) Cargar DEM locales.
2) Extraer altitud por coordenadas con rasterio.
3) Clasificar pisos altitudinales (Jenks).
4) Resumir rendimiento por piso y cultivo.
5) Matriz de recomendacion y correlaciones.
"""

from pathlib import Path
from typing import Iterable

import pandas as pd
import rasterio

BASE_DIR = Path(__file__).resolve().parents[5]
DATASET_PATH = Path(__file__).resolve().parent / "Dataset_Final_Analisis.csv"
OUTPUT_PATH = Path(__file__).resolve().parent / "Dataset_Final_Analisis_Altitud.csv"
SUMMARY_PATH = Path(__file__).resolve().parent / "resumen_pisos_cultivo.csv"
RECO_PATH = Path(__file__).resolve().parent / "matriz_recomendacion.csv"
CORR_PATH = Path(__file__).resolve().parent / "correlaciones_factores.csv"
DEM_DIR = BASE_DIR / "data" / "tif-files"


def load_dataset(path: Path) -> pd.DataFrame:
	"""Load the unified dataset and validate required columns."""
	df = pd.read_csv(path)
	required = {"LATITUD", "LONGITUD", "RENDIMIENTO_HA", "P204_NOM"}
	missing = required - set(df.columns)
	if missing:
		raise ValueError(f"Missing required columns: {sorted(missing)}")
	return df


def clean_dataset(df: pd.DataFrame) -> pd.DataFrame:
	"""Clean coordinates and key numeric columns, removing invalid rows."""
	for col in ["LATITUD", "LONGITUD", "RENDIMIENTO_HA"]:
		if col in df.columns:
			df[col] = pd.to_numeric(df[col], errors="coerce")

	# Drop rows with missing or invalid coordinates
	valid_coords = (
		df["LATITUD"].between(-90, 90, inclusive="both")
		& df["LONGITUD"].between(-180, 180, inclusive="both")
	)
	df = df[valid_coords]

	# Remove non-positive or missing yields
	if "RENDIMIENTO_HA" in df.columns:
		df = df[df["RENDIMIENTO_HA"].notna() & (df["RENDIMIENTO_HA"] > 0)]

	return df


def extract_altitude(df: pd.DataFrame, dem_paths: Iterable[Path]) -> pd.Series:
	"""Extract altitude for each point using multiple DEM tiles."""
	coords = list(zip(df["LONGITUD"], df["LATITUD"]))
	altitudes = [pd.NA] * len(coords)

	open_dems = []
	for path in dem_paths:
		if not path.exists():
			raise FileNotFoundError(f"DEM not found: {path}")
		open_dems.append(rasterio.open(path))

	try:
		for idx, (lon, lat) in enumerate(coords):
			for src in open_dems:
				left, bottom, right, top = src.bounds
				if left <= lon <= right and bottom <= lat <= top:
					val = next(src.sample([(lon, lat)]), None)
					if val is None or len(val) == 0:
						break
					alt = float(val[0])
					nodata = src.nodata
					if nodata is None or alt != nodata:
						altitudes[idx] = alt
					break
	finally:
		for src in open_dems:
			src.close()

	return pd.Series(altitudes, index=df.index, name="ALTITUD")


def load_dem_paths(dem_dir: Path) -> list[Path]:
	"""Load all GeoTIFF DEM files from a directory."""
	if not dem_dir.exists():
		raise FileNotFoundError(f"DEM directory not found: {dem_dir}")
	paths = sorted(dem_dir.glob("*.tif"))
	if not paths:
		raise FileNotFoundError(f"No .tif files found in: {dem_dir}")
	return paths


def add_jenks_pisos(df: pd.DataFrame, nb_class: int = 5) -> pd.DataFrame:
	"""Add Jenks-based altitude classes."""
	try:
		import jenkspy
	except ImportError as exc:
		raise ImportError("Install jenkspy to compute Jenks breaks.") from exc

	alt = pd.to_numeric(df["ALTITUD"], errors="coerce")
	alt = alt[alt.notna() & (alt != float("inf")) & (alt != float("-inf"))]
	unique_vals = alt.nunique()
	if unique_vals < 2:
		# Fallback: all points in a single class
		df["PISO_ALTITUDINAL"] = "Piso 1"
		return df
	classes = min(nb_class, unique_vals)
	breaks = jenkspy.jenks_breaks(alt, n_classes=classes)
	breaks = sorted(set(breaks))
	labels = [f"Piso {i}" for i in range(1, nb_class + 1)]
	cut_series = pd.cut(
		pd.to_numeric(df["ALTITUD"], errors="coerce"),
		bins=breaks,
		labels=labels[: max(len(breaks) - 1, 1)],
		include_lowest=True,
		duplicates="drop",
	)
	df["PISO_ALTITUDINAL"] = cut_series
	return df


def summarize_by_piso(df: pd.DataFrame) -> pd.DataFrame:
	"""Compute performance indicators by altitude floor and crop."""
	resumen = (
		df.groupby(["PISO_ALTITUDINAL", "P204_NOM"], dropna=False)
		.agg(
			RENDIMIENTO_HA_median=("RENDIMIENTO_HA", "median"),
			RENDIMIENTO_HA_std=("RENDIMIENTO_HA", "std"),
			count=("RENDIMIENTO_HA", "count"),
			heladas=("P223B_3", "sum"),
		)
		.reset_index()
	)
	return resumen


def build_recommendation_matrix(resumen: pd.DataFrame) -> pd.DataFrame:
	"""Classify crops by stability and risk using quantile thresholds."""
	med_hi = resumen["RENDIMIENTO_HA_median"].quantile(0.75)
	med_lo = resumen["RENDIMIENTO_HA_median"].quantile(0.25)
	std_lo = resumen["RENDIMIENTO_HA_std"].quantile(0.25)
	std_hi = resumen["RENDIMIENTO_HA_std"].quantile(0.75)
	hel_hi = resumen["heladas"].quantile(0.75)

	def label_row(row: pd.Series) -> str:
		if row["RENDIMIENTO_HA_median"] >= med_hi and row["RENDIMIENTO_HA_std"] <= std_lo:
			return "Zona Optima"
		if row["RENDIMIENTO_HA_median"] >= med_hi and row["heladas"] >= hel_hi:
			return "Zona de Riesgo"
		if row["RENDIMIENTO_HA_median"] <= med_lo and row["RENDIMIENTO_HA_std"] >= std_hi:
			return "Zona Descartada"
		return "Zona Intermedia"

	resumen = resumen.copy()
	resumen["ZONA"] = resumen.apply(label_row, axis=1)
	return resumen


def compute_factor_correlations(df: pd.DataFrame) -> pd.DataFrame:
	"""Correlate affected factors with altitude."""
	factors = ["P223B_1", "P223B_3", "P223B_7"]
	cols = ["ALTITUD"] + factors
	missing = set(cols) - set(df.columns)
	if missing:
		raise ValueError(f"Missing columns for correlation: {sorted(missing)}")

	for col in cols:
		df[col] = pd.to_numeric(df[col], errors="coerce")

	return df[cols].corr()


def main() -> None:
	df = load_dataset(DATASET_PATH)
	df = clean_dataset(df)
	dem_paths = load_dem_paths(DEM_DIR)
	df["ALTITUD"] = extract_altitude(df, dem_paths)
	print(f"ALTITUD stats: count={df['ALTITUD'].notna().sum()}, unique={df['ALTITUD'].nunique()}")

	df = add_jenks_pisos(df, nb_class=5)
	resumen = summarize_by_piso(df)
	matriz = build_recommendation_matrix(resumen)
	corr = compute_factor_correlations(df)

	df.to_csv(OUTPUT_PATH, index=False)
	resumen.to_csv(SUMMARY_PATH, index=False)
	matriz.to_csv(RECO_PATH, index=False)
	corr.to_csv(CORR_PATH, index=True)

	print("OK: Altitud y pisos calculados.")
	print(f"Salida base: {OUTPUT_PATH}")
	print(f"Resumen: {SUMMARY_PATH}")
	print(f"Matriz: {RECO_PATH}")
	print(f"Correlaciones: {CORR_PATH}")


if __name__ == "__main__":
	main()