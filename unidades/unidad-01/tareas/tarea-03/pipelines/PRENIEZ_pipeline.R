library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/TEST DE PREÑEZ VACAS.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/PRENIEZ_VACAS_LIMPIO.csv"

# Leer PDF
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))

results <- list()

cat("Iniciando procesamiento de Test de Preñez Vacas...\n")

for (line in lines) {
  line_trim <- str_trim(line)
  if (line_trim == "" || str_detect(line, "DairyPlan|Preñez|Animal|Nr.Reg|Pág")) next

  # REGEX para FILA DE TEST DE PREÑEZ
  # Estructura: Animal Nr.Reg Estatus GP Lact_Nr Lact_Dias Cant_Ins Fecha_Ins Dias_Ins IEP Comentarios
  # Ejemplo:    3269 3269         Insem 25         1    528            5 25-08-25 210     597 
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d{3,5})?\\s+([A-Za-z]+)?\\s+(\\d+)?\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(\\d+)\\s+(\\d+)")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Estatus = match[1,4],
      Grupo = match[1,5],
      Lact_N = match[1,6],
      Dias_Lact = match[1,7],
      Servicios = match[1,8],
      Fecha_Ult_Insem = match[1,9],
      Dias_Ult_Insem = match[1,10],
      IEP = match[1,11]
    )
  }
}

# Consolidar y Guardar
df_final <- bind_rows(results) %>% distinct()

write_excel_csv(df_final, output_csv)

cat("Pipeline de Test de Preñez completado con éxito.\n")
cat("Total de animales procesados:", nrow(df_final), "\n")
cat("Archivo guardado en:", output_csv, "\n")
