library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VACAS GESTANTES.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VACAS_GESTANTES_LIMPIO.csv"

cat("Iniciando procesamiento de Vacas Gestantes (Custom Regex)...\n")

text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  line_trim <- str_trim(line)
  if (line_trim == "" || str_detect(line, "DairyPlan|Gestantes|VACA|Nro.|Pág")) next

  # REGEX Corregida para Gestantes:
  # VACA(1) LO(2) NoLk(3) FECHA_PARTO(4) DIAS_LECH(5) ESTATUS(6) DIA_GEST(7) ... NRO_IN(9) DIAS_AB(10) PROM(11)
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(\\d+)\\s+([A-Za-zñ]+)\\s+(\\d+)\\s*(.*)?\\s+(\\d+)\\s+(\\d+)\\s+([\\d.]+)")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Localidad = match[1,3],
      Lact_N = match[1,4],
      Fecha_Parto_Ant = match[1,5],
      DIM = match[1,6],
      Estatus = match[1,7],
      Dias_Gestacion = match[1,8],
      Servicios = match[1,10],
      Dias_Abiertos = match[1,11],
      Prod_Promedio = match[1,12]
    )
  }
}

df_final <- bind_rows(results) %>% distinct()
write_excel_csv(df_final, output_csv)
cat("Archivo generado con", nrow(df_final), "registros en data-procesada.\n")
