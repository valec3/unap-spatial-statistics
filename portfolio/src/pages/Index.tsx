import { useState } from "react";
import TopoBackground from "@/components/hud/TopoBackground";
import BootSequence from "@/components/hud/BootSequence";
import Hero from "@/components/hud/Hero";
import UnitSection from "@/components/hud/UnitSection";
import Footer from "@/components/hud/Footer";

const unit01Goals = [
  "Comprender los fundamentos de la estadística espacial y su aplicación en geociencias.",
  "Manejar estructuras de datos georreferenciados y sistemas de coordenadas.",
  "Aplicar técnicas exploratorias de análisis espacial (ESDA).",
  "Identificar patrones de autocorrelación espacial mediante el índice de Moran.",
  "Construir matrices de pesos espaciales (W) bajo distintos criterios de vecindad.",
];

const unit02Goals = [
  "Modelar superficies continuas mediante interpolación geoestadística (Kriging).",
  "Estimar y validar variogramas experimentales y teóricos.",
  "Implementar modelos espaciales de regresión (SAR, SEM, GWR).",
  "Evaluar la heterogeneidad espacial y la dependencia local.",
  "Generar reportes reproducibles con R / Python para análisis espacial avanzado.",
];

const unit01Tasks = [
  {
    taskId: "TSK-LOG-01",
    date: "2026.03.04",
    title: "Introducción a Datos Geoespaciales",
    description:
      "Lectura, proyección y visualización de capas vectoriales y raster con sf y terra.",
    fileSize: "1.4 MB",
    computeTime: "0.42s",
    variant: "vector" as const,
  },
  {
    taskId: "TSK-LOG-02",
    date: "2026.03.11",
    title: "Matrices de Vecindad Espacial",
    description:
      "Construcción de matrices W tipo Queen, Rook y K-NN sobre el departamento de Puno.",
    fileSize: "880 KB",
    computeTime: "0.31s",
    variant: "mesh" as const,
  },
  {
    taskId: "TSK-LOG-03",
    date: "2026.03.18",
    title: "Índice de Moran Global y Local",
    description:
      "Detección de autocorrelación espacial y clusters LISA en variables socioeconómicas.",
    fileSize: "2.1 MB",
    computeTime: "1.08s",
    variant: "cluster" as const,
  },
  {
    taskId: "TSK-LOG-04",
    date: "2026.03.25",
    title: "Análisis Exploratorio Espacial",
    description:
      "Mapas de calor, diagramas de dispersión espaciales y detección de hot/cold spots.",
    fileSize: "1.9 MB",
    computeTime: "0.77s",
    variant: "heatmap" as const,
  },
  {
    taskId: "TSK-LOG-05",
    date: "2026.04.01",
    title: "Procesos Puntuales Espaciales",
    description:
      "Estimación de intensidad mediante kernels y función K de Ripley.",
    fileSize: "1.2 MB",
    computeTime: "0.54s",
    variant: "cluster" as const,
  },
  {
    taskId: "TSK-LOG-06",
    date: "2026.04.08",
    title: "Visualización Cartográfica Avanzada",
    description:
      "Diseño de mapas temáticos reproducibles con tmap y leaflet interactivo.",
    fileSize: "3.0 MB",
    computeTime: "1.21s",
    variant: "vector" as const,
  },
];

const unit01Article = {
  taskId: "ART-PRELIM-01",
  date: "2026.04.15",
  title: "Artículo Científico Preliminar — Patrones Espaciales en Puno",
  description:
    "Documento de investigación que aplica indicadores LISA y matrices de pesos para identificar clusters de pobreza multidimensional en la región Puno. Incluye marco teórico, metodología, resultados preliminares y discusión.",
  fileSize: "8.7 MB",
  computeTime: "12.40s",
  variant: "heatmap" as const,
  badge: "ARTICLE · PRELIM",
};

const unit02Tasks = [
  {
    taskId: "TSK-GEO-01",
    date: "2026.04.22",
    title: "Variograma Experimental",
    description:
      "Cálculo y ajuste de variogramas omnidireccionales y direccionales con gstat.",
    fileSize: "1.5 MB",
    computeTime: "0.66s",
    variant: "mesh" as const,
  },
  {
    taskId: "TSK-GEO-02",
    date: "2026.04.29",
    title: "Kriging Ordinario",
    description:
      "Interpolación geoestadística de precipitación anual sobre el altiplano peruano.",
    fileSize: "4.2 MB",
    computeTime: "3.18s",
    variant: "heatmap" as const,
  },
  {
    taskId: "TSK-GEO-03",
    date: "2026.05.06",
    title: "Validación Cruzada Espacial",
    description:
      "Evaluación de modelos mediante leave-one-out y métricas RMSE / MAE espaciales.",
    fileSize: "1.1 MB",
    computeTime: "0.92s",
    variant: "vector" as const,
  },
  {
    taskId: "TSK-GEO-04",
    date: "2026.05.13",
    title: "Modelos SAR y SEM",
    description:
      "Regresión espacial autorregresiva y modelos de error espacial con spatialreg.",
    fileSize: "2.6 MB",
    computeTime: "2.04s",
    variant: "cluster" as const,
  },
  {
    taskId: "TSK-GEO-05",
    date: "2026.05.20",
    title: "Regresión Geográficamente Ponderada",
    description:
      "Modelado de heterogeneidad espacial local con GWR y mapas de coeficientes.",
    fileSize: "3.3 MB",
    computeTime: "2.71s",
    variant: "heatmap" as const,
  },
  {
    taskId: "TSK-GEO-06",
    date: "2026.05.27",
    title: "Reportes Reproducibles Geoespaciales",
    description:
      "Documentos Quarto / R Markdown con flujos automatizados de análisis espacial.",
    fileSize: "2.0 MB",
    computeTime: "1.05s",
    variant: "mesh" as const,
  },
];

const unit02Article = {
  taskId: "ART-FINAL-02",
  date: "2026.06.10",
  title: "Artículo Científico Final — Modelado Geoestadístico Aplicado",
  description:
    "Investigación final que integra Kriging, GWR y validación cruzada para modelar la distribución espacial de variables climáticas en la cuenca del Titicaca. Incluye abstract, metodología completa, resultados, discusión y referencias.",
  fileSize: "14.2 MB",
  computeTime: "28.91s",
  variant: "cluster" as const,
  badge: "ARTICLE · FINAL",
};

const Index = () => {
  const [booted, setBooted] = useState(false);

  return (
    <>
      <BootSequence onDone={() => setBooted(true)} />
      <TopoBackground />

      <main className={booted ? "opacity-100" : "opacity-0"}>
        {/* Top status ticker */}
        <div className="border-b border-primary/20 bg-background/60 backdrop-blur-sm">
          <div className="container flex items-center justify-between py-2 text-[10px] font-mono">
            <div className="flex items-center gap-4 text-muted-foreground">
              <span className="text-primary">◈ GEOSPATIAL_INTEL_HUB</span>
              <span className="hidden md:inline">v2.6.1</span>
              <span className="hidden md:inline">| SECURE_CHANNEL</span>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-muted-foreground hidden sm:inline">
                LAT -15.8402 · LON -70.0219
              </span>
              <span className="flex items-center gap-1.5 text-secondary">
                <span className="h-1.5 w-1.5 bg-secondary animate-flicker" />
                ONLINE
              </span>
            </div>
          </div>
        </div>

        <Hero />

        <UnitSection
          unitNumber="01"
          unitTitle="FUNDAMENTOS · AUTOCORRELACIÓN"
          monitorTitle="Logros de Aprendizaje — Análisis Exploratorio Espacial"
          goals={unit01Goals}
          tasks={unit01Tasks}
          article={unit01Article}
        />

        <UnitSection
          unitNumber="02"
          unitTitle="GEOESTADÍSTICA · MODELADO"
          monitorTitle="Logros de Aprendizaje — Modelado e Interpolación Espacial"
          goals={unit02Goals}
          tasks={unit02Tasks}
          article={unit02Article}
        />

        <Footer />
      </main>
    </>
  );
};

export default Index;
