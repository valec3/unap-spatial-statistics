# =========================================================================
# CONFIGURACIÓN Y LIBRERÍAS
# Metodología: CRISP-DM - Etapa: Configuration
# =========================================================================

paquetes <- c(
  "tidyverse",   # Manipulación de datos y gráficos
  "haven",       # Lectura de archivos .sav (SPSS)
  "sf",          # Procesamiento de datos espaciales
  "ggspatial",   # Elementos de mapas (escala, norte)
  "viridis",     # Paletas de colores
  "data.table",  # Procesamiento de alto rendimiento
  "arrow",       # Lectura/Escritura de Parquet (CRÍTICO para optimización)
  "units",       # Manejo de unidades espaciales
  "here"         # Manejo de rutas relativas profesional
)

# Instalación automática de paquetes faltantes
instalados <- paquetes %in% installed.packages()[, "Package"]
if (any(!instalados)) {
  cat("Instalando paquetes faltantes...\n")
  install.packages(paquetes[!instalados])
}

# Carga silenciosa
invisible(lapply(paquetes, library, character.only = TRUE))

# DEFINICIÓN DE RUTAS (Usando 'here' para portabilidad total)
# La raíz es donde se encuentra el archivo .Rproj o la carpeta principal
INPUT_SAV  <- here("data/ENA_2014_2024.sav")
OUTPUT_PQ  <- here("data/ENA_2014_2024.parquet")
SHAPEFILE  <- here("unidades/unidad-01/tareas/tarea-02-ena/DEPARTAMENTOS_inei_geogpsperu_suyopomalia.shp")
RESULTS_DIR <- here("unidades/unidad-01/tareas/tarea-02-ena/results")

# Crear directorio de resultados si no existe
if (!dir.exists(RESULTS_DIR)) dir.create(RESULTS_DIR, recursive = TRUE)

cat("✓ Entorno configurado con 'here'.\n")
