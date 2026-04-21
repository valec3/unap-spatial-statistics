# --- MASTER CONSOLIDATOR V4.8: BATTLE TESTED ---
library(tidyverse)
library(lubridate)

input_dir  <- "unidades/unidad-01/tareas/tarea-03/data-procesada"
output_csv <- "unidades/unidad-01/tareas/tarea-03/Dataset_Final_UNAP_FULL.csv"

cat("Iniciando Consolidación V4.8 (Lógica de Distinto a Cero)...\n")

safe_read <- function(filename) {
  path <- file.path(input_dir, filename)
  if (file.exists(path)) {
    return(read_csv(path, show_col_types = FALSE) %>% mutate(across(everything(), as.character)))
  }
  return(NULL)
}

# 1. CARGA
p_prod   <- safe_read("PRODUCCION_LIMPIO.csv") %>% select(ID_Vaca, Grupo, DIM, Leche_Total, E_Prod = Estatus)
p_gest   <- safe_read("VACAS_GESTANTES_LIMPIO.csv") %>% select(ID_Vaca, Lact_N, E_Gest = Estatus)
p_seca   <- safe_read("VACAS_SECAS_LIMPIO.csv") %>% select(ID_Vaca, E_Seca = Estatus, Fecha_Secado, Dias_Seca, Toro_Seca = Toro)
p_insm   <- safe_read("INSEMINADAS_LIMPIO.csv") %>% select(ID_Vaca, Fecha_Insem, Toro_Ins = Toro)

# 2. UNIFICACIÓN CON LÓGICA DE DETECCIÓN MEJORADA
cat("Procesando lógicas...\n")
master_vacas <- full_join(p_prod, p_seca, by="ID_Vaca") %>%
  left_join(p_gest, by="ID_Vaca") %>%
  left_join(p_insm %>% group_by(ID_Vaca) %>% slice_tail(n=1), by="ID_Vaca") %>%
  mutate(
    Tipo = "VACA",
    Status_Repro = case_when(
      !is.na(E_Gest) & E_Gest != "0" ~ "VACAPREÑACTUAL",
      !is.na(Toro_Seca) & Toro_Seca != "0" ~ "VACAPREÑACTUAL",
      !is.na(Fecha_Insem) ~ "INSEMINADA",
      TRUE ~ "VACIA"
    ),
    # SI HAY DATO EN E_SECA (Prepa o Seca), MARCAR COMO SECA
    Status_Final = ifelse(!is.na(E_Seca), "SECA", "EN ORDEÑO")
  )

# 3. RECRÍA
r_gral <- safe_read("VAQUILLAS_GENERAL_LIMPIO.csv")
master_recria <- r_gral %>% mutate(Tipo = "RECRÍA", Status_Final = "DESARROLLO", Status_Repro = "VACIA")

# 4. ENSAMBLE Y LIMPIEZA FINAL
master_final <- bind_rows(master_vacas, master_recria) %>%
  mutate(across(everything(), ~replace_na(., "0")))

write_excel_csv(master_final, output_csv)
cat("Dataset V4.8 generado con éxito. Secas detectadas correctamente.\n")
