# Portafolio del Curso de Estadistica Espacial

Este repositorio contiene las evidencias del curso de Estadistica Espacial (2026-I).
El objetivo es que el docente pueda revisar rapidamente que entregables existen hoy y donde se ubican.

## Datos del curso

- **Universidad:** Universidad Nacional del Altiplano
- **Facultad:** Ingenieria Estadistica e Informatica
- **Curso:** Estadistica Espacial
- **Docente:** Ing. Fred Torres Cruz
- **Estudiante:** Victor Raul Maye Mamani
- **Codigo:** 217397
- **Ciclo:** 2026-I

## Contenido actual del repositorio (verificado)

### 1) Unidad 01

- `unidades/unidad-01/tareas/tarea-01/main.tex` - Monografia de la Tarea 01.
- `unidades/unidad-01/tareas/tarea-01/references.bib` - Referencias bibliograficas de la Tarea 01.
- `unidades/unidad-01/tareas/tarea-02-ena/` - Desarrollo completo de la Tarea 02 (analisis ENA en R), incluye:
  - scripts `00_setup.R`, `01_ingestion.R`, `02_processing.R`, `03_reporting.R`, `master.R`
  - insumos espaciales (`.shp`, `.dbf`, `.shx`, etc.)
  - resultados en `results/` (mapas e indicadores)
  - documento de insights `04_insights.md`

### 2) Unidad 02

- `unidades/unidad-02/tareas/` - Carpeta creada para futuras entregas (sin tareas registradas aun).

### 3) Papers

- `papers/01-review/main.tex` - Borrador de paper en LaTeX.
- `papers/01-review/bib` - Archivo bibliografico actual del borrador.
- `papers/02/` - Carpeta preparada para contenido de paper de la segunda unidad.

### 4) Portafolio web

- `portfolio/` - Sitio del curso (React + Vite + TypeScript), con secciones de unidades y tareas.

### 5) Datos

- `data/` - Datos fuente del trabajo ENA.

## Estructura resumida

```text
ENA_2014_2024/
|- README.md
|- .gitignore
|- data/
|- papers/
|  |- 01-review/
|  |- 02/
|- portfolio/
|- unidades/
   |- unidad-01/
   |  |- tareas/
   |     |- tarea-01/
   |     |- tarea-02-ena/
   |- unidad-02/
      |- tareas/
```

## Como ejecutar

### Tarea 02 (ENA) en R

```r
setwd("unidades/unidad-01/tareas/tarea-02-ena") # RUTA DONDE ESTA EL PROYECTO
source("master.R")
```

## Nota

El contenido de este README describe solo lo que existe actualmente en el repositorio.
