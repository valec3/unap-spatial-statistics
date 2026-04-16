# =========================================================================
# ETAPA 2: PROCESAMIENTO Y CRUCE ESPACIAL (CRISP-DM: Data Preparation)
# Objetivo: Limpieza, agregación y unión con Shapefile
# =========================================================================
source("00_setup.R")
if (!file.exists(OUTPUT_PQ)) stop("No se encuentra el archivo Parquet. Corre 01_ingestion.R primero.")
cat("\n>>> PASO 1: Cargando datos desde Parquet (Ultra rápido)...\n")
datos <- as.data.table(read_parquet(OUTPUT_PQ))
cat("\n>>> PASO 2: Limpieza y normalización de tipos...\n")
# Convertir columnas a numéricas
cols_numericas <- c("P14_TOTPARCELAS", "P14_TOTESPECIES", "P103", "P110_3", "P235", "P235A", "P236")
for (col in intersect(cols_numericas, names(datos))) {
  datos[[col]] <- suppressWarnings(as.numeric(as.character(datos[[col]])))
}

# Filtrar NAs básicos y exclusión de CALLAO (Constitucional, no depto agrario central)
datos_limpios <- datos[!is.na(NOMBREDD) & !grepl("CALLAO", NOMBREDD, ignore.case = TRUE)]

cat("\n>>> PASO 3: Agregación avanzada por Departamento...\n")

resumen_depto <- datos_limpios[, .(
  n_registros         = .N,
  
  # Estructura y Biodiversidad
  parcelas_mean       = round(mean(P14_TOTPARCELAS, na.rm = TRUE), 2),
  especies_mean       = round(mean(P14_TOTESPECIES, na.rm = TRUE), 2),
  
  # Categorías (% de productores)
  pct_arrendatarios   = round(mean(P110_3 == 1, na.rm = TRUE) * 100, 1),
  pct_uso_abono       = round(mean(P236 == 1, na.rm = TRUE) * 100, 1),
  pct_gasto_semilla   = round(mean(P235 == 1, na.rm = TRUE) * 100, 1),
  pct_semilla_propia  = round(mean(P235A == 1, na.rm = TRUE) * 100, 1)
), by = "NOMBREDD"]
cat("\n>>> PASO 4: Carga y limpieza de Shapefile...\n")
peru_deptos <- st_read(SHAPEFILE, options = "ENCODING=UTF-8", quiet = TRUE)
# Función de normalización ROBUSTA
limpiar_nombre <- function(x) {
  x <- toupper(trimws(x))
  x <- chartr("ÁÉÍÓÚÑÁÉÍÓÚ", "AEIOUNAEIOU", x)
  x <- iconv(x, to = "ASCII//TRANSLIT")
  x <- gsub("[^A-Z]", "", x) # Eliminar todo lo que no sea A-Z
  
  # Correcciones manuales para inconsistencias de la ENA
  dplyr::case_when(
    x %in% c("JUNAN", "JUNN") ~ "JUNIN",
    x %in% c("APURA", "APURMAC", "APURAMAC") ~ "APURIMAC",
    x %in% c("HUANCA", "HUANCAVELI", "HUANCAVEL") ~ "HUANCAVELICA",
    x %in% c("HUANU", "HUNUCO") ~ "HUANUCO",
    x %in% c("SANMARTAN", "SANMARTN") ~ "SANMARTIN",
    x == "AMAZON" ~ "AMAZONAS",
    TRUE ~ x
  )
}

peru_deptos$NOMBDEP <- limpiar_nombre(peru_deptos$NOMBDEP)
# FILTRO CRÍTICO: Eliminar Callao también del Shapefile para que no aparezca en el mapa
peru_deptos <- peru_deptos[!grepl("CALLAO", peru_deptos$NOMBDEP), ]

resumen_depto[, NOMBREDD := limpiar_nombre(NOMBREDD)]

# RE-AGREGACIÓN post-limpieza de nombres (para unir JUNAN y JUNIN por ej)
resumen_depto <- resumen_depto[, .(
  n_registros         = sum(n_registros),
  parcelas_mean       = round(mean(parcelas_mean, na.rm = TRUE), 2),
  especies_mean       = round(mean(especies_mean, na.rm = TRUE), 2),
  pct_arrendatarios   = round(mean(pct_arrendatarios, na.rm = TRUE), 1),
  pct_uso_abono       = round(mean(pct_uso_abono, na.rm = TRUE), 1),
  pct_gasto_semilla   = round(mean(pct_gasto_semilla, na.rm = TRUE), 1),
  pct_semilla_propia  = round(mean(pct_semilla_propia, na.rm = TRUE), 1)
), by = "NOMBREDD"]

cat("\n>>> PASO 5: Join Espacial...\n")
mapa_datos <- peru_deptos %>%
  left_join(as.data.frame(resumen_depto), by = c("NOMBDEP" = "NOMBREDD"))
# Guardar procesado intermedio para la etapa de presentación
saveRDS(mapa_datos, file.path(RESULTS_DIR, "mapa_datos_final.rds"))
write.csv(resumen_depto, file.path(RESULTS_DIR, "resumen_departamentos.csv"), row.names = FALSE)
cat("✓ Procesamiento completo. Objeto espacial guardado.\n")
rm(datos, datos_limpios, resumen_depto, mapa_datos)
gc()

