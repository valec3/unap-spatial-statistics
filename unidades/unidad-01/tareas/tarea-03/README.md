# 🐄 Proyecto ENA 2014-2024: Automatización de Pipeline Ganadero (Tarea 03)

![Portada del Proyecto](file:///C:/Users/ADMIN/.gemini/antigravity/brain/2a38a8be-2e09-4580-88de-1f12aacedecf/portada_proyecto_ena_unap_1776749664730.png)

## 📝 Descripción
Este proyecto corresponde a la **Tarea 03** del curso de Estadística Espacial (UNAP). Consiste en la automatización completa de la extracción, limpieza y consolidación de 14 reportes PDF generados por el software **DairyPlan**, transformándolos en un dataset unificado y un **Dashboard Interactivo en Shiny** para la gestión ganadera estratégica.

## 🚀 Cómo Ejecutar el Proyecto
Para garantizar que los datos estén actualizados, sigue este orden:

1.  **Procesamiento Maestro:** Ejecuta el script `consolidar_maestro_v2.R`. Este script orquestará los 14 pipelines individuales, cruzará la información de preñez y producción, y generará el archivo maestro `Dataset_Final_UNAP_FULL.csv`.
2.  **Visualización:** Abre y ejecuta `app.R`. Se lanzará el Dashboard interactivo donde podrás explorar la salud reproductiva y productiva del plantel.

## 📂 Estructura del Proyecto
-   `/pipelines/`: Contiene los 14 scripts individuales de extracción (Regex) para cada tipo de reporte.
-   `/Input/`: Carpeta con los reportes PDF originales de DairyPlan.
-   `/data-procesada/`: CSVs intermedios generados tras la limpieza de cada PDF.
-   `consolidar_maestro_v2.R`: El "cerebro" del pipeline. Une todas las piezas mediante `full_join`.
-   `app.R`: Aplicación Shiny con 6 visualizaciones interactivas de Business Intelligence.
-   `Dataset_Final_UNAP_FULL.csv`: El producto final de datos (Maestro).

## 📊 Glosario Técnico de KPIs
-   **DEL (Días en Lactancia):** Promedio de días desde el último parto. Vital para determinar la eficiencia del ciclo productivo.
-   **Lactancia Promedio:** Número promedio de partos por vaca en el plantel.
-   **Status Repro:** Clasificación inteligente (Preñadas, Inseminadas, Vacías) cruzando múltiples fuentes de datos.

## 🛠️ Tecnologías Utilizadas
-   **Language:** R 4.4.1
-   **Libraries:** `tidyverse`, `pdftools`, `shiny`, `bslib`, `plotly`.

---
**Desarrollado para:** Universidad Nacional de la Amazonía Peruana (UNAP)
**Curso:** Estadística Espacial 2026
