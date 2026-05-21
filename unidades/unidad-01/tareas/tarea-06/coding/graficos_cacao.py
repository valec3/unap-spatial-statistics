"""Graficos para CACAO: mapa de produccion y resumen por piso altitudinal."""

from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt

DATA_PATH = Path(__file__).resolve().parent / "Dataset_Final_Analisis_Altitud.csv"
OUT_DIR = Path(__file__).resolve().parent / "figures"
PRODUCTO = "CACAO"


def load_data(path: Path) -> pd.DataFrame:
    """Load dataset and filter by product."""
    df = pd.read_csv(path, low_memory=False)
    if "P204_NOM" not in df.columns:
        raise ValueError("Missing column P204_NOM in dataset.")
    df = df[df["P204_NOM"].astype("string").str.upper() == PRODUCTO]
    if df.empty:
        raise ValueError(f"No rows found for product: {PRODUCTO}")
    return df


def plot_map(df: pd.DataFrame, out_dir: Path) -> None:
    """Plot a map-like scatter for production points."""
    out_dir.mkdir(parents=True, exist_ok=True)

    df = df.copy()
    for col in ["LONGITUD", "LATITUD", "PROD_TOTAL_KG", "RENDIMIENTO_HA"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    df = df[df["LONGITUD"].notna() & df["LATITUD"].notna()]
    if df.empty:
        raise ValueError("No valid coordinates for plotting.")

    use_geo = False
    try:
        import geopandas as gpd

        world = gpd.read_file(gpd.datasets.get_path("naturalearth_lowres"))
        peru = world[world["name"] == "Peru"]
        use_geo = True
    except Exception:
        peru = None

    plt.figure(figsize=(8, 10))
    if use_geo and peru is not None:
        peru.plot(color="#f2f2f2", edgecolor="#666666")

    size = df["PROD_TOTAL_KG"].fillna(0)
    size = size.clip(lower=0)
    size = (size / size.max() * 200) if size.max() > 0 else 20

    plt.scatter(
        df["LONGITUD"],
        df["LATITUD"],
        s=size,
        c=df["RENDIMIENTO_HA"],
        cmap="viridis",
        alpha=0.7,
        edgecolors="white",
        linewidths=0.3,
    )
    plt.colorbar(label="Rendimiento (ha)")
    plt.title("CACAO - Produccion y Rendimiento")
    plt.xlabel("Longitud")
    plt.ylabel("Latitud")
    plt.tight_layout()
    plt.savefig(out_dir / "cacao_mapa_produccion.png", dpi=200)
    plt.close()


def plot_piso_summary(df: pd.DataFrame, out_dir: Path) -> None:
    """Plot median rendimiento by piso altitudinal."""
    out_dir.mkdir(parents=True, exist_ok=True)
    if "PISO_ALTITUDINAL" not in df.columns:
        raise ValueError("Missing column PISO_ALTITUDINAL.")

    df = df.copy()
    df["RENDIMIENTO_HA"] = pd.to_numeric(df["RENDIMIENTO_HA"], errors="coerce")

    summary = (
        df.groupby("PISO_ALTITUDINAL", dropna=False)
        .agg(mediana=("RENDIMIENTO_HA", "median"),
             std=("RENDIMIENTO_HA", "std"),
             n=("RENDIMIENTO_HA", "count"))
        .reset_index()
    )

    summary = summary[summary["PISO_ALTITUDINAL"].notna()]

    plt.figure(figsize=(8, 5))
    plt.bar(summary["PISO_ALTITUDINAL"].astype(str), summary["mediana"], color="#2b8cbe")
    plt.title("CACAO - Mediana de Rendimiento por Piso")
    plt.xlabel("Piso altitudinal")
    plt.ylabel("Rendimiento (mediana)")
    plt.tight_layout()
    plt.savefig(out_dir / "cacao_piso_mediana.png", dpi=200)
    plt.close()

    summary.to_csv(out_dir / "cacao_resumen_pisos.csv", index=False)


def main() -> None:
    df = load_data(DATA_PATH)
    plot_map(df, OUT_DIR)
    plot_piso_summary(df, OUT_DIR)
    print(f"OK: graficos guardados en {OUT_DIR}")


if __name__ == "__main__":
    main()
