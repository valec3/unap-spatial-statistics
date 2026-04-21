library(tidyverse)
library(pdftools)

# Pipeline: VAQUILLAS GENERAL
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VAQUILLAS.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VAQUILLAS_GENERAL_LIMPIO.csv"

cat("Procesando Vaquillas General...\n")
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  if (str_detect(line, "DairyPlan|Vaquillas|Vaq.|NUM|Pág") || str_trim(line) == "") next
  # Captura para Inventario de Recría: ID(1) GP(2) FECHA(3) EDAD(4) CATEG(5) TORO(6)
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+([\\d.]+)\\s+([A-Za-zñ]+)\\s*(.*)?")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Grupo = match[1,3],
      Fecha_Nac = match[1,4],
      Edad_Meses = match[1,5],
      Categoria = match[1,6],
      Toro_Padre = str_trim(match[1,7])
    )
  }
}
write_excel_csv(bind_rows(results) %>% distinct(), output_csv)
cat("Listo: VAQUILLAS GENERAL\n")
