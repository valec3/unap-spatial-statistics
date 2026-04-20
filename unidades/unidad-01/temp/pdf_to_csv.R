library(pdftools)
library(readr)
library(stringr)
library(dplyr)
library(purrr)

# Configuración de rutas
input_dir <- "unidades/unidad-01/temp/Input"
output_dir <- "unidades/unidad-01/temp/Output"

# Crear directorio de salida si no existe
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Obtener lista de archivos PDF
pdf_files <- list.files(input_dir, pattern = "\\.pdf$", full.names = TRUE)

parse_dairyplan_pdf <- function(file_path) {
  message(paste("Procesando:", basename(file_path)))
  
  # Extraer texto por páginas
  pages <- pdf_text(file_path)
  
  # Función interna para limpiar y parsear cada página
  parse_page <- function(page_text) {
    lines <- str_split(page_text, "\n")[[1]]
    
    # Eliminar líneas vacías al inicio y final
    lines <- lines[str_trim(lines) != ""]
    
    # Buscar la línea divisoria (---) que suele separar encabezados de datos
    divider_idx <- which(str_detect(lines, "^\\s*-+"))
    
    if (length(divider_idx) == 0) {
      # Buscar la primera línea que parezca datos: empieza con número, asteriscos o espacios+número
      data_start_idx <- which(str_detect(lines, "^\\s*(\\d+|\\*\\*\\*\\*)(\\s|$)"))[1]
      if (is.na(data_start_idx)) return(NULL)
      main_divider <- data_start_idx - 1
    } else {
      main_divider <- divider_idx[1]
    }
    
    data_start <- main_divider + 1
    if (length(divider_idx) == 0) data_start <- main_divider
    
    # Extraer líneas de datos (filtrando pies de página y metadata final)
    data_lines <- lines[data_start:length(lines)]
    
    # Filtrar solo líneas que son claramente encabezados de página repetidos o metadatos
    data_lines <- data_lines[!str_detect(data_lines, "Pág \\d+|DAIRYPLAN|Establo|DairyPlan|Dairyplan")]
    
    # Quedarse con las que parecen datos (contienen números)
    data_lines <- data_lines[str_detect(data_lines, "\\d+")]
    
    if (length(data_lines) == 0) return(NULL)
    
    # Intentar leer como tabla de ancho fijo/espacios
    tryCatch({
      # Capturar los nombres de las columnas
      header_line <- if(main_divider > 0) lines[main_divider] else ""
      
      # Unir líneas de datos en un solo string
      data_content <- paste(data_lines, collapse = "\n")
      
      # Leer tabla forzando todas las columnas a character para evitar errores de binding
      df <- read_table(data_content, col_names = FALSE, show_col_types = FALSE, col_types = cols(.default = "c"))
      
      return(df)
    }, error = function(e) {
      message(paste("Error en página:", e$message))
      return(NULL)
    })
  }
  
  # Procesar todas las páginas y combinar
  all_data <- map(pages, parse_page) %>% list_rbind()
  
  if (!is.null(all_data)) {
    # Guardar como CSV
    output_name <- file.path(output_dir, paste0(tools::file_path_sans_ext(basename(file_path)), ".csv"))
    write_excel_csv(all_data, output_name)
    message(paste("Guardado en:", output_name))
  } else {
    message(paste("No se pudieron extraer datos de:", basename(file_path)))
  }
}

# Ejecutar proceso para todos los archivos
walk(pdf_files, parse_dairyplan_pdf)

message("\n¡Aguante la UNAP! Proceso terminado.")
