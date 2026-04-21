library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/VACAS SECAS.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/VACAS_SECAS_LIMPIO.csv"

cat("Iniciando procesamiento de Vacas Secas (Custom Regex)...\n")

text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))
results <- list()

for (line in lines) {
  line_trim <- str_trim(line)
  if (line_trim == "" || str_detect(line, "DairyPlan|Secas|Status|fecha|Pág")) next

  # REGEX para Secas: ID(1) GP(2) STATUS(3) SEC_F(4) SEC_D(5) L_N(6) L_D(7) INS_F(8) INS_D(9) TORO(10) PARTO_F(11) VAC_D(12) INT(13)
  match <- str_match(line, "^\\s*(\\d{3,5})\\s+(\\d+)\\s+([A-Za-zñ]+)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d{1,2}-\\d{2}-\\d{2})?\\s*(\\d+)?\\s*(.*)?\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+(\\d+)\\s+(\\d+)")
  
  if (!is.na(match[1,1])) {
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = match[1,2],
      Grupo = match[1,3],
      Estatus = match[1,4],
      Fecha_Secado = match[1,5],
      Dias_Seca = match[1,6],
      Lact_N = match[1,7],
      Dias_Lact_Ant = match[1,8],
      Fecha_Ult_Insem = match[1,9],
      Toro = str_trim(match[1,11]),
      Fecha_Parto_Est = match[1,12],
      Intervalo_Parto = match[1,14]
    )
  }
}

df_final <- bind_rows(results) %>% distinct()
write_excel_csv(df_final, output_csv)
cat("Archivo generado:", output_csv, "con", nrow(df_final), "registros.\n")
