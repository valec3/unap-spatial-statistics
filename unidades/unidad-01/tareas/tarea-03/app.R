library(shiny)
library(bslib)
library(tidyverse)
library(plotly)
library(bsicons)
library(DT)

# 1. Búsqueda Inteligente y Carga de Datos
find_path <- function(file) {
  rutas <- c(file, paste0("unidades/unidad-01/tareas/tarea-03/", file), paste0("data-procesada/", file))
  for (r in rutas) { if (file.exists(r)) return(r) }
  return(NULL)
}

# Carga de Dataset Principal
csv_main <- find_path("Dataset_Final_UNAP_FULL.csv")
if (is.null(csv_main)) {
  ui <- page_fluid(h1("Error: No se encontró Dataset_Final_UNAP_FULL.csv"))
  server <- function(...) {}
  shinyApp(ui, server)
} else {
  df <- read_csv(csv_main, show_col_types = FALSE) %>%
    mutate(
      Status_Repro = case_when(
        Status_Repro %in% c("Preñ", "Preñ2", "VACAPREÑACTUAL") ~ "Preñada",
        Status_Repro %in% c("Insem", "Inseminada") ~ "Inseminada",
        TRUE ~ "Vacía"
      ),
      DIM = as.numeric(replace_na(DIM, "0")),
      Lact_N = as.numeric(replace_na(Lact_N, "0")),
      Leche_Total = as.numeric(replace_na(Leche_Total, "0")),
      Grupo = as.character(Grupo)
    )

  # Carga de Datasets Secundarios (Sanidad y Problemas)
  path_mastitis <- find_path("MASTITIS_LIMPIO.csv")
  df_mastitis <- if(!is.null(path_mastitis)) read_csv(path_mastitis, show_col_types = FALSE) else NULL
  
  path_problema <- find_path("VACAS_PROBLEMA_LIMPIO.csv")
  df_problema <- if(!is.null(path_problema)) read_csv(path_problema, show_col_types = FALSE) else NULL

  # UI Premium
  ui <- page_fillable(
    theme = bs_theme(
      version = 5, preset = "shiny", 
      primary = "#004b23", # Verde botella profundo
      secondary = "#386641",
      base_font = font_google("Inter"),
      heading_font = font_google("Outfit")
    ),
    
    tags$style("
      .nav-pills .nav-link { padding: 12px 20px; margin-bottom: 8px; border-radius: 10px; color: #444; transition: all 0.3s; font-weight: 500; }
      .nav-pills .nav-link.active { background-color: #004b23 !important; box-shadow: 0 4px 12px rgba(0,75,35,0.25); color: white !important; }
      .sidebar-title { padding: 30px 20px; border-bottom: 1px solid #eee; margin-bottom: 20px; background: #fff; text-align: center; }
      .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); margin-bottom: 20px; }
      .card-header { font-weight: 700; color: #004b23; text-transform: uppercase; letter-spacing: 0.5px; background: transparent; border-bottom: 1px solid #f0f0f0; }
      .value-box { border-radius: 15px !important; }
      body { background-color: #f8f9fa; }
      .navset-pill-list { padding-top: 10px; }
    "),

    div(class = "sidebar-title",
      div(style="display:flex; align-items:center; gap:12px; justify-content:center;",
        bsicons::bs_icon("water", size="2.5rem", color="#004b23"),
        div(style="text-align:left;",
          h3("SAUSALITO", style="margin:0; font-weight:900; color:#004b23; letter-spacing:-1px;"),
          p("Dairy Intelligence v3.0", style="margin:0; font-size:0.75rem; opacity:0.6;")
        )
      )
    ),

    navset_pill_list(
      id = "ultimate_nav",
      widths = c(2, 10),
      well = FALSE,
      
      # --- DASHBOARD ---
      nav_panel("Resumen General", icon = bsicons::bs_icon("house-door-fill"),
        layout_column_wrap(
          width = 1/4,
          value_box("Hato Total", nrow(df), showcase = bsicons::bs_icon("hash"), theme = "dark"),
          value_box("En Ordeño", sum(df$Status_Final == "EN ORDEÑO"), showcase = bsicons::bs_icon("droplet"), theme = "primary"),
          value_box("Gestantes", sum(df$Status_Repro == "Preñada"), showcase = bsicons::bs_icon("heart-pulse"), theme = "success"),
          value_box("Alertas DIM", sum(df$DIM > 400 & df$Status_Repro == "Vacía"), showcase = bsicons::bs_icon("exclamation-triangle"), theme = "danger")
        ),
        layout_column_wrap(
          width = 1/2,
          card(card_header("Estado General del Hato"), plotlyOutput("dash_pie", height="380px")),
          card(card_header("Distribución Reproductiva"), plotlyOutput("dash_repro", height="380px"))
        )
      ),

      # --- INVENTARIO ---
      nav_panel("Inventario Hato", icon = bsicons::bs_icon("journal-text"),
        layout_column_wrap(
          width = 1/3,
          card(card_header("Animales por Grupo"), plotlyOutput("inv_grupos", height="300px")),
          card(card_header("Categorías del Hato"), plotlyOutput("inv_cat", height="300px")),
          card(card_header("Métricas por Grupo"), card_body(tableOutput("inv_sum_table")))
        ),
        card(card_header("Explorador Maestro de Animales"), card_body(DTOutput("inv_dt")))
      ),

      # --- PRODUCCIÓN ---
      nav_panel("Producción Leche", icon = bsicons::bs_icon("bar-chart-fill"),
        layout_column_wrap(
          width = 1/2,
          card(card_header("Curva de Producción (Leche vs DIM)"), plotlyOutput("prod_scat", height="400px")),
          card(card_header("Distribución de Días en Leche"), plotlyOutput("prod_hist", height="400px"))
        ),
        layout_column_wrap(
          width = 1/3,
          card(card_header("Top 10 Productoras"), card_body(DTOutput("prod_top_dt"))),
          card(card_header("Prod. Media por Estado Repro."), plotlyOutput("prod_repro_bar", height="300px")),
          card(card_header("Composición por Lactancia"), plotlyOutput("prod_lact_pie", height="300px"))
        )
      ),

      # --- REPRODUCCIÓN ---
      nav_panel("Control Repro.", icon = bsicons::bs_icon("heart-fill"),
        layout_column_wrap(
          width = 1/2,
          card(card_header("Estado Repro. por Lactancia"), plotlyOutput("repro_lact_bar", height="400px")),
          card(card_header("Análisis de Vacas Secas"), plotlyOutput("repro_secas_pie", height="400px"))
        ),
        card(card_header("Vacas con Alerta Reproductiva (DIM > 100 y Vacías)"), card_body(DTOutput("repro_dt")))
      ),

      # --- SANIDAD (MASTITIS) ---
      nav_panel("Sanidad & Mastitis", icon = bsicons::bs_icon("shield-check"),
        if(!is.null(df_mastitis)) {
          tagList(
            layout_column_wrap(
              width = 1/3,
              value_box("Casos Registrados", nrow(df_mastitis), showcase = bsicons::bs_icon("activity"), theme="warning"),
              value_box("Días Enferma (Mediana)", round(median(as.numeric(df_mastitis$Dias_Enferma), na.rm=T), 1), showcase = bsicons::bs_icon("clock-history"), theme="info"),
              value_box("Fecha Últ. Evento", max(df_mastitis$Fecha_Evento, na.rm=T), showcase = bsicons::bs_icon("calendar-event"), theme="secondary")
            ),
            layout_column_wrap(
              width = 1/2,
              card(card_header("Tendencia de Casos en el Tiempo"), plotlyOutput("mast_hist_plot", height="350px")),
              card(card_header("Tipos de Eventos Recurrentes"), plotlyOutput("mast_word_bar", height="350px"))
            ),
            card(card_header("Bitácora Sanitaria Completa"), card_body(DTOutput("mast_dt")))
          )
        } else {
          div(class="alert alert-info", "No se encontró el archivo de datos de Mastitis.")
        }
      ),

      # --- VACAS PROBLEMA ---
      nav_panel("Vacas Problema", icon = bsicons::bs_icon("exclamation-diamond-fill"),
        if(!is.null(df_problema)) {
          tagList(
            layout_column_wrap(
              width = 1/4,
              value_box("Alertas Críticas", nrow(df_problema), showcase = bsicons::bs_icon("bug"), theme="danger"),
              value_box("Prod Media Crítica", paste0(round(mean(df_problema$Prod_24h, na.rm=T),1), " L"), showcase = bsicons::bs_icon("graph-down"), theme="secondary")
            ),
            layout_column_wrap(
              width = 1/2,
              card(card_header("Problemas por Grupo"), plotlyOutput("prob_group_bar", height="350px")),
              card(card_header("Re-Inseminaciones en Grupo Crítico"), plotlyOutput("prob_ins_hist", height="350px"))
            ),
            card(card_header("Panel de Acción: Vacas con Bajo Desempeño"), card_body(DTOutput("prob_dt")))
          )
        } else {
          div(class="alert alert-info", "No se encontró el archivo de Vacas Problema.")
        }
      )
    )
  )

  server <- function(input, output) {
    
    # --- DASHBOARD ---
    output$dash_pie <- renderPlotly({
      df %>% count(Status_Final) %>%
        plot_ly(labels = ~Status_Final, values = ~n, type = 'pie', hole = 0.6,
                marker = list(colors = c("#004b23", "#386641", "#a7c957"))) %>%
        layout(showlegend = T, margin = list(t=0, b=0))
    })
    
    output$dash_repro <- renderPlotly({
      df %>% filter(Status_Final == "EN ORDEÑO") %>% count(Status_Repro) %>%
        plot_ly(x = ~Status_Repro, y = ~n, type = 'bar', marker = list(color = "#6a994e"))
    })

    # --- INVENTARIO ---
    output$inv_grupos <- renderPlotly({
      df %>% count(Grupo) %>% plot_ly(x = ~Grupo, y = ~n, type = 'bar', marker = list(color = "#386641"))
    })
    
    output$inv_cat <- renderPlotly({
      df %>% count(Tipo) %>% plot_ly(labels = ~Tipo, values = ~n, type = 'pie', marker = list(colors = c("#1b4332", "#74c69d")))
    })
    
    output$inv_sum_table <- renderTable({
      df %>% group_by(Grupo) %>% 
        summarize(Vacas = n(), `Prod Media` = round(mean(Leche_Total, na.rm=T),1), `DIM Medio` = round(mean(DIM, na.rm=T),0))
    }, striped = T, hover = T, align = 'c', width = "100%")
    
    output$inv_dt <- renderDT({
      datatable(df, options = list(pageLength = 10, scrollX = TRUE, dom = 'Bfrtip'), rownames = F, class = "display compact cell-border hover")
    })

    # --- PRODUCCIÓN ---
    output$prod_scat <- renderPlotly({
      df %>% filter(Status_Final == "EN ORDEÑO" & Leche_Total > 0) %>%
        plot_ly(x = ~DIM, y = ~Leche_Total, color = ~Status_Repro, type = 'scatter', mode = 'markers', 
                marker = list(size = 10, opacity = 0.6, line = list(color = "white", width = 1)),
                text = ~paste("ID:", ID_Vaca, "<br>Lactancia:", Lact_N)) %>%
        layout(xaxis = list(title = "Días en Leche (DIM)"), yaxis = list(title = "Producción (L)"))
    })
    
    output$prod_hist <- renderPlotly({
      df %>% filter(Status_Final == "EN ORDEÑO") %>%
        plot_ly(x = ~DIM, type = 'histogram', marker = list(color = "#bc4749", line = list(color = "white", width = 1)))
    })
    
    output$prod_top_dt <- renderDT({
      df %>% arrange(desc(Leche_Total)) %>% select(ID_Vaca, Leche_Total, DIM, Grupo) %>% head(10) %>%
        datatable(options = list(dom = 't'), rownames = F)
    })
    
    output$prod_repro_bar <- renderPlotly({
      df %>% filter(Status_Final == "EN ORDEÑO") %>% group_by(Status_Repro) %>% summarize(avg = mean(Leche_Total, na.rm=T)) %>%
        plot_ly(x = ~Status_Repro, y = ~avg, type = 'bar', marker = list(color = "#a7c957"))
    })
    
    output$prod_lact_pie <- renderPlotly({
      df %>% count(Lact_N) %>% filter(Lact_N > 0) %>% plot_ly(labels = ~Lact_N, values = ~n, type = 'pie')
    })

    # --- REPRODUCCIÓN ---
    output$repro_lact_bar <- renderPlotly({
      df %>% filter(Lact_N > 0) %>% group_by(Lact_N, Status_Repro) %>% summarize(n = n()) %>%
        plot_ly(x = ~Lact_N, y = ~n, color = ~Status_Repro, type = 'bar') %>% layout(barmode = 'stack')
    })
    
    output$repro_secas_pie <- renderPlotly({
      df %>% filter(Status_Final == "SECA") %>% count(Status_Repro) %>% plot_ly(labels = ~Status_Repro, values = ~n, type = 'pie')
    })
    
    output$repro_dt <- renderDT({
      df %>% filter(Status_Repro != "Preñada" & DIM > 100) %>% select(ID_Vaca, DIM, Status_Repro, Grupo) %>%
        datatable(options = list(pageLength = 10), rownames = F)
    })

    # --- SANIDAD ---
    output$mast_dt <- renderDT({
      if(!is.null(df_mastitis)) datatable(df_mastitis, options = list(pageLength = 10, scrollX = T), rownames = F)
    })
    
    output$mast_hist_plot <- renderPlotly({
      if(!is.null(df_mastitis)) {
        df_mastitis %>% count(Fecha_Evento) %>% plot_ly(x = ~Fecha_Evento, y = ~n, type = 'scatter', mode = 'lines+markers', line = list(color="#bc4749"))
      }
    })
    
    output$mast_word_bar <- renderPlotly({
      if(!is.null(df_mastitis)) {
        df_mastitis %>% count(Comentario_1) %>% filter(!is.na(Comentario_1)) %>% head(8) %>% arrange(desc(n)) %>%
          plot_ly(x = ~reorder(Comentario_1, -n), y = ~n, type = 'bar', marker = list(color="#386641"))
      }
    })

    # --- VACAS PROBLEMA ---
    output$prob_dt <- renderDT({
      if(!is.null(df_problema)) datatable(df_problema, options = list(pageLength = 10, scrollX = T), rownames = F)
    })
    
    output$prob_group_bar <- renderPlotly({
      if(!is.null(df_problema)) {
        df_problema %>% count(Grupo) %>% plot_ly(x = ~Grupo, y = ~n, type = 'bar', marker = list(color = "#bc4749"))
      }
    })
    
    output$prob_ins_hist <- renderPlotly({
      if(!is.null(df_problema)) {
        df_problema %>% filter(!is.na(Nro_Inseminaciones)) %>%
          plot_ly(x = ~Nro_Inseminaciones, type = 'histogram', marker = list(color="#6a994e"))
      }
    })
  }

  shinyApp(ui, server)
}
