library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/temp/Input/VACAS PROXIMAS AL PARTO.pdf"
output_csv <- "unidades/unidad-01/temp/Output/PROXIMAS_PARTO_PROCESADO.csv"

# Leer PDF
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))

results <- list()

cat("Iniciando procesamiento de Vacas Próximas al Parto...\n")

for (line in lines) {
  line_trim <- str_trim(line)
  if (line_trim == "" || str_detect(line, "DairyPlan|proximas|VACA|NUM|Pág")) next

  # REGEX para FILA DE PARTO ESTIMADO
  # Estructura: NUM GP NOMBRE LACT_NUM DIM INICIO FECHA TORO GEST SECA ESTIMADO FALTAN ESTATUS
  # Ejemplo: 3143 4 GOLD CHI 2     412 4-02-25 19-05-25 TENTASTI 308                          0   22-02-26 -29 Preñ2
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)?\\s+([A-Z0-9 ]{5,15})\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})?\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+([A-Z0-9 ]{5,15})\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(-?\\d+)\\s+([A-Za-z0-9ñ]+)")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Grupo = match[1,3],
      Nombre = str_trim(match[1,4]),
      Lact_N = match[1,5],
      DIM = match[1,6],
      Fecha_Parto_Est = match[1,12],
      Dias_Faltan = as.numeric(match[1,13]),
      Estatus = match[1,14]
    )
  }
}

# Consolidar y Guardar
df_final <- bind_rows(results) %>% distinct()

write_excel_csv(df_final, output_csv)

cat("Pipeline de Próximas al Parto completado.\n")
cat("Total de registros extraídos:", nrow(df_final), "\n")
cat("Archivo guardado en:", output_csv, "\n")
