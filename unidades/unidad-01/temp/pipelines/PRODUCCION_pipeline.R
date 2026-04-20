library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/temp/Input/PRODUCCIÓN DE LECHE.pdf"
output_csv <- "unidades/unidad-01/temp/Output/PRODUCCION_PROCESADA.csv"

# Leer PDF
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))

results <- list()

cat("Iniciando procesamiento de Producción de Leche...\n")

for (line in lines) {
  # Limpiar espacios
  line_trim <- str_trim(line)
  
  # Ignorar cabeceras y metadata
  if (line_trim == "" || str_detect(line, "DairyPlan|Producción|VACA|N°|Pág")) next
  
  # REGEX para FILA DE VACA (Debe empezar con un número de animal)
  # Capturamos ID, Grupo, Estado, DIM, y datos de producción
  vaca_match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)\\s+([A-Za-z0-9ñ ]{5,10})\\s+(\\d+)\\s+\\d{1,2}:\\d{2}\\s+\\d{2}-\\d{2}\\s+([\\d.]+)\\s+([\\d.]+)\\s+([\\d.]+)\\s+([-]?([\\d.]+))?\\s*([\\d.]+)?\\s*([\\d.]+)?\\s*(\\d+)?")
  
  if (!is.na(vaca_match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = vaca_match[1,2],
      Grupo = vaca_match[1,3],
      Estatus = str_trim(vaca_match[1,4]),
      DIM = vaca_match[1,5],
      Leche_AM = as.numeric(vaca_match[1,6]),
      Leche_Total = as.numeric(vaca_match[1,7]),
      Leche_Anterior = as.numeric(vaca_match[1,8]),
      Variacion = as.numeric(vaca_match[1,9]),
      CCS = vaca_match[1,13]
    )
  }
}

# Consolidar y Guardar
df_final <- bind_rows(results)
df_final <- df_final %>% distinct()

write_excel_csv(df_final, output_csv)

cat("Pipeline de Producción completado.\n")
cat("Total de registros individuales extraídos:", nrow(df_final), "\n")
cat("Total de vacas procesadas:", length(unique(df_final$ID_Vaca)), "\n")
cat("Archivo guardado en:", output_csv, "\n")

# Verificación de las vacas 3163 y 3169 (Mencionadas indirectamente por el usuario)
cat("\nVerificación de registros de ejemplo:\n")
print(df_final %>% filter(ID_Vaca %in% c("3163", "3169")))
