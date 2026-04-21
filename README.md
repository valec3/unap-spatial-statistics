# 🚀 Unap Spatial Statistics Portfolio (2014-2024)

[![Academic Portfolio](https://img.shields.io/badge/Portfolio-React-blue?style=for-the-badge&logo=react)](file:///d:/descargas/ENA_2014_2024/portfolio)
[![Spatial Analysis](https://img.shields.io/badge/Analysis-R%20Project-green?style=for-the-badge&logo=r)](https://github.com/valec3/unap-spatial-statistics)
[![SDD Workflow](https://img.shields.io/badge/Approach-SDD-purple?style=for-the-badge)](https://github.com/valec3/unap-spatial-statistics)

Este repositorio es el epicentro técnico del curso de **Estadística Espacial** (Ciclo 2026-I). No es solo una colección de tareas; es un ecosistema integrado que combina análisis estadístico avanzado, pipelines de datos profesionales y una interfaz de usuario inmersiva.

## 🏛️ Información del Estudiante
- **Estudiante:** Victor Raul Maye Mamani (Código: 217397)
- **Institución:** Universidad Nacional del Altiplano
- **Facultad:** Ingeniería Estadística e Informática
- **Docente:** Ing. Fred Torres Cruz

---

## 🏗️ Arquitectura del Proyecto

El proyecto se divide en tres capas fundamentales que garantizan un flujo de trabajo profesional y escalable:

### 1. 🌐 Portfolio Web (HUD Interface)
Ubicado en [`/portfolio`](./portfolio). Una aplicación web de vanguardia construida con **React + Vite + TypeScript**.
- **Design System:** Estética "Tactical HUD" premium para una experiencia académica inmersiva.
- **Data Architecture:** Centralización de contenido en esquemas de datos desacoplados de la UI.
- **Workflow:** Uso estricto de **Spec-Driven Development (SDD)** para la gestión de cambios y nuevas funcionalidades.

### 2. 📊 Pipeline de Análisis (R & CRISP-DM)
Ubicado en [`unidades/unidad-01/tareas/tarea-02-ena/`](./unidades/unidad-01/tareas/tarea-02-ena/).
- **Core:** Análisis multianual de la Encuesta Nacional Agropecuaria (ENA 2014-2024).
- **Metodología:** Pipelines modulares siguiendo **CRISP-DM** (Ingestión -> Procesamiento -> Reporte).
- **Optimización:** Implementación de flujos **SAV a Parquet** para manejo eficiente de Big Data.
- **Geoprocesamiento:** Integración de Shapefiles y visualización cartográfica de alta fidelidad.

### 3. 📈 Dashboards Interactivos (Shiny)
Ubicado en [`unidades/unidad-01/tareas/tarea-03/`](./unidades/unidad-01/tareas/tarea-03/).
- **Live Version:** [Explorar Dashboard en vivo](https://s0vy85-victor0maye.shinyapps.io/tarea-03/)
- **Stack:** `tidyverse`, `shiny`, `bslib`, `plotly`.
- **Purpose:** Automatización de reportes DairyPlan y visualización de métricas críticas de producción.

---

## 📂 Estructura General

```text
ENA_2014_2024/
├── data/                 # Datasets fuente y procesados (Big Data optimized)
├── papers/               # Documentación científica y borradores LaTeX
│   ├── 01-review/        # Review Paper: Estado del arte en Estadística Espacial
│   └── 02/               # Planificado para la siguiente unidad
├── portfolio/            # Web Portfolio App (React Engine)
├── unidades/             # Entregables académicos estructurados
│   ├── unidad-01/        # 🏁 100% Completado
│   │   └── tareas/
│   │       ├── tarea-01/    # Fundamentos y revisión
│   │       ├── tarea-02-ena/# Pipeline de análisis espacial ENA
│   │       └── tarea-03/    # Dashboard interactivo Shiny
│   └── unidad-02/        # 🚧 En progreso
└── .atl/                 # Spec-Driven Development Artifacts & Skill Registry
```

---

## 🛠️ Guía de Ejecución

### Para Análisis Estadístico (R):
1. Abrir el proyecto en RStudio.
2. Ejecutar `source("unidades/unidad-01/tareas/tarea-02-ena/master.R")`.
*Nota: Asegúrese de tener instaladas las dependencias listadas en el setup.*

### Para el Portfolio Web:
```bash
cd portfolio
bun install
bun run dev
```

---

## 📜 Filosofía de Desarrollo: SDD
Este proyecto no se construye al azar. Seguimos **Spec-Driven Development (SDD)**:
1. **Explore:** Investigación profunda antes de codificar.
2. **Propose:** Definición clara del cambio.
3. **Spec & Design:** Planificación arquitectónica rigurosa.
4. **Apply:** Implementación consciente.
5. **Verify:** Validación contra especificaciones.

---
*Mantenido con rigor académico y pasión por la ingeniería de datos.*
