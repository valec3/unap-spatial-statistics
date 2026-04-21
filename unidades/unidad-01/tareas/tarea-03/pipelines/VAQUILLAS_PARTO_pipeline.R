library(tidyverse)
library(pdftools)

input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VAQUILLAS PROXIMAS AL PARTO.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VAQUILLAS_PARTO_LIMPIO.csv"

cat("Procesando Vaquillas Parto (Regex Fix)...\n")
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  if (str_detect(line, "DairyPlan|proximas|VACA|NUM|Pág") || str_trim(line) == "") next
  # NUM GP NOMBRE ESTATUS EDAD_1I FECHA_I COMS DIAS_I FECHA_PE FALTAN EDAD_P
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)\\s+([A-Z0-9 ]{5,15})\\s+([A-Za-zñ]+)\\s+([\\d.]+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+([A-Z0-9 ]{5,12})\\s+(\\d+)?\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(-?\\d+)\\s+([\\d.]+)")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Grupo = match[1,3],
      Nombre = str_trim(match[1,4]),
      Estatus = match[1,5],
      Edad_1ra_Ins = as.numeric(match[1,6]),
      Fecha_Insem = match[1,7],
      Toro = str_trim(match[1,8]),
      Fecha_Parto_Est = match[1,10],
      Dias_Faltan = as.numeric(match[1,11]),
      Edad_Est_Parto = as.numeric(match[1,12])
    )
  }
}
write_excel_csv(bind_rows(results) %>% distinct(), output_csv)
cat("Finalizado: VAQUILLAS PROXIMAS AL PARTO\n")
