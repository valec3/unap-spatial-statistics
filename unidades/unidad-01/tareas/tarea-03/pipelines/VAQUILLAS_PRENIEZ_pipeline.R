library(tidyverse)
library(pdftools)

input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VAQUILLAS PARA TEST DE PREÑEZ.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VAQUILLAS_PRENIEZ_LIMPIO.csv"

cat("Procesando Vaquillas Preñez (Regex Fix)...\n")
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  if (str_detect(line, "DairyPlan|Preñez|Vaque|Vaca|Pág") || str_trim(line) == "") next
  # VACA REG STAT GP EDAD_1I N_INS FECHA_I DIAS_I EDAD_A
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d{3,5})?\\s+([A-Za-zñ]+)\\s+(\\d+)\\s+([\\d.]+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(\\d+)\\s+([\\d.]+)")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Reg = match[1,3],
      Estatus = match[1,4],
      Grupo = match[1,5],
      Edad_1ra_Ins = as.numeric(match[1,6]),
      Nro_Inseminaciones = as.numeric(match[1,7]),
      Fecha_Ult_Insem = match[1,8],
      Dias_desde_Insem = as.numeric(match[1,9]),
      Edad_Meses_Act = as.numeric(match[1,10])
    )
  }
}
write_excel_csv(bind_rows(results) %>% distinct(), output_csv)
cat("Finalizado: VAQUILLAS PARA TEST DE PREÑEZ\n")
