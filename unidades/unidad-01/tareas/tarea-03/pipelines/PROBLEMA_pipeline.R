library(tidyverse)
library(pdftools)

input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VACAS PROBLEMA.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VACAS_PROBLEMA_LIMPIO.csv"

cat("Procesando Vacas Problema (Regex Fix)...\n")
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  if (str_detect(line, "DairyPlan|Problema|Vaca|N°|Pág") || str_trim(line) == "") next
  # REGEX: N° STATUS GP DIM FECHA_P COMS PROD DIM1 DIM2 N_INS FECHA_I
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+([A-Za-zñ]+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})?\\s*(.*)?\\s+([\\d.]+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Estatus = match[1,3],
      Grupo = match[1,4],
      DIM = match[1,5],
      Fecha_Ult_Parto = match[1,6],
      Comentarios = str_trim(match[1,7]),
      Prod_24h = as.numeric(match[1,8]),
      Nro_Inseminaciones = as.numeric(match[1,11]),
      Fecha_Ult_Insem = match[1,12]
    )
  }
}
write_excel_csv(bind_rows(results) %>% distinct(), output_csv)
cat("Finalizado: VACAS PROBLEMA\n")
