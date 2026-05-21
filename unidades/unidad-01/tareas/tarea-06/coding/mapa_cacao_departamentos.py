"""Mapa coropletico de CACAO: promedio de produccion por departamento."""

from pathlib import Path

import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt

DATA_PATH = Path(__file__).resolve().parent / "Dataset_Final_Analisis_Altitud.csv"
SHAPE_PATH = Path(__file__).resolve().parents[2] / "tarea-02-ena" / "DEPARTAMENTOS_inei_geogpsperu_suyopomalia.shp"
OUT_DIR = Path(__file__).resolve().parent / "figures"
PRODUCTO = "CACAO"


def normalize_name(value: pd.Series) -> pd.Series:
    """Normalize department names for safe joining."""
    return (
        value.astype("string")
        .str.strip()
        .str.upper()
        .str.normalize("NFKD")
        .str.encode("ascii", errors="ignore")
        .str.decode("ascii")
        .str.replace(r"[^A-Z]", "", regex=True)
    )


def normalize_code(value: pd.Series, width: int = 2) -> pd.Series:
    """Normalize department code to zero-padded string."""
    return (
        value.astype("string")
        .str.strip()
        .str.replace(r"\.0$", "", regex=True)
        .str.zfill(width)
    )


def load_data() -> pd.DataFrame:
    """Load and aggregate production by department."""
    df = pd.read_csv(DATA_PATH, low_memory=False)
    df = df[df["P204_NOM"].astype("string").str.upper() == PRODUCTO]
    if df.empty:
        raise ValueError(f"No rows found for product: {PRODUCTO}")
    dept_col = "NOMBREDD" if "NOMBREDD" in df.columns else "REGION" if "REGION" in df.columns else None

    if "PROD_TOTAL_KG" in df.columns:
        df["PROD_TOTAL_KG"] = pd.to_numeric(df["PROD_TOTAL_KG"], errors="coerce")

    if df["PROD_TOTAL_KG"].isna().all() and {"P219_CANT_1", "P219_EQUIV_KG"}.issubset(df.columns):
        df["P219_CANT_1"] = pd.to_numeric(df["P219_CANT_1"], errors="coerce")
        df["P219_EQUIV_KG"] = pd.to_numeric(df["P219_EQUIV_KG"], errors="coerce")
        df["PROD_TOTAL_KG"] = df["P219_CANT_1"] * df["P219_EQUIV_KG"]

    df = df[df["PROD_TOTAL_KG"].notna() & (df["PROD_TOTAL_KG"] > 0)]

    if "CCDD" in df.columns:
        df["CCDD"] = normalize_code(df["CCDD"], width=2)
        resumen = (
            df.groupby("CCDD", dropna=False)
            .agg(PROD_PROMEDIO=("PROD_TOTAL_KG", "mean"), N_REGISTROS=("PROD_TOTAL_KG", "size"))
            .reset_index()
        )
        resumen["DEP_KEY_CODE"] = resumen["CCDD"]
    elif dept_col is not None:
        resumen = (
            df.groupby(dept_col, dropna=False)
            .agg(PROD_PROMEDIO=("PROD_TOTAL_KG", "mean"), N_REGISTROS=("PROD_TOTAL_KG", "size"))
            .reset_index()
        )
        resumen["DEP_KEY_NAME"] = normalize_name(resumen[dept_col])
    else:
        raise ValueError("Missing department column (expected CCDD, NOMBREDD or REGION).")
    return resumen


def load_shape() -> gpd.GeoDataFrame:
    """Load Peru departments shapefile."""
    if not SHAPE_PATH.exists():
        raise FileNotFoundError(f"Shapefile not found: {SHAPE_PATH}")
    gdf = gpd.read_file(SHAPE_PATH)
    if "CCDD" in gdf.columns:
        gdf["DEP_KEY_CODE"] = normalize_code(gdf["CCDD"], width=2)
    gdf["DEP_KEY_NAME"] = normalize_name(gdf["NOMBDEP"])
    return gdf


def plot_map(gdf: gpd.GeoDataFrame) -> None:
    """Plot choropleth map."""
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    ax = gdf.plot(
        column="PROD_PROMEDIO",
        cmap="YlOrRd",
        legend=True,
        edgecolor="#666666",
        linewidth=0.5,
        missing_kwds={"color": "#f0f0f0", "label": "Sin datos"},
        figsize=(8, 10),
    )
    # Add labels at centroids
    gdf = gdf.copy()
    gdf["label"] = gdf["PROD_PROMEDIO"].round(1)
    for _, row in gdf[gdf["PROD_PROMEDIO"].notna()].iterrows():
        x = row.geometry.representative_point().x
        y = row.geometry.representative_point().y
        ax.text(x, y + 0.3, str(row["NOMBDEP"]), fontsize=5, ha="center", va="center")
        ax.text(x, y - 0.3, str(row["label"]), fontsize=6, ha="center", va="center")
    ax.set_title("CACAO - Promedio de Produccion por Departamento", fontsize=12)
    ax.set_axis_off()
    plt.tight_layout()
    plt.savefig(OUT_DIR / "cacao_mapa_departamentos.png", dpi=200)
    plt.close()


def main() -> None:
    resumen = load_data()
    gdf = load_shape()

    gdf_code = gdf.merge(resumen, how="left", on="DEP_KEY_CODE") if "DEP_KEY_CODE" in resumen.columns else gdf
    gdf_name = gdf.merge(resumen, how="left", on="DEP_KEY_NAME") if "DEP_KEY_NAME" in resumen.columns else gdf

    matches_code = gdf_code["PROD_PROMEDIO"].notna().sum() if "PROD_PROMEDIO" in gdf_code.columns else 0
    matches_name = gdf_name["PROD_PROMEDIO"].notna().sum() if "PROD_PROMEDIO" in gdf_name.columns else 0

    gdf = gdf_code if matches_code >= matches_name else gdf_name

    plot_map(gdf)
    resumen.to_csv(OUT_DIR / "cacao_promedio_departamentos.csv", index=False)
    print(f"Departamentos con datos: {gdf['PROD_PROMEDIO'].notna().sum()}")
    print(f"OK: mapa guardado en {OUT_DIR}")


if __name__ == "__main__":
    main()
