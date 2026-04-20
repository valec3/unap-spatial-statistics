library(shiny)
library(bslib)
library(plotly)
library(tidyverse)
library(gridExtra)
library(grid)

# Carga de datos con detección de ruta
output_path <- if (dir.exists("Output")) "Output" else "unidades/unidad-01/temp/Output"
resumen <- read_csv(file.path(output_path, "Resumen_KPIs_Julio2025.csv"), show_col_types = FALSE)
detalle <- read_csv(file.path(output_path, "Dataset_Ganadero_V2.csv"), show_col_types = FALSE)

# Definición del Tema UNAP (Moderno & Premium)
unap_theme <- bs_theme(
  version = 5,
  bootswatch = "zephyr",
  primary = "#0056b3",
  base_font = font_google("Inter")
)

ui <- page_navbar(
  theme = unap_theme,
  title = "Dashboard Ganadero - UNAP",
  fillable = FALSE,
  
  # Botón de Descarga en el Navbar
  nav_item(
    downloadButton("descargar_pdf", "Exportar Reporte PDF", class = "btn-success btn-sm", style = "margin-top: 8px;")
  ),
  
  nav_panel("Resumen Ejecutivo",
    layout_columns(
      value_box(
        title = "DEL Promedio",
        value = resumen$DEL_Promedio,
        showcase = icon("calendar-day"),
        theme = "primary"
      ),
      value_box(
        title = "Lactación Promedio",
        value = resumen$Lactacion_Promedio,
        showcase = icon("cow"),
        theme = "info"
      ),
      value_box(
        title = "Población Total",
        value = resumen$Poblacion_Total,
        showcase = icon("layer-group"),
        theme = "dark"
      ),
      value_box(
        title = "Casos Mastitis",
        value = sum(as.numeric(detalle$Conteo_Mastitis), na.rm = TRUE),
        showcase = icon("hand-dots"),
        theme = "danger"
      )
    ),
    
    layout_columns(
        card(
          card_header("Estado de Preñez (Vacas Adultas)"),
          plotlyOutput("pie_preniez")
        ),
        card(
          card_header("Estado de Producción (Vacas)"),
          plotlyOutput("pie_produccion")
        ),
        card(
          card_header("Distribución Lactaciones (LC)"),
          plotlyOutput("pie_lc")
        ),
        col_widths = c(4, 4, 4)
    ),
    
    layout_columns(
        card(
          card_header("Composición del Rebaño"),
          plotlyOutput("pie_poblacion")
        ),
        card(
          card_header("Estado Productivo Detalle"),
          plotlyOutput("pie_detalle")
        ),
        card(
          card_header("Variables Climáticas (Julio 2025)"),
          tableOutput("tabla_clima")
        ),
        col_widths = c(4, 4, 4)
    )
  ),
  
  nav_spacer(),
  nav_item(
    span(paste0("Ubicación: ", resumen$Codigo), style = "font-weight: bold; padding-right: 15px;")
  )
)

server <- function(input, output, session) {
  
  # --- Lógica de Gráficos ---
  output$pie_preniez <- renderPlotly({
    plot_ly(labels = c("Preñada", "Vacía"), 
            values = c(resumen$Vacas_Preniadas, resumen$Vacas_Vacias), 
            type = 'pie',
            marker = list(colors = c("#f39c12", "#f1c40f"))) %>%
      layout(margin = list(l = 20, r = 20, b = 20, t = 20))
  })
  
  output$pie_produccion <- renderPlotly({
    plot_ly(labels = c("Ordeño", "Seca"), 
            values = c(resumen$Vacas_Ordenio, resumen$Vacas_Secas), 
            type = 'pie',
            marker = list(colors = c("#2ecc71", "#2c3e50"))) %>%
      layout(margin = list(l = 20, r = 20, b = 20, t = 20))
  })
  
  output$pie_lc <- renderPlotly({
    plot_ly(labels = c("LC1", "LC2", "LC 3M"), 
            values = c(103, 64, 70), 
            type = 'pie', hole = 0.6,
            marker = list(colors = c("#002a54", "#2c3e50", "#3498db"))) %>%
      layout(margin = list(l = 20, r = 20, b = 20, t = 20))
  })
  
  output$pie_poblacion <- renderPlotly({
    plot_ly(labels = c("Vacas Total", "Recría Total"), 
            values = c(resumen$Vacas_Total, resumen$Recria_Total), 
            type = 'pie',
            marker = list(colors = c("#002a54", "#3498db"))) %>%
      layout(margin = list(l = 20, r = 20, b = 20, t = 20))
  })
  
  output$pie_detalle <- renderPlotly({
    plot_ly(labels = c("Ordeño<60DEL", "Ordeño>60DEL", "Insem", "Preñada"), 
            values = c(66, 40, 38, 51), 
            type = 'pie',
            marker = list(colors = c("#3498db", "#2c3e50", "#e74c3c", "#9b59b6"))) %>%
      layout(margin = list(l = 20, r = 20, b = 20, t = 20))
  })
  
  output$tabla_clima <- renderTable({
    resumen %>%
      select(Temp_Min, Temp_Max, ITH_Min, ITH_Max, Humedad_Prom) %>%
      pivot_longer(everything(), names_to = "Variable", values_to = "Valor") %>%
      mutate(Variable = str_replace_all(Variable, "_", " "))
  }, striped = TRUE, width = "100%")

  # --- Lógica de Exportación PDF ---
  output$descargar_pdf <- downloadHandler(
    filename = function() {
      paste0("Reporte_Ganadero_Julio_2025_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      # Usamos el motor grid para generar el PDF nativo
      pdf(file, width = 11, height = 8.5)
      
      # Título
      grid.text("Reporte Consolidado DairyPlan - Julio 2025 - UNAP", x = 0.5, y = 0.95, 
                gp = gpar(fontsize = 16, fontface = "bold"))
      
      # Replicamos los gráficos usando ggplot2 (para el PDF)
      theme_pdf <- function() theme_void() + theme(plot.title = element_text(hjust=0.5, face="bold", size=10))
      
      p1 <- ggplot(data.frame(c=c("Preñ", "Vac"), v=c(88, 149)), aes(x="", y=v, fill=c)) +
        geom_bar(stat="identity", width=1) + coord_polar("y") + theme_pdf() + labs(title="PREÑEZ") +
        scale_fill_manual(values=c("#f39c12", "#f1c40f"))
      
      p2 <- ggplot(data.frame(c=c("Ord", "Sec"), v=c(195, 42)), aes(x="", y=v, fill=c)) +
        geom_bar(stat="identity", width=1) + coord_polar("y") + theme_pdf() + labs(title="PRODUCCIÓN") +
        scale_fill_manual(values=c("#2ecc71", "#2c3e50"))
      
      p3 <- ggplot(data.frame(c=c("Vacas", "Recria"), v=c(237, 257)), aes(x="", y=v, fill=c)) +
        geom_bar(stat="identity", width=1) + coord_polar("y") + theme_pdf() + labs(title="POBLACIÓN") +
        scale_fill_manual(values=c("#002a54", "#3498db"))
      
      # KPIs
      kpi_del <- textGrob(paste("DEL PROMEDIO\n", resumen$DEL_Promedio), gp=gpar(fontsize=18, fontface="bold", col="#0056b3"))
      kpi_lac <- textGrob(paste("LACTACION PROMEDIO\n", resumen$Lactacion_Promedio), gp=gpar(fontsize=18, fontface="bold", col="#0056b3"))
      
      grid.arrange(p1, p2, p3, kpi_del, kpi_lac, ncol=3, nrow=2)
      
      dev.off()
    }
  )
}

shinyApp(ui, server)
