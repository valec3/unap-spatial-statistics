# Estadistica Espacial - Portafolio del Curso

Repositorio general del curso para centralizar todo el trabajo academico:
- portfolio web del curso
- 2 unidades con tareas
- 2 papers (1 por unidad)
- scripts de analisis espacial en R

## Informacion general

- **Universidad:** Universidad Nacional del Altiplano
- **Facultad:** Ingenieria Estadistica e Informatica
- **Curso:** Estadistica Espacial
- **Docente:** Ing. Fred Torres Cruz
- **Estudiante:** Victor Raul Maye Mamani
- **Codigo:** 217397
- **Ciclo:** 2026-I

Referencia: los datos institucionales fueron tomados de `portfolio/src/components/hud/Hero.tsx`.

## Objetivo del repositorio

Este repositorio funciona como portafolio oficial del curso. La idea es mantener en un solo lugar:
- evidencias de aprendizaje por unidad
- entregas de tareas en formato reproducible
- papers con su material fuente
- presentacion web del proyecto academico

## Estructura

```text
ENA_2014_2024/
|- README.md
|- .gitignore
|- data/                          # Datos fuente (no versionar pesados)
|- analisis/
|  |- 02-/                        # Carpeta auxiliar (legacy)
|- unidades/
|  |- unidad-01/
|  |  |- tareas/
|  |     |- tarea-01/             # Monografia (main.tex + references.bib)
|  |     |- tarea-02-ena/         # Analisis ENA (Tarea 02)
|  |- unidad-02/
|     |- tareas/                  # Tareas de la Unidad 2
|- papers/
|  |- unidad-01/                  # Paper final Unidad 1
|  |- unidad-02/                  # Paper final Unidad 2
|  |- 01-review/                  # Borradores / trabajo previo
|- portfolio/                     # Sitio portfolio (React + Vite + TypeScript)
```

## Plan academico

### Unidad 1 - Fundamentos y Autocorrelacion Espacial

- [ ] Tarea 01: Introduccion a datos geoespaciales
- [ ] Tarea 02: Matrices de vecindad espacial
- [ ] Tarea 03: Indice de Moran global y local
- [ ] Tarea 04: Analisis exploratorio espacial
- [ ] Tarea 05: Procesos puntuales espaciales
- [ ] Tarea 06: Visualizacion cartografica avanzada
- [ ] Paper U1

### Unidad 2 - Geoestadistica y Modelado Espacial

- [ ] Tarea 01: Variograma experimental
- [ ] Tarea 02: Kriging ordinario
- [ ] Tarea 03: Validacion cruzada espacial
- [ ] Tarea 04: Modelos SAR y SEM
- [ ] Tarea 05: Regresion geograficamente ponderada (GWR)
- [ ] Tarea 06: Reportes reproducibles geoespaciales
- [ ] Paper U2

## Ejecucion local

### Portfolio (web)

```bash
cd portfolio
npm install
npm run dev
```

### Analisis en R

```r
setwd("unidades/unidad-01/tareas/tarea-02-ena")
source("master.R")
```

## Convenciones de trabajo

- Guardar cada entrega en su unidad: `unidades/unidad-0X/tareas/`.
- La Tarea 01 de Unidad 1 vive en `unidades/unidad-01/tareas/tarea-01/`.
- La Tarea 02 de Unidad 1 (ENA) vive en `unidades/unidad-01/tareas/tarea-02-ena/`.
- Guardar cada paper final en `papers/unidad-0X/`.
- Usar `papers/01-review/` para borradores o versiones intermedias.
- Evitar subir datos grandes y archivos temporales (controlado en `.gitignore`).

## Publicacion del portafolio

Cuando el sitio este listo, agregar aqui el enlace de despliegue:
- GitHub Pages / Netlify / Vercel

## Licencia

Uso academico - curso de Estadistica Espacial.
