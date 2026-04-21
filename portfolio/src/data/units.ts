export type Task = {
  taskId: string;
  date: string;
  title: string;
  description: string;
  fileSize: string;
  computeTime: string;
  variant: "heatmap" | "cluster" | "mesh" | "vector";
  pdfUrl?: string;
  repoUrl?: string;
  webUrl?: string;
  imageUrl?: string;
  badge?: string;
  stack?: string[]; // New: Technologies used
};

export type Unit = {
  unitNumber: string;
  unitTitle: string;
  monitorTitle: string;
  goals: string[];
  tasks: Task[];
  article: Task;
  period: string;
  progressPercent: number;
};

export const unit01: Unit = {
  unitNumber: "01",
  unitTitle: "GEOCIENCIAS · ELT · TIGS",
  monitorTitle: "Investigación preliminar basada en el análisis exploratorio de datos espaciales.",
  period: "30 de Marzo al 25 de Mayo del 2026",
  progressPercent: 20,
  goals: [
    "Estadística espacial descriptiva y conceptos básicos.",
    "Diferenciación de tipos de datos: Vectorial y Raster.",
    "Sistemas de coordenadas, datum, proyecciones y UTM.",
    "Evaluación de calidad e integridad de datos espaciales.",
    "Gestión de Geodatabases y ETL con PostGIS/PostgreSQL.",
    "Preprocesamiento, geocodificación y topología (OpenRefine).",
    "Análisis de patrones espaciales y densidad (GeoDa).",
    "Visualización cartográfica y diseño con QGIS.",
  ],
  tasks: [
    {
      taskId: "TSK-U1-01",
      date: "10/04/2026",
      title: "Vectores & Shapes",
      description:
        "Monografía detallada sobre vectores y shapes. Mínimo 3 páginas con al menos 5 fuentes bibliográficas (IEEE, Scopus) incluyendo DOI.",
      fileSize: "2.4 MB",
      computeTime: "0.15s",
      variant: "vector",
      pdfUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-01",
      repoUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-01",
      imageUrl: "/previews/task-01.webp",
      stack: ["IEEE", "GIS Fundamentals"],
    },
    {
      taskId: "TSK-U1-02",
      date: "19/04/2026",
      title: "Ubicación Espacial - Análisis ENA",
      description:
        "Análisis de ubicación espacial para 3 variables de la Encuesta Nacional Agraria. Incluye procesamiento en R y generación de mapas temáticos.",
      fileSize: "12.8 MB",
      computeTime: "4.2s",
      variant: "heatmap",
      pdfUrl: "https://github.com/valec3/unap-spatial-statistics/blob/main/unidades/unidad-01/tareas/tarea-02-ena/informe/Informe_Tarea02_ENA.pdf.pdf",
      repoUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-02-ena",
      imageUrl: "/previews/task-02.webp",
      stack: ["R Language", "ENA Dataset", "Heatmaps"],
    },
    {
      taskId: "TSK-U1-03",
      date: "21/04/2026",
      title: "Pipeline Ganadero",
      description:
        "Automatización de limpieza de 14 reportes PDF (DairyPlan), consolidación en dataset maestro y dashboard Shiny interactivo para gestión estratégica.",
      fileSize: "4.8 MB",
      computeTime: "1.2s",
      variant: "cluster",
      pdfUrl: "https://github.com/valec3/unap-spatial-statistics/blob/main/unidades/unidad-01/tareas/tarea-03/README.md",
      repoUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-03",
      webUrl: "https://s0vy85-victor0maye.shinyapps.io/tarea-03/",
      imageUrl: "/previews/task-03.webp",
      stack: ["R Shiny", "Regex", "Business Intelligence"],
    },
    {
      taskId: "TSK-U1-04",
      date: "2026.05.05",
      title: "Tarea 04 - Placeholder",
      description: "Espacio reservado para la siguiente entrega de la Unidad 01.",
      fileSize: "0 KB",
      computeTime: "0.0s",
      variant: "mesh",
    },
  ],
  article: {
    taskId: "ART-PRELIM-01",
    date: "2026.04.15",
    title: "Artículo Científico Preliminar — Patrones Espaciales en Puno",
    description:
      "Documento de investigación que aplica indicadores LISA y matrices de pesos para identificar clusters de pobreza multidimensional en la región Puno. Incluye marco teórico, metodología, resultados preliminares y discusión.",
    fileSize: "8.7 MB",
    computeTime: "12.40s",
    variant: "heatmap",
    badge: "ARTICLE · PRELIM",
    stack: ["LISA Indicators", "Spatial Weights", "Puno Region"],
  },
};

export const unit02: Unit = {
  unitNumber: "02",
  unitTitle: "GEOESTADÍSTICA · MODELADO",
  monitorTitle: "Logros de Aprendizaje — Modelado e Interpolación Espacial",
  period: "Mayo - Julio 2026",
  progressPercent: 0,
  goals: [
    "Modelado de superficies continuas mediante interpolación geoestadística (Kriging).",
    "Estimar y validar variogramas experimentales y teóricos.",
    "Implementar modelos espaciales de regresión (SAR, SEM, GWR).",
    "Evaluar la heterogeneidad espacial y la dependencia local.",
    "Generar reportes reproducibles con R / Python para análisis espacial avanzado.",
  ],
  tasks: [
    {
      taskId: "TSK-GEO-01",
      date: "2026.04.22",
      title: "Variograma Experimental",
      description: "Cálculo y ajuste de variogramas omnidireccionales y direccionales con gstat.",
      fileSize: "1.5 MB",
      computeTime: "0.66s",
      variant: "mesh",
      stack: ["gstat", "R"],
    },
    {
      taskId: "TSK-GEO-02",
      date: "2026.04.29",
      title: "Kriging Ordinario",
      description: "Interpolación geoestadística de precipitación anual sobre el altiplano peruano.",
      fileSize: "4.2 MB",
      computeTime: "3.18s",
      variant: "heatmap",
      stack: ["Geoestadística", "GIS"],
    },
    {
      taskId: "TSK-GEO-03",
      date: "2026.05.06",
      title: "Validación Cruzada Espacial",
      description: "Evaluación de modelos mediante leave-one-out y métricas RMSE / MAE espaciales.",
      fileSize: "1.1 MB",
      computeTime: "0.92s",
      variant: "vector",
      stack: ["Statistical Validation"],
    },
    {
      taskId: "TSK-GEO-04",
      date: "2026.05.13",
      title: "Modelos SAR y SEM",
      description: "Regresión espacial autorregresiva y modelos de error espacial con spatialreg.",
      fileSize: "2.6 MB",
      computeTime: "2.04s",
      variant: "cluster",
      stack: ["Spatial Regresssion"],
    },
    {
      taskId: "TSK-GEO-05",
      date: "2026.05.20",
      title: "Regresión Geográficamente Ponderada",
      description: "Modelado de heterogeneidad espacial local con GWR y mapas de coeficientes.",
      fileSize: "3.3 MB",
      computeTime: "2.71s",
      variant: "heatmap",
      stack: ["GWR"],
    },
    {
      taskId: "TSK-GEO-06",
      date: "2026.05.27",
      title: "Reportes Reproducibles Geoespaciales",
      description: "Documentos Quarto / R Markdown con flujos automatizados de análisis espacial.",
      fileSize: "2.0 MB",
      computeTime: "1.05s",
      variant: "mesh",
      stack: ["Quarto", "R Markdown"],
    },
  ],
  article: {
    taskId: "ART-FINAL-02",
    date: "2026.06.10",
    title: "Artículo Científico Final — Modelado Geoestadístico Aplicado",
    description:
      "Investigación final que integra Kriging, GWR y validación cruzada para modelar la distribución espacial de variables climáticas en la cuenca del Titicaca.",
    fileSize: "14.2 MB",
    computeTime: "28.91s",
    variant: "cluster",
    badge: "ARTICLE · FINAL",
    stack: ["Climate Modeling", "Titicaca Basin"],
  },
};

export const allUnits = [unit01]; // unit02 disabled for now
