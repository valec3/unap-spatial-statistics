library(tidyverse)
library(pdftools)

input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VACAS PARA SECAR.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VACAS_PARA_SECAR_LIMPIO.csv"

cat("Procesando Vacas para Secar (Regex Fix)...\n")
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  if (str_detect(line, "DairyPlan|secarse|VACA|DIAS|Pág") || str_trim(line) == "") next
  # REGEX: VACA GP STATUS DIAS_L DIAS_S DIAS_P PROD FEC_S FEC_P
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)\\s+([A-Za-z0-9ñ ]{5,10})\\s+(\\d+)\\s+(-?\\d+)\\s+(-?\\d+)\\s+([\\d.]+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(\\d{1,2}-\\d{2}-\\d{2})")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Grupo = match[1,3],
      Estatus = str_trim(match[1,4]),
      DIM = match[1,5],
      Dias_al_Secado = as.numeric(match[1,6]),
      Dias_al_Parto = as.numeric(match[1,7]),
      Prod_Actual = as.numeric(match[1,8]),
      Fecha_Secado_Rec = match[1,9],
      Fecha_Parto_Est = match[1,10]
    )
  }
}
write_excel_csv(bind_rows(results) %>% distinct(), output_csv)
cat("Finalizado: VACAS PARA SECAR\n")
