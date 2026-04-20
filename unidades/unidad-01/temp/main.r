# --- ANALISIS ESTADISTICO ESPACIAL (UNAP) ---
# Tarea: Carga de reportes ganaderos convertidos de PDF

library(tidyverse)

# Ruta a los archivos convertidos
output_path <- "unidades/unidad-01/temp/Output"

# Listar los CSV generados
csv_files <- list.files(output_path, pattern = "\\.csv$", full.names = TRUE)
print("Archivos CSV disponibles:")
print(basename(csv_files))

# Función para cargar y limpiar mínimamente un reporte
# (DairyPlan repite cabeceras en cada página de impresión)
load_dairy_report <- function(path) {
  df <- read_csv(path, show_col_types = FALSE)
  
  # Eliminar filas que son repeticiones de la cabecera
  # Buscamos filas donde la primera columna sea igual al nombre de la columna (falla de parseo)
  # o contenga "N°"
  df_clean <- df %>% 
    filter(!X1 %in% c("X1", "N°", "NUM", "Vaq.")) %>%
    filter(!is.na(X1))
  
  return(df_clean)
}

# Ejemplo: Cargar reporte de Mastitis
if (file.exists(file.path(output_path, "MASTITIS.csv"))) {
  mastitis_data <- load_dairy_report(file.path(output_path, "MASTITIS.csv"))
  print("Previsualización de Mastitis:")
  print(head(mastitis_data))
}

# Ejemplo: Cargar Producción de Leche
if (file.exists(file.path(output_path, "PRODUCCIÓN DE LECHE.csv"))) {
  leche_data <- load_dairy_report(file.path(output_path, "PRODUCCIÓN DE LECHE.csv"))
  print("Previsualización de Producción de Leche:")
  print(head(leche_data))
}

# ¡Listo para el análisis espacial!
