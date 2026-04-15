# ==============================================================================
# ANÁLISIS GEOESPACIAL - ENCUESTA NACIONAL AGROPECUARIA (ENA) PERÚ
# Variables: P14_TOTPARCELAS, P103, P235, P236
# ==============================================================================

paquetes <- c(
  "tidyverse",   # Incluye dplyr, ggplot2, readr, entre otros
  "foreign",       # Recomendado sobre 'foreign' para archivos .sav modernos
  "sf",          # Datos espaciales y shapefiles
  "ggspatial",   # Escala y flecha de norte para mapas
  "viridis",     # Paletas de colores accesibles
  "readxl",      # Leer archivos Excel
  "rnaturalearth"#
)

# Instalar los que no estén presentes y cargarlos todos
instalados <- paquetes %in% installed.packages()[, "Package"]
if (any(!instalados)) {
  install.packages(paquetes[!instalados])
}
# cargar librerias
lapply(paquetes, library, character.only = TRUE)


# -------------------------------------------------------------------------
# 2. CARGAR DATOS
# -------------------------------------------------------------------------
ruta_datos <- "D:/descargas/ENA_2014_2024/ENA_2014_2024.sav"
datos <- read.spss(ruta_datos, 
                   to.data.frame = TRUE, 
                   use.value.labels = TRUE, 
                   reencode = "latin1")


cat("Dimensiones de los datos:", dim(datos), "\n")
cat("Nombres de columnas:\n")
print(names(datos))


# -------------------------------------------------------------------------
# 3. VERIFICAR VARIABLES REQUERIDAS
# -------------------------------------------------------------------------
variables_req <- c("NOMBREDD", "CCDD", "P14_TOTPARCELAS", "P103", "P235", "P236")


# Verificar si existen
cat("\nVerificando variables requeridas:\n")
for (var in variables_req) {
  if (var %in% names(datos)) {
    cat("✓", var, "- Encontrada\n")
  } else {
    cat("✗", var, "- NO encontrada\n")
  }
}


# -------------------------------------------------------------------------
# 4. PREPARAR DATOS PARA ANÁLISIS POR ZONA (DEPARTAMENTO)
# -------------------------------------------------------------------------



