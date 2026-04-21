library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VACAS INSEMINADAS.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/INSEMINADAS_LIMPIO.csv"

# Leer PDF
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))

results <- list()

cat("Iniciando procesamiento de Vacas Inseminadas...\n")

for (line in lines) {
  line_trim <- str_trim(line)
  if (line_trim == "" || str_detect(line, "DairyPlan|Inseminadas|VACA|NO.|Pág")) next

  # REGEX para FILA DE INSEMINACIÓN
  # Estructura: ID LO LC FECHA_PARTO STATUS FECHA_INSEM TORO CANT DIAS_INS DIAS_AB PROD
  # Ejemplo: 3339 19 1 12-06-25 Insem 23-09-25 INDEPENDANT T3 2 181 284 32.2 *
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)?\\s+(\\d+)?\\s*(\\d{1,2}-\\d{2}-\\d{2})?\\s+([A-Za-z]+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+([A-Z0-9 ]{5,15})\\s+([A-Z0-9]+)?\\s*(\\d+)?\\s*(\\d+)?\\s*(\\d+)?\\s*([\\d.]+)?")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Localidad = match[1,3],
      Lact_N = match[1,4],
      Fecha_Parto = match[1,5],
      Estatus = match[1,6],
      Fecha_Insem = match[1,7],
      Toro = str_trim(match[1,8]),
      Cant_Insem = match[1,10],
      Dias_Insem = match[1,11],
      Dias_Abiertos = match[1,12],
      Prod_Promedio = as.numeric(match[1,13])
    )
  }
}

# Consolidar y Guardar
df_final <- bind_rows(results) %>% distinct()

write_excel_csv(df_final, output_csv)

cat("Pipeline de Inseminadas completado.\n")
cat("Total de vacas inseminadas extraídas:", nrow(df_final), "\n")
cat("Archivo guardado en:", output_csv, "\n")
