library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/MASTITIS.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/MASTITIS_LIMPIO.csv"

# Leer PDF
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))

# Variables de estado
current_id <- NA
current_edad <- NA
current_lact_n <- NA
current_lact_dias <- NA
current_leche <- NA

results <- list()

cat("Iniciando procesamiento de Mastitis...\n")

for (line in lines) {
  # Limpiar espacios
  line_trim <- str_trim(line)
  
  # Ignorar cabeceras y metadata
  if (line_trim == "" || str_detect(line, "DairyPlan|Animales|VACA|N° Edad|Pág")) next
  
  # Detectar si es una FILA DE VACA NUEVA (Empieza con un ID de ~4 dígitos)
  # Buscamos que los primeros 15 caracteres contengan un número al principio
  header_match <- str_match(line, "^\\s*(\\d{3,5})\\s+([\\d.]+)\\s+(\\d+)\\s+(\\d+)\\s+([\\d.]+)")
  
  if (!is.na(header_match[1,1])) {
    current_id <- header_match[1,2]
    current_edad <- header_match[1,3]
    current_lact_n <- header_match[1,4]
    current_lact_dias <- header_match[1,5]
    current_leche <- header_match[1,6]
  }
  
  # Detectar el REGISTRO DE MASTITIS en la línea (siempre está a la derecha)
  # Estructura: Días(o ****)  Fecha  Comm1  Comm2
  # Usamos una expresión regular que busque la fecha (dd-mm-yy)
  mastitis_match <- str_match(line, "(-?\\d+|\\*\\*\\*\\*)\\s+(\\d{1,2}-\\d{2}-\\d{2})\\s+([A-Z\\d+*]+)?\\s*(.*)?")
  
  if (!is.na(mastitis_match[1,1]) && !is.na(current_id)) {
    # Si encontramos un evento de mastitis, lo vinculamos al animal actual
    results[[length(results) + 1]] <- tibble(
      ID_Vaca = current_id,
      Edad = current_edad,
      Lact_N = current_lact_n,
      Lact_Dias = current_lact_dias,
      Leche_24h = current_leche,
      Dias_Enferma = mastitis_match[1,2],
      Fecha_Evento = mastitis_match[1,3],
      Comentario_1 = str_trim(mastitis_match[1,4]),
      Comentario_2 = str_trim(mastitis_match[1,5])
    )
  }
}

# Consolidar y Guardar
df_final <- bind_rows(results)

# Limpieza final: Eliminar duplicados si los hay por el paginado
df_final <- df_final %>% distinct()

write_excel_csv(df_final, output_csv)

cat("Pipeline completado.\n")
cat("Total de animales procesados:", length(unique(df_final$ID_Vaca)), "\n")
cat("Total de eventos de mastitis:", nrow(df_final), "\n")
cat("Archivo guardado en:", output_csv, "\n")

# Verificación de la vaca 2656 (Mencionada por el usuario)
cat("\nVerificación Vaca 2656:\n")
print(df_final %>% filter(ID_Vaca == "2656"))
