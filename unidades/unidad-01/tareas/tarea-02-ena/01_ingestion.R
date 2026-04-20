# =========================================================================
# ETAPA 1: INGESTIÓN Y CONVERSIÓN (CRISP-DM: Data Preparation)
# Objetivo: Convertir .sav a .parquet y verificar integridad
# =========================================================================

source("00_setup.R")

cat("\n>>> PASO 1: Cargando datos desde .sav original...\n")

# Variables requeridas de acuerdo a solicitudes y vars.txt
variables_req <- c(
  "NOMBREDD", "CCDD", 
  "P14_TOTPARCELAS", "P14_TOTESPECIES", # Estructura
  "P110_3",                             # Tenencia: Arrendatario
  "P235", "P235A",                      # Insumos: Semilla
  "P236", "P103"                         # Insumos: Abono y Parcelas distrito
)

# Lectura optimizada con col_select
datos_sav <- read_sav(
  INPUT_SAV,
  col_select = all_of(variables_req),
  encoding = "latin1"
)

cat("✓ Datos .sav cargados. Dimensiones:", paste(dim(datos_sav), collapse = "x"), "\n")

cat("\n>>> PASO 2: Convirtiendo a formato PARQUET...\n")
# El formato Parquet es mucho más eficiente para lectura/escritura en R
write_parquet(datos_sav, OUTPUT_PQ)
cat("✓ Archivo guardado en:", OUTPUT_PQ, "\n")

cat("\n>>> PASO 3: Verificación de conversión...\n")

# Re-leemos el parquet para comparar
datos_pq <- read_parquet(OUTPUT_PQ)

# Verificación de Dimensiones
checkpoint_dim <- all(dim(datos_sav) == dim(datos_pq))

# Verificación de Nulos (debe ser identico)
sum_na_sav <- sum(is.na(datos_sav))
sum_na_pq  <- sum(is.na(datos_pq))
checkpoint_na <- (sum_na_sav == sum_na_pq)

# Verificación de Schema
checkpoint_names <- all(names(datos_sav) == names(datos_pq))

if (checkpoint_dim && checkpoint_na && checkpoint_names) {
  cat("========================================================\n")
  cat("  ✅ VERIFICACIÓN EXITOSA: La conversión es íntegra.\n")
  cat("  - Filas/Columnas: COINCIDEN\n")
  cat("  - Total Nulos: COINCIDEN (", sum_na_pq, ")\n")
  cat("  - Nombres Columnas: COINCIDEN\n")
  cat("========================================================\n")
  
  # Liberar memoria de los datos pesados, ya tenemos el parquet
  rm(datos_sav, datos_pq)
  gc()
} else {
  stop("❌ ERROR CRÍTICO: Discrepancia detectada en la conversión Parquet!")
}
