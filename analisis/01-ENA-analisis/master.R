# =========================================================================
# SCRIPT MAESTRO - ANÁLISIS ENA 2014-2024
# Metodología: CRISP-DM
# =========================================================================
cat("Iniciando Proceso Completo de Análisis Estratégico...\n")

source("01_ingestion.R")   # .sav -> .parquet + Verification
source("02_processing.R")  # Summarization + Spatial Join
source("03_reporting.R")   # Strategic Mapping

cat("\n========================================================\n")
cat("      PROCESO FINALIZADO CON ÉXITO\n")
cat("      1. Revisa 'results/' para los 4 mapas estratégicos.\n")
cat("      2. Lee '04_insights.md' para la interpretación comercial.\n")
cat("========================================================\n")
