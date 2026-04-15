paquetes <- c(
  "tidyverse",   # Incluye dplyr, ggplot2, readr, entre otros
  "haven",       # Recomendado sobre 'foreign' para archivos .sav modernos
  "sf",          # Datos espaciales y shapefiles
  "ggspatial",   # Escala y flecha de norte para mapas
  "viridis",     # Paletas de colores accesibles
  "readxl",      # Leer archivos Excel
  "rnaturalearth", #
  "data.table"
)

# Instalar los que no estén presentes y cargarlos todos
instalados <- paquetes %in% installed.packages()[, "Package"]
if (any(!instalados)) {
  install.packages(paquetes[!instalados])
}
# cargar librerias
lapply(paquetes, library, character.only = TRUE)


# PASO 1: Leer SOLO las columnas necesarias desde el inicio
# Primero identificar el índice de las columnas para no cargar todo

ruta_datos <- "D:/descargas/ENA_2014_2024/data/ENA_2014_2024.sav"
variables_req <- c("NOMBREDD", "CCDD", "P14_TOTPARCELAS", "P103", "P235", "P236")

cat("Leyendo datos de forma optimizada...\n")

# read_sav permite col_select para no saturar la RAM
datos <- read_sav(
  ruta_datos,
  col_select = all_of(variables_req), 
  encoding = "latin1"
)
cat("Dimensiones brutas:", dim(datos), "\n")
cat("Columnas disponibles con 'NOMBRE':\n")
print(grep("NOMBRE", names(datos), value = TRUE))
cat("Columnas disponibles con 'DD':\n")
print(grep("DD", names(datos), value = TRUE))


# PASO 2: Convertir a data.table para procesamiento ultra rápido
setDT(datos)
# PASO 3: Limpieza inmediata de memoria
gc() # Liberar RAM que haya quedado atrapada
# Verificar carga
print(object.size(datos), units = "Mb")
sample(datos)


# Resumen de nulos por columna
colSums(is.na(datos))
# Porcentaje de nulos por columna
colMeans(is.na(datos)) * 100


datos_limpios <- na.omit(datos)

# Verificar cuáles existen realmente
cols_ok <- intersect(variables_req, names(datos_limpios))
cols_faltantes <- setdiff(variables_req, names(datos_limpios))
cat("\nColumnas encontradas:", cols_ok, "\n")
cat("Columnas NO encontradas:", cols_faltantes, "\n")

# Quedarse SOLO con columnas necesarias → libera memoria masivamente
datos <- as.data.table(datos_limpios[, cols_ok])
gc()

cat("Dimensiones tras reducción:", dim(datos_limpios), "\n")
cat("RAM usada (MB):", round(object.size(datos_limpios) / 1e6, 1), "\n")

# -------------------------------------------------------------------------
# PASO 2: VERIFICAR NOMBREDD
# -------------------------------------------------------------------------
cat("\nValores únicos de NOMBREDD:\n")
print(sort(unique(datos_limpios[["NOMBREDD"]])))
cat("Total departamentos únicos:", uniqueN(datos_limpios[["NOMBREDD"]]), "\n")

# -------------------------------------------------------------------------
# PASO 3: CONVERTIR NUMÉRICAS
# -------------------------------------------------------------------------
cols_numericas <- c("P14_TOTPARCELAS", "P103", "P235", "P236")
for (col in intersect(cols_numericas, names(datos_limpios))) {
  datos_limpios[[col]] <- suppressWarnings(as.numeric(as.character(datos_limpios[[col]])))
}

# -------------------------------------------------------------------------
# PASO 4: AGREGAR POR DEPARTAMENTO
# -------------------------------------------------------------------------
cat("\nAgregando por departamento...\n")

resumen_depto <- datos_limpios[, .(
  n_registros         = .N,
  total_parcelas_mean = round(mean(P14_TOTPARCELAS, na.rm = TRUE), 2),
  total_parcelas_sum  = sum(P14_TOTPARCELAS,         na.rm = TRUE),
  P103_mean           = round(mean(P103, na.rm = TRUE), 2),
  P235_mean           = round(mean(P235, na.rm = TRUE), 2),
  P236_mean           = round(mean(P236, na.rm = TRUE), 2),
  P235_sum            = sum(P235,        na.rm = TRUE),
  P236_sum            = sum(P236,        na.rm = TRUE)
), by = "NOMBREDD"]

setorder(resumen_depto, -n_registros)

cat("\nResumen por departamento:\n")
print(resumen_depto)
cat("\nTotal departamentos:", nrow(resumen_depto), "\n")

# Liberar datos crudos
rm(datos_limpios)
rm(datos)
gc()

# -------------------------------------------------------------------------
# PASO 5: RECARGAR SHAPEFILE LIMPIO Y HACER JOIN
# -------------------------------------------------------------------------
peru_deptos <- st_read("D:\\descargas\\DEPARTAMENTOS_inei_geogpsperu_suyopomalia.shp",
                       options = "ENCODING=UTF-8")
names(peru_deptos)

limpiar_nombre <- function(x) {
  x <- toupper(trimws(x))
  x <- chartr("ÁÉÍÓÚÑÁÉÍÓÚ", "AEIOUNAEIOU", x)
  x <- iconv(x, to = "ASCII//TRANSLIT")
  x <- gsub("[^A-Z ]", "", x)
  x <- trimws(x)
  x
}

peru_deptos$NOMBDEP         <- limpiar_nombre(peru_deptos$NOMBDEP)
resumen_depto[["NOMBREDD"]] <- limpiar_nombre(resumen_depto[["NOMBREDD"]])

# Diagnóstico lado a lado
cat("=== SHAPEFILE (NOMBDEP) ===\n"); print(sort(peru_deptos$NOMBDEP))
cat("\n=== ENA (NOMBREDD) ===\n");    print(sort(resumen_depto[["NOMBREDD"]]))

# Join
mapa_datos <- peru_deptos %>%
  left_join(as.data.frame(resumen_depto), by = c("NOMBDEP" = "NOMBREDD"))

# Verificar matches
sin_match <- mapa_datos$NOMBDEP[is.na(mapa_datos$n_registros)]
cat("\nDepartamentos sin match:", length(sin_match), "\n")
if (length(sin_match) > 0) {
  cat("Sin match:\n"); print(sin_match)
}
cat("\nPrimeras filas del join:\n")
print(head(mapa_datos[, c("NOMBDEP", "n_registros", "total_parcelas_mean")]))

# -------------------------------------------------------------------------
# PASO 6: FUNCIÓN DE MAPAS CON ETIQUETAS NUMÉRICAS
# -------------------------------------------------------------------------
crear_mapa_ena <- function(datos_sf, variable, titulo,
                           subtitulo = "", etiqueta_leyenda = variable,
                           paleta = "viridis", decimales = 1) {
  
  if (!variable %in% names(datos_sf)) stop(paste("Variable no encontrada:", variable))
  
  # Centroides para etiquetas
  centroides <- datos_sf %>%
    st_centroid(of_largest_polygon = TRUE) %>%
    mutate(
      lon      = st_coordinates(.)[, 1],
      lat      = st_coordinates(.)[, 2],
      etiqueta = ifelse(
        is.na(.data[[variable]]), "SD",
        formatC(.data[[variable]], format = "f", digits = decimales, big.mark = ",")
      )
    )
  
  ggplot(datos_sf) +
    geom_sf(aes(fill = .data[[variable]]),
            color = "white", linewidth = 0.4) +
    # Nombre departamento
    geom_text(data = centroides,
              aes(x = lon, y = lat, label = NOMBDEP),
              size = 1.8, fontface = "bold", color = "grey10",
              vjust = -0.3, lineheight = 0.8) +
    # Valor numérico
    geom_text(data = centroides,
              aes(x = lon, y = lat, label = etiqueta),
              size = 2.1, fontface = "bold", color = "white",
              vjust = 1.1) +
    scale_fill_viridis_c(
      name     = etiqueta_leyenda,
      option   = paleta,
      na.value = "grey80",
      labels   = scales::comma
    ) +
    annotation_scale(location = "bl", width_hint = 0.25) +
    annotation_north_arrow(location = "tr",
                           style    = north_arrow_fancy_orienteering(),
                           height   = unit(1, "cm"),
                           width    = unit(1, "cm")) +
    coord_sf(expand = FALSE) +
    theme_void(base_size = 12) +
    theme(
      plot.title       = element_text(face = "bold", size = 14, hjust = 0.5,
                                      margin = margin(b = 5)),
      plot.subtitle    = element_text(size = 10, hjust = 0.5, color = "grey40",
                                      margin = margin(b = 10)),
      plot.caption     = element_text(size = 7, color = "grey60"),
      plot.margin      = margin(10, 10, 10, 10),
      legend.position  = "right",
      legend.title     = element_text(size = 9),
      plot.background  = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "#cce5f0", color = NA)
    ) +
    labs(title    = titulo,
         subtitle = subtitulo,
         caption  = "Fuente: ENA 2014-2024 | INEI Perú")
}

# -------------------------------------------------------------------------
# PASO 7: GENERAR LOS 4 MAPAS
# -------------------------------------------------------------------------
m1 <- crear_mapa_ena(mapa_datos, "total_parcelas_mean",
                     "Promedio de Parcelas por Productor",
                     "Variable P14_TOTPARCELAS - ENA 2014-2024",
                     "Nº parcelas\n(promedio)", "plasma",  decimales = 1)

m2 <- crear_mapa_ena(mapa_datos, "P103_mean",
                     "Variable P103 - Promedio por Departamento",
                     "ENA 2014-2024",
                     "P103\n(promedio)",        "viridis", decimales = 1)

m3 <- crear_mapa_ena(mapa_datos, "P235_sum",
                     "Variable P235 - Total por Departamento",
                     "ENA 2014-2024",
                     "P235\n(total)",           "magma",   decimales = 0)

m4 <- crear_mapa_ena(mapa_datos, "P236_sum",
                     "Variable P236 - Total por Departamento",
                     "ENA 2014-2024",
                     "P236\n(total)",           "inferno", decimales = 0)

print(m1); print(m2); print(m3); print(m4)

# -------------------------------------------------------------------------
# PASO 8: GUARDAR
# -------------------------------------------------------------------------
ruta_salida <- "D:/descargas/resultados_ENA/"
dir.create(ruta_salida, showWarnings = FALSE, recursive = TRUE)

ggsave(paste0(ruta_salida, "mapa_parcelas.png"), m1,
       width = 10, height = 12, dpi = 300, bg = "white")
ggsave(paste0(ruta_salida, "mapa_P103.png"),     m2,
       width = 10, height = 12, dpi = 300, bg = "white")
ggsave(paste0(ruta_salida, "mapa_P235.png"),     m3,
       width = 10, height = 12, dpi = 300, bg = "white")
ggsave(paste0(ruta_salida, "mapa_P236.png"),     m4,
       width = 10, height = 12, dpi = 300, bg = "white")

write.csv(as.data.frame(resumen_depto),
          paste0(ruta_salida, "resumen_departamentos.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

cat("\n✓ Listo. Archivos guardados en:", ruta_salida, "\n")













# -------------------------------------------------------------------------
# DIAGNÓSTICO PROFUNDO DE NULOS
# -------------------------------------------------------------------------

# 1. Ver si los nulos se concentran en años específicos
# (la ENA suele tener una variable de año o periodo)
cat("Columnas que pueden indicar año/periodo:\n")
print(grep("AÑO|ANO|YEAR|PERIODO|ANIO", names(datos), 
           value = TRUE, ignore.case = TRUE))

# 2. Cruzar nulos con departamento
# ¿Hay departamentos con más datos que otros?
cat("\n% de nulos por departamento en P14_TOTPARCELAS:\n")
nulos_depto <- datos[, .(
  total        = .N,
  nulos_P14    = sum(is.na(P14_TOTPARCELAS)),
  nulos_P103   = sum(is.na(P103)),
  nulos_P235   = sum(is.na(P235)),
  nulos_P236   = sum(is.na(P236)),
  pct_nulo_P14 = round(mean(is.na(P14_TOTPARCELAS)) * 100, 1),
  pct_nulo_P235= round(mean(is.na(P235)) * 100, 1)
), by = NOMBREDD]
setorder(nulos_depto, -pct_nulo_P14)
print(nulos_depto)

# 3. Ver cuántos registros VÁLIDOS quedan por variable
cat("\nRegistros válidos (no-NA) por variable:\n")
cat("P14_TOTPARCELAS:", sum(!is.na(datos$P14_TOTPARCELAS)), "\n")
cat("P103:          ", sum(!is.na(datos$P103)), "\n")
cat("P235:          ", sum(!is.na(datos$P235)), "\n")
cat("P236:          ", sum(!is.na(datos$P236)), "\n")

# 4. Ver si los valores válidos son coherentes (no ceros disfrazados)
cat("\nDistribución de valores NO nulos:\n")
for (col in c("P14_TOTPARCELAS", "P103", "P235", "P236")) {
  vals <- datos[[col]][!is.na(datos[[col]])]
  if (length(vals) > 0) {
    cat(sprintf("\n%s (n=%s):\n", col, format(length(vals), big.mark=",")))
    print(summary(vals))
  }
}
