"""Process ENA modules 1893 and 1895.

This script loads selected ENA CSV tables, builds a consolidated base for
module 1893, and prints a quick preview for verification.
"""

from pathlib import Path
from typing import Iterable, Tuple

import pandas as pd

MODULE_1893_DIR = "973-Modulo1893"
MODULE_1895_DIR = "973-Modulo1895"


def find_data_dir(start: Path) -> Path:
    """Find the project data directory by walking up from a start path."""
    for parent in [start] + list(start.parents):
        candidate = parent / "data"
        if (candidate / MODULE_1893_DIR).is_dir() and (candidate / MODULE_1895_DIR).is_dir():
            return candidate
    raise FileNotFoundError(
        "Could not locate the 'data' directory with 973-Modulo1893 and 973-Modulo1895."
    )


DATA_DIR = find_data_dir(Path(__file__).resolve())

MD_1893_CARATULA = DATA_DIR / MODULE_1893_DIR / "CARATULA.csv"
MD_1893_USOSTIERRA = DATA_DIR / MODULE_1893_DIR / "USOSTIERRA.csv"
MD_1893_CAP100A_01 = DATA_DIR / MODULE_1893_DIR / "01_CAP100A_01.csv"
MD_1893_CAP100A_02 = DATA_DIR / MODULE_1893_DIR / "01_CAP100A_02.csv"
MD_1893_CAP100A_03 = DATA_DIR / MODULE_1893_DIR / "01_CAP100A_03.csv"
MD_1893_CAP100A_04 = DATA_DIR / MODULE_1893_DIR / "01_CAP100A_04.csv"

MD_1895_CAP200A = DATA_DIR / MODULE_1895_DIR / "03_CAP200A.csv"
MD_1895_CAP200AB = DATA_DIR / MODULE_1895_DIR / "03_CAP200AB.csv"


def load_module_1893(key_dtypes: dict | None = None) -> Tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    """Load all module 1893 tables."""
    read_kwargs = {"low_memory": False}
    if key_dtypes:
        read_kwargs["dtype"] = key_dtypes

    caratula = pd.read_csv(MD_1893_CARATULA, **read_kwargs)
    usostierra = pd.read_csv(MD_1893_USOSTIERRA, **read_kwargs)
    cap100a_01 = pd.read_csv(MD_1893_CAP100A_01, **read_kwargs)
    cap100a_02 = pd.read_csv(MD_1893_CAP100A_02, **read_kwargs)
    cap100a_03 = pd.read_csv(MD_1893_CAP100A_03, **read_kwargs)
    cap100a_04 = pd.read_csv(MD_1893_CAP100A_04, **read_kwargs)

    return caratula, usostierra, cap100a_01, cap100a_02, cap100a_03, cap100a_04


def load_module_1895() -> Tuple[pd.DataFrame, pd.DataFrame]:
    """Load all module 1895 tables."""
    cap200a = pd.read_csv(MD_1895_CAP200A, low_memory=False)
    cap200ab = pd.read_csv(MD_1895_CAP200AB, low_memory=False)

    return cap200a, cap200ab


def build_base_1893(
    caratula: pd.DataFrame,
    usostierra: pd.DataFrame,
    cap100a_01: pd.DataFrame,
    keys: Iterable[str],
) -> pd.DataFrame:
    """Build a star-shaped consolidated base for module 1893."""
    key_list = list(keys)

    required_caratula = set(key_list + ["LATITUD", "LONGITUD", "REGION", "FACTOR_PRODUCTOR"])
    required_sup = set(key_list + ["P104_SUP_ha"])
    required_cultivo = set(key_list + ["P115_NOM", "P115_COD", "P117_SUP_ha", "P121"])

    missing_caratula = required_caratula - set(caratula.columns)
    missing_sup = required_sup - set(cap100a_01.columns)
    missing_cultivo = required_cultivo - set(usostierra.columns)

    if missing_caratula or missing_sup or missing_cultivo:
        raise ValueError(
            "Missing required columns. "
            f"caratula={sorted(missing_caratula)}, "
            f"cap100a_01={sorted(missing_sup)}, "
            f"usostierra={sorted(missing_cultivo)}"
        )

    df_caratula = caratula[list(required_caratula)]
    df_sup = cap100a_01[list(required_sup)]
    df_cultivo = usostierra[list(required_cultivo)]

    df_temp = pd.merge(df_caratula, df_sup, on=key_list, how="left")
    return pd.merge(df_temp, df_cultivo, on=key_list, how="left")


def normalize_key_types(df: pd.DataFrame, keys: Iterable[str]) -> pd.DataFrame:
    """Ensure merge keys are comparable across modules."""
    for key in keys:
        if key in df.columns:
            df[key] = df[key].astype("string").str.strip()
            df[key] = df[key].str.replace(r"\.0$", "", regex=True)
    return df


def build_module_1895_production(keys: Iterable[str]) -> pd.DataFrame:
    """Load CAP200AB with only required columns and compute production metrics."""
    key_list = list(keys)
    cols_produccion = key_list + [
        "P204_NOM",
        "P217_SUP_ha",
        "P219_CANT_1",
        "P219_EQUIV_KG",
        "P223B_1",
        "P223B_3",
        "P223B_7",
    ]
    dtype_dict = {key: "str" for key in key_list}

    cap200ab = pd.read_csv(
        MD_1895_CAP200AB,
        usecols=cols_produccion,
        dtype=dtype_dict,
        low_memory=False,
    )
    cap200ab["P219_CANT_1"] = pd.to_numeric(cap200ab["P219_CANT_1"], errors="coerce")
    cap200ab["P219_EQUIV_KG"] = pd.to_numeric(cap200ab["P219_EQUIV_KG"], errors="coerce")
    cap200ab["P217_SUP_ha"] = pd.to_numeric(cap200ab["P217_SUP_ha"], errors="coerce")

    cap200ab["PROD_TOTAL_KG"] = cap200ab["P219_CANT_1"] * cap200ab["P219_EQUIV_KG"]
    cap200ab["RENDIMIENTO_HA"] = cap200ab["PROD_TOTAL_KG"] / cap200ab["P217_SUP_ha"]
    cap200ab.loc[cap200ab["P217_SUP_ha"] <= 0, "RENDIMIENTO_HA"] = pd.NA

    return cap200ab


def main() -> None:
    """Build the final merged dataset across modules 1893 and 1895."""
    base_keys = ["ANIO", "CCDD", "CCPP", "CCDI", "NSEGM", "ID_PROD", "UA"]
    prod_keys = base_keys + ["P105"]
    key_dtypes = {key: "string" for key in prod_keys}

    caratula, usostierra, cap100a_01, cap100a_02, cap100a_03, cap100a_04 = load_module_1893(key_dtypes)
    _ = (cap100a_02, cap100a_03, cap100a_04)

    df_base_1893 = build_base_1893(caratula, usostierra, cap100a_01, base_keys)
    cap200ab = build_module_1895_production(prod_keys)

    df_base_1893 = normalize_key_types(df_base_1893, base_keys)
    cap200ab = normalize_key_types(cap200ab, base_keys)

    df_final = pd.merge(df_base_1893, cap200ab, on=base_keys, how="inner")
    if df_final.empty:
        print("Warning: merge result is empty. Check key formats or missing values.")
        print("Base keys sample (1893):")
        print(df_base_1893[base_keys].head())
        print("Base keys sample (1895):")
        print(cap200ab[base_keys].head())
    output_path = Path(__file__).resolve().parent / "Dataset_Final_Analisis.csv"
    df_final.to_csv(output_path, index=False)

    print("Procesamiento completado.")
    print(f"Dimensiones finales: {df_final.shape}")
    print("Columnas en la base final:")
    print(df_final.columns.tolist())
    print(output_path)


if __name__ == "__main__":
    main()
    
