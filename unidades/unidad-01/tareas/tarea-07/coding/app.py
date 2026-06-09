import streamlit as st
import geopandas as gpd
import matplotlib.pyplot as plt
import pandas as pd
from libpysal.weights import Queen
from esda.moran import Moran
from splot.esda import moran_scatterplot

st.set_page_config(page_title="Índice de Moran", layout="wide")

st.title("📊 Aplicativo de Autocorrelación Espacial (Índice de Moran)")
st.write("Evidencia del Índice de Moran utilizando múltiples datasets integrados de PySAL.")

try:
    # Use local datasets directory (bundled with the app)
    import os
    datasets_dir = os.path.join(os.path.dirname(__file__), 'datasets')
    
    dataset_opcion = st.selectbox(
        "💡 Selecciona un Dataset para evidenciar el análisis:",
        [
            "Homicidios en St. Louis (EE.UU.) - Variables Socieconómicas",
            "AirBnB en Chicago (EE.UU.) - socioeconomía y crimen",
            "Indicadores de Desarrollo en Nepal"
        ]
    )

    gdf = None
    desc = ""
    path = None
    
    if "St. Louis" in dataset_opcion:
        path = os.path.join(datasets_dir, 'StLouis', 'stlouis.shp')
        if os.path.exists(path):
            gdf = gpd.read_file(path)
            desc = "Condados del área de St. Louis con tasas de homicide, población y variables socioeconómicas (1979-1993)."
        else:
            st.error("No se encontró el dataset de St. Louis.")
            st.stop()
            
    elif "AirBnB" in dataset_opcion:
        path = os.path.join(datasets_dir, 'AirBnB', 'airbnb_Chicago 2015.shp')
        if os.path.exists(path):
            gdf = gpd.read_file(path)
            desc = "Barrios de Chicago con datos de AirBnB, indicadores socioeconómicos y tasas de crimen."
        else:
            st.error("No se encontró el dataset de AirBnB.")
            st.stop()
            
    else:  # Nepal
        path = os.path.join(datasets_dir, 'Nepal', 'nepal.shp')
        if os.path.exists(path):
            gdf = gpd.read_file(path)
            desc = "Distritos de Nepal con indicadores de pobreza, desarrollo humano e inversión pública."
        else:
            st.error("No se encontró el dataset de Nepal.")
            st.stop()

    st.info(f"**Descripción del Dataset:** {desc}")
    
    # Auto detect numeric columns
    numeric_cols = []
    for col in gdf.columns:
        if pd.api.types.is_numeric_dtype(gdf[col]) and col != 'geometry':
            # Check if column has at least some non-null values
            if not gdf[col].isna().all():
                numeric_cols.append(col)
    
    if not numeric_cols:
        st.error("No se encontraron variables numéricas en el dataset.")
    else:
        variable = st.selectbox("Selecciona la variable numérica a analizar:", numeric_cols)

        if variable:
            gdf = gdf.dropna(subset=[variable])
            
            w = Queen.from_dataframe(gdf, use_index=False)
            w.transform = 'R'
            
            y = gdf[variable].values
            moran = Moran(y, w)
            
            st.subheader("🎯 Resultados Estadísticos")
            col1, col2, col3 = st.columns(3)
            col1.metric(label="Índice de Moran Global (I)", value=f"{float(moran.I):.4f}")
            col2.metric(label="P-valor (Significancia)", value=f"{float(moran.p_sim):.4f}")
            # Handle moran.z which can be array or scalar
            z_value = float(moran.z) if moran.z.ndim == 0 else float(moran.z[0])
            col3.metric(label="Z-Score", value=f"{z_value:.4f}")
            
            if moran.p_sim < 0.05:
                if moran.I > 0:
                    st.success("✅ **Resultado:** Autocorrelación Espacial **POSITIVA** significativa. Los valores altos tienden a rodearse de valores altos, y los bajos de bajos (Agrupamiento/Clusters).")
                else:
                    st.warning("⚠️ **Resultado:** Autocorrelación Espacial **NEGATIVA** significativa. Los valores vecinos son muy diferentes entre sí (Dispersión tipo tablero de ajedrez).")
            else:
                st.error("🎲 **Resultado:** No significativo. La distribución espacial de la variable es **ALEATORIA**.")

            st.subheader("🖼️ Evidencia Gráfica")
            fig, ax = plt.subplots(1, 2, figsize=(16, 6))
            
            gdf.plot(column=variable, cmap='viridis', legend=True, ax=ax[0])
            ax[0].set_title(f'Distribución Espacial de: {variable}')
            ax[0].axis('off')
            
            moran_scatterplot(moran, ax=ax[1])
            ax[1].set_title('Scatterplot de Moran (Relación con Vecinos)')
            
            st.pyplot(fig)

except FileNotFoundError as e:
    st.error(f"No se encontró el archivo de datos: {str(e)}")
    st.info("Asegúrate de que los datasets estén en el directorio 'datasets' junto con app.py")
except Exception as e:
    st.error(f"Ocurrió un error: {str(e)}")
    import traceback
    st.text(traceback.format_exc())
