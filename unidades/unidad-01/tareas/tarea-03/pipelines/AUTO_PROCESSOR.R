# --- AUTO PROCESSOR: REPORTE GANADERO UNAP ---
# Este script ejecuta todos los pipelines y centraliza la data limpia.

library(tidyverse)

# 1. Rutas
pipeline_dir <- "unidades/unidad-01/tareas/tarea-03/pipelines"
clean_dir <- "unidades/unidad-01/tareas/tarea-03/data-procesada"

if (!dir.exists(clean_dir)) dir.create(clean_dir, recursive = TRUE)

cat("\n==============================================\n")
cat("INICIANDO PROCESAMIENTO TOTAL DE DATA CLEAN\n")
cat("==============================================\n")

# 2. Lista de Pipelines a ejecutar
# Agregamos todos los .R de la carpeta pipelines
pipelines <- list.files(pipeline_dir, pattern = "\\.R$", full.names = TRUE)

# Filtramos este mismo script si estuviera en la misma carpeta
pipelines <- pipelines[!str_detect(pipelines, "AUTO_PROCESSOR.R")]

# 3. Ejecución Masiva
for (p in pipelines) {
  cat("\n>>> Lanzando:", basename(p), "...\n")
  tryCatch({
    source(p, local = TRUE)
  }, error = function(e) {
    cat("!!! Error procesando", basename(p), ":", e$message, "\n")
  })
}

# 4. Consolidación de fallback (opcional)
# Si algún PDF no fue capturado por los pipelines específicos,
# podrías llamar aquí a un extractor genérico.

# 5. Finalización
cat("\n==============================================\n")
cat("PROCESO COMPLETADO\n")
cat("Archivos generados en:", clean_dir, "\n")
cat("Total de pipelines ejecutados:", length(pipelines), "\n")
cat("==============================================\n")
