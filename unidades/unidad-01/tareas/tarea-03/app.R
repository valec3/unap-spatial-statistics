library(shiny)
library(bslib)
library(tidyverse)
library(plotly)

# 1. Búsqueda Inteligente de Rutas
find_csv <- function() {
  posibles_rutas <- c("Dataset_Final_UNAP_FULL.csv", "unidades/unidad-01/tareas/tarea-03/Dataset_Final_UNAP_FULL.csv")
  for (ruta in posibles_rutas) { if (file.exists(ruta)) return(ruta) }
  return(NULL)
}

csv_path <- find_csv()

if (is.null(csv_path)) {
  ui <- page_fluid(h1("Error: No se encontró Dataset_Final_UNAP_FULL.csv"))
  server <- function(...) {}
  shinyApp(ui, server)
} else {
  df_raw <- read_csv(csv_path, show_col_types = FALSE)
  
  # NORMALIZACIÓN DE DATOS (Traducción de términos de DairyPlan)
  df <- df_raw %>% 
  mutate(
    # Normalizar Status Reproductivo
    Status_Repro = case_when(
      Status_Repro %in% c("Preñ", "Preñ2", "VACAPREÑACTUAL") ~ "VACAPREÑACTUAL",
      Status_Repro %in% c("Insem", "Inseminada") ~ "INSEMINADA",
      TRUE ~ "VACIA"
    ),
    DIM = as.numeric(replace_na(DIM, "0")),
    Lact_N = as.numeric(replace_na(Lact_N, "0"))
  ) %>%
  mutate(
    Segmento_DIM = case_when(
      Status_Final != "EN ORDEÑO" ~ NA_character_,
      DIM < 200  ~ "Ordeño <200 d",
      DIM < 400  ~ "Ordeño 200-400 d",
      DIM < 600  ~ "Ordeño 400-600 d",
      TRUE       ~ "Ordeño >600 d"
    ),
    Segmento_Seca = case_when(
      Status_Final == "SECA" & Status_Repro == "VACAPREÑACTUAL" ~ "Seca Preñada",
      Status_Final == "SECA" & Status_Repro == "INSEMINADA"     ~ "Seca Insem",
      Status_Final == "SECA" ~ "Seca Vacia",
      TRUE ~ NA_character_
    ),
    LC_Group = case_when(
      Lact_N == 1 ~ "LC1",
      Lact_N == 2 ~ "LC2",
      Lact_N >= 3 ~ "LC 3M",
      TRUE ~ "RECRÍA"
    )
  )

  # UI Y SERVER
  ui <- page_fillable(
    theme = bs_theme(version = 5, bootswatch = "flatly", primary = "#002a54"),
    div(style = "display: flex; justify-content: space-around; padding: 15px; background: #002a54; color: white;",
      div(h4(nrow(df)), p("TOTAL ANIMALES", style="font-size:10px; opacity:0.8;")),
      div(h4(sum(df$Status_Final == "EN ORDEÑO")), p("EN ORDEÑO", style="font-size:10px; opacity:0.8;")),
      div(h4(sum(df$Status_Final == "SECA")), p("SECAS", style="font-size:10px; opacity:0.8;")),
      div(h4(sum(df$Status_Repro == "VACAPREÑACTUAL")), p("PREÑADAS", style="font-size:10px; opacity:0.8;"))
    ),
    layout_column_wrap(
      width = 1/3,
      card(card_header("REPRODUCCIÓN ACTUAL"), plotlyOutput("p1", height="240px")),
      card(card_header("ESTADO PRODUCTIVO"), plotlyOutput("p2", height="240px")),
      card(card_header("GRUPOS LACTANCIA"), plotlyOutput("p3", height="240px")),
      card(card_header("VACAS vs RECRÍA"), plotlyOutput("p4", height="240px")),
      card(card_header("DETALLE DIM"), plotlyOutput("p5", height="240px")),
      card(card_header("DETALLE SECAS"), plotlyOutput("p6", height="240px"))
    ),
    div(style = "display: flex; justify-content: center; align-items: center; padding: 20px; background: white; gap: 50px;",
        div(h2(round(mean(df$DIM[df$DIM > 0], na.rm=T), 2), style="color: #3498db;"), p("DEL PROMEDIO")),
        div(style = "border: 1px solid #ddd; border-radius: 40px; padding: 15px 50px;",
            h2(round(mean(df$Lact_N[df$Lact_N > 0], na.rm=T), 2)), p("LACTACIÓN PROMEDIO"))
    )
  )

  server <- function(input, output) {
    render_pie <- function(d, c, colors) {
      if(nrow(d) == 0) return(NULL)
      plot_ly(d %>% count(!!sym(c)), labels = ~get(c), values = ~n, type = 'pie', textinfo = 'percent', hole = 0.4, marker = list(colors = colors)) %>%
        layout(showlegend = T, legend = list(orientation = 'h', y = -0.1), margin = list(l=5, r=5, t=5, b=5))
    }
    output$p1 <- renderPlotly({ render_pie(df %>% filter(Tipo=="VACA"), "Status_Repro", c("#f39c12", "#f1c40f", "#bdc3c7")) })
    output$p2 <- renderPlotly({ render_pie(df %>% filter(Tipo=="VACA"), "Status_Final", c("#2ecc71", "#2c3e50", "#e74c3c")) })
    output$p3 <- renderPlotly({ render_pie(df %>% filter(Tipo=="VACA"), "LC_Group", c("#3498db", "#002a54", "#9b59b6")) })
    output$p4 <- renderPlotly({ render_pie(df, "Tipo", c("#002a54", "#3498db")) })
    output$p5 <- renderPlotly({ render_pie(df %>% filter(Status_Final=="EN ORDEÑO"), "Segmento_DIM", c("#3498db", "#2980b9", "#1f618d", "#1a5276")) })
    output$p6 <- renderPlotly({ render_pie(df %>% filter(Status_Final=="SECA"), "Segmento_Seca", c("#2ecc71", "#27ae60", "#1e8449")) })
  }
  shinyApp(ui, server)
}
