# =========================================================================
# ETAPA 3: REPORTE Y PRESENTACIÓN (CRISP-DM: Evaluation/Deployment)
# Objetivo: Generación de visualizaciones premium y reportes
# =========================================================================

source("00_setup.R")

cat("\n>>> Cargando datos procesados...\n")
ruta_rds <- file.path(RESULTS_DIR, "mapa_datos_final.rds")
if (!file.exists(ruta_rds)) stop("No se encuentra el archivo procesado. Corre 02_processing.R primero.")

mapa_datos <- readRDS(ruta_rds)

# -------------------------------------------------------------------------
# FUNCIÓN DE VISUALIZACIÓN PREMIUM - CON MAXIMA LEGIBILIDAD
# -------------------------------------------------------------------------
crear_mapa_premium <- function(datos_sf, variable, titulo, 
                               paleta = "viridis", decimales = 1, unidad = "") {
  
  # Centroides para etiquetas
  centroides <- datos_sf %>%
    st_centroid(of_largest_polygon = TRUE) %>%
    mutate(
      lon = st_coordinates(.)[, 1],
      lat = st_coordinates(.)[, 2],
      valor = .data[[variable]],
      etiqueta = ifelse(is.na(valor), "S/D", 
                        paste0(formatC(valor, format = "f", digits = decimales, big.mark = ","), unidad))
    )
  
  ggplot(datos_sf) +
    geom_sf(aes(fill = .data[[variable]]), color = "white", linewidth = 0.2) +
    # NOMBRES DE DEPARTAMENTO: Fondo casi opaco para lectura perfecta
    geom_label(data = centroides, aes(x = lon, y = lat, label = NOMBDEP),
               size = 2.4, fontface = "bold", fill = alpha("white", 0.9),
               label.padding = unit(0.08, "lines"), vjust = -1.3, color = "black") +
    # VALORES NUMÉRICOS: Fondo blanco total para contraste máximo
    geom_label(data = centroides, aes(x = lon, y = lat, label = etiqueta),
               size = 3.0, fontface = "bold", fill = "white", 
               label.padding = unit(0.12, "lines"), vjust = 0.5, color = "darkblue") +
    scale_fill_viridis_c(option = paleta, na.value = "grey90", labels = scales::comma) +
    annotation_scale(location = "bl") +
    annotation_north_arrow(location = "tr", style = north_arrow_minimal()) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "darkblue"),
      plot.subtitle = element_text(size = 11, hjust = 0.5, face = "italic"),
      panel.background = element_rect(fill = "#fdfdfd", color = NA), # Fondo casi blanco
      legend.position = "right"
    ) +
    labs(title = titulo, subtitle = "Análisis Estratégico ENA 2014-2024 (INEI)", fill = unidad)
}

cat("\n>>> Generando los 4 Mapas Estratégicos...\n")

# Mapa 1: Estructura de Tierra (Promedio Parcelas)
m1 <- crear_mapa_premium(mapa_datos, "parcelas_mean", "Promedio de Parcelas por Productor", "mako")
ggsave(file.path(RESULTS_DIR, "mapa_01_parcelas.png"), m1, width = 10, height = 12, dpi = 300)

# Mapa 2: Régimen de Tenencia (Arrendatarios)
m2 <- crear_mapa_premium(mapa_datos, "pct_arrendatarios", "Prevalencia de Arrendamiento Agrícola", "rocket", unidad = "%")
ggsave(file.path(RESULTS_DIR, "mapa_02_arrendamiento.png"), m2, width = 10, height = 12, dpi = 300)

# Mapa 3: Inversión en Productividad (Uso de Abono)
m3 <- crear_mapa_premium(mapa_datos, "pct_uso_abono", "Nivel de Fertilización / Uso de Abono", "viridis", unidad = "%")
ggsave(file.path(RESULTS_DIR, "mapa_03_abono.png"), m3, width = 10, height = 12, dpi = 300)

# Mapa 4: Dependencia de Insumos Externos (Gasto en Semilla)
m4 <- crear_mapa_premium(mapa_datos, "pct_gasto_semilla", "Inversión en Adquisición de Semillas", "magma", unidad = "%")
ggsave(file.path(RESULTS_DIR, "mapa_04_semillas.png"), m4, width = 10, height = 12, dpi = 300)

cat("\n✓ Mapas generados exitosamente en la carpeta 'results'.\n")
