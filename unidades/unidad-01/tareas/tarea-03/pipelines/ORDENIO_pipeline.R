library(tidyverse)
library(pdftools)

# Configuración
input_pdf <- "unidades/unidad-01/tareas/tarea-03/Input/ORDEÑO.pdf"
output_csv <- "unidades/unidad-01/tareas/tarea-03/data-procesada/ORDENIO_LIMPIO.csv"

# Leer PDF
text <- pdf_text(input_pdf)
lines <- unlist(strsplit(text, "\n"))

# Variables de estado
current_id <- NA
current_gp <- NA
current_parto <- NA
current_lech <- NA
current_insem_f <- NA
current_insem_d <- NA

results <- list()

cat("Iniciando procesamiento de Ordeño / Revisiones (Regex Robust)...\n")

for (line in lines) {
  line_trim <- str_trim(line)
  if (line_trim == "" || str_detect(line, "DairyPlan|Reporte|Vaca|N°|Gp|Pág")) next

  # Intentar identificar si hay un ID al principio (columnas 1-10)
  vaca_id_potencial <- str_extract(substring(line, 1, 12), "\\d{3,5}")
  
  if (!is.na(vaca_id_potencial)) {
    # NUEVA VACA
    current_id <- vaca_id_potencial
    
    # Extraer el resto de la info de 'Vaca' (Gp, Parto, Lech, Insem)
    # Buscamos la primera fecha en la línea como ancla (posiblemente Parto o Insem)
    fechas <- str_extract_all(line, "\\d{1,2}-\\d{2}-\\d{2}")[[1]]
    numeros <- str_extract_all(substring(line, 1, 80), "\\d+")[[1]]
    
    # Gp suele ser el segundo número
    current_gp <- if(length(numeros) >= 2) numeros[2] else NA
    # Lech suele ser el tercer número (si no hay fecha de parto antes)
    # Esta parte es compleja por lo que usaremos una lógica de descarte
    current_lech <- if(length(numeros) >= 3) numeros[3] else NA
    
    # Anclas de fechas:
    # Si hay 2 fechas y están después del ID -> Insem y Sig Rev.
    # Si hay 3 fechas -> Parto, Insem, Sig Rev.
    if (length(fechas) >= 2) {
      # La última fecha suele ser 'Sig Rev'
      # La penúltima suele ser 'Insem' o 'Parto'
    }
  }

  # Lógica de Extracción de Evento (Independiente de si hay ID o no)
  # Buscamos una fecha que esté en la zona de 'Sig Rev' (pos > 60)
  fecha_sig_rev <- str_extract(substring(line, 65, 95), "\\d{1,2}-\\d{2}-\\d{2}")
  
  if (!is.na(fecha_sig_rev) && !is.na(current_id)) {
      # Ubicamos el evento: es todo lo que sigue a la fecha
      # Encontramos la posición de la fecha para extraer lo de la derecha
      pos_fecha <- regexpr(fecha_sig_rev, line)
      todo_evento <- substring(line, pos_fecha + nchar(fecha_sig_rev), nchar(line))
      
      # Limpiar rayas y espacios
      todo_evento <- str_trim(str_replace_all(todo_evento, "_", ""))
      
      # Separar Evento de Comentario
      # El comentario suele estar bastante separado a la derecha
      partes <- str_split(todo_evento, "\\s{2,}", simplify = TRUE)
      evento_nombre <- partes[1,1]
      comentario_txt <- if(ncol(partes) >= 2) partes[1,2] else ""
      
      if (str_length(evento_nombre) > 2) {
          results[[length(results) + 1]] <- tibble(
            ID_Vaca = current_id,
            Grupo = current_gp,
            Fecha_Sig_Rev = fecha_sig_rev,
            Evento = str_trim(evento_nombre),
            Comentario = str_trim(comentario_txt)
          )
      }
  }
}

# Consolidar
df_final <- bind_rows(results) %>% distinct()

# Guardar
write_excel_csv(df_final, output_csv)

cat("Pipeline Robusto completado.\n")
cat("Total registros extraídos:", nrow(df_final), "\n")
cat("Verificación Cola (Page 8):\n")
print(tail(df_final))
