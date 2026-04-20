library(tidyverse)
library(ggplot2)
library(gridExtra)
library(grid)

# Carga de datos con detección de ruta
output_path <- if (dir.exists("Output")) "Output" else "unidades/unidad-01/temp/Output"
resumen <- read_csv(file.path(output_path, "Resumen_KPIs_Julio2025.csv"), show_col_types = FALSE)

# Configuración de Colores
colors_repro <- c("Preñada" = "#f39c12", "Vacía" = "#f1c40f")
colors_prod <- c("Ordeño" = "#2ecc71", "Seca" = "#2c3e50")
colors_pob <- c("Vacas Total" = "#002a54", "Recría Total" = "#3498db")

# 1. Gráficos base
theme_unap_report <- function() {
  theme_void() + theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 10, margin = margin(b=5)))
}

# Pie Chart 1
df1 <- data.frame(Cat = c("Preñada", "Vacía"), Val = c(resumen$Vacas_Preniadas, resumen$Vacas_Vacias))
p1 <- ggplot(df1, aes(x="", y=Val, fill=Cat)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_unap_report() +
  scale_fill_manual(values=colors_repro) +
  labs(title="VACAPREÑACTUAL")

# Pie Chart 2
df2 <- data.frame(Cat = c("Ordeño", "Seca"), Val = c(resumen$Vacas_Ordenio, resumen$Vacas_Secas))
p2 <- ggplot(df2, aes(x="", y=Val, fill=Cat)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_unap_report() +
  scale_fill_manual(values=colors_prod) +
  labs(title="VACAS ORDEÑO / SECA")

# Pie Chart 3
df3 <- data.frame(Cat = c("Vacas Total", "Recría Total"), Val = c(resumen$Vacas_Total, resumen$Recria_Total))
p3 <- ggplot(df3, aes(x="", y=Val, fill=Cat)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_unap_report() +
  scale_fill_manual(values=colors_pob) +
  labs(title="POBLACIÓN TOTAL")

# KPI Boxes (Simuladas con texto y formas)
kpi_box <- function(title, value, unit) {
  grob_title <- textGrob(title, gp = gpar(fontsize = 10, col = "grey40"))
  grob_value <- textGrob(format(value, big.mark=","), gp = gpar(fontsize = 28, fontface = "bold", col = "#3498db"))
  grob_unit <- textGrob(unit, gp = gpar(fontsize = 9, col = "grey40"))
  arrangeGrob(grob_title, grob_value, grob_unit, ncol=1)
}

kpi_del <- kpi_box("DEL PROMEDIO", resumen$DEL_Promedio, "")
kpi_lact <- kpi_box("LACTACION PROMEDIO", resumen$Lactacion_Promedio, "")

# Tabla de Clima (Grob)
clima_table <- tableGrob(
  data.frame(
    Variable = c("Temp Min/Max", "ITH Min/Max", "Humedad"),
    Valor = c(paste(resumen$Temp_Min, "/", resumen$Temp_Max),
              paste(resumen$ITH_Min, "/", resumen$ITH_Max),
              paste(resumen$Humedad_Prom, "%"))
  ),
  rows = NULL,
  theme = ttheme_minimal(base_size = 9)
)

# Generar PDF final
pdf_path <- if (dir.exists("Output")) "result-01.pdf" else "unidades/unidad-01/temp/result-01.pdf"
pdf(pdf_path, width = 11, height = 8.5)

# Título Superior
grid.text("Reporte de Estadísticas Espaciales - Julio 2025 - UNAP", x = 0.5, y = 0.95, 
          gp = gpar(fontsize = 16, fontface = "bold"))
grid.text(paste0("Ubicación: ", resumen$Codigo), x = 0.5, y = 0.91, gp = gpar(fontsize = 10))

# Disposición en rejilla
grid.arrange(
  p1, p2, p3,
  kpi_del, kpi_lact, clima_table,
  ncol = 3,
  nrow = 2,
  padding = unit(2, "line")
)

dev.off()

cat("\nReporte PDF generado exitosamente en: unidades/unidad-01/temp/result-01.pdf\n")
