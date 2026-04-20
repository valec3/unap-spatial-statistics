import { useState } from "react";
import TopoBackground from "@/components/hud/TopoBackground";
import BootSequence from "@/components/hud/BootSequence";
import Hero from "@/components/hud/Hero";
import UnitSection from "@/components/hud/UnitSection";
import Footer from "@/components/hud/Footer";

const unit01Goals = [
  "Estadística espacial descriptiva y conceptos básicos.",
  "Diferenciación de tipos de datos: Vectorial y Raster.",
  "Sistemas de coordenadas, datum, proyecciones y UTM.",
  "Evaluación de calidad e integridad de datos espaciales.",
  "Gestión de Geodatabases y ETL con PostGIS/PostgreSQL.",
  "Preprocesamiento, geocodificación y topología (OpenRefine).",
  "Análisis de patrones espaciales y densidad (GeoDa).",
  "Visualización cartográfica y diseño con QGIS.",
];

const unit02Goals = [
  "Modelado de superficies continuas mediante interpolación geoestadística (Kriging).",
  "Estimar y validar variogramas experimentales y teóricos.",
  "Implementar modelos espaciales de regresión (SAR, SEM, GWR).",
  "Evaluar la heterogeneidad espacial y la dependencia local.",
  "Generar reportes reproducibles con R / Python para análisis espacial avanzado.",
];

const unit01Tasks = [
  {
    taskId: "TSK-U1-01",
    date: "10/04/2026",
    title: "Vectores & Shapes",
    description:
      "Monografía detallada sobre vectores y shapes. Mínimo 3 páginas con al menos 5 fuentes bibliográficas (IEEE, Scopus) incluyendo DOI.",
    fileSize: "2.4 MB",
    computeTime: "0.15s",
    variant: "vector" as const,
    pdfUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-01",
    repoUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-01",
  },
  {
    taskId: "TSK-U1-02",
    date: "19/04/2026",
    title: "Ubicación Espacial - Análisis ENA",
    description:
      "Análisis de ubicación espacial para 3 variables de la Encuesta Nacional Agraria. Incluye procesamiento en R y generación de mapas temáticos.",
    fileSize: "12.8 MB",
    computeTime: "4.2s",
    variant: "heatmap" as const,
    pdfUrl: "https://github.com/valec3/unap-spatial-statistics/blob/main/unidades/unidad-01/tareas/tarea-02-ena/informe/Informe_Tarea02_ENA.pdf.pdf",
    repoUrl: "https://github.com/valec3/unap-spatial-statistics/tree/main/unidades/unidad-01/tareas/tarea-02-ena",
  },
  {
    taskId: "TSK-U1-03",
    date: "2026.04.28",
    title: "Tarea 03 - Placeholder",
    description: "Espacio reservado para la siguiente entrega de la Unidad 01.",
    fileSize: "0 KB",
    computeTime: "0.0s",
    variant: "cluster" as const,
  },
  {
    taskId: "TSK-U1-04",
    date: "2026.05.05",
    title: "Tarea 04 - Placeholder",
    description: "Espacio reservado para la siguiente entrega de la Unidad 01.",
    fileSize: "0 KB",
    computeTime: "0.0s",
    variant: "mesh" as const,
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
          unitTitle="GEOCIENCIAS · ELT · TIGS"
          monitorTitle="Investigación preliminar basada en el análisis exploratorio de datos espaciales."
          goals={unit01Goals}
          tasks={unit01Tasks}
          article={unit01Article}
          period="30 de Marzo al 25 de Mayo del 2026"
          progressPercent={20}
        />

        {/* <UnitSection
          unitNumber="02"
          unitTitle="GEOESTADÍSTICA · MODELADO"
          monitorTitle="Logros de Aprendizaje — Modelado e Interpolación Espacial"
          goals={unit02Goals}
          tasks={unit02Tasks}
          article={unit02Article}
        /> */}

        <Footer />
      </main>
    </>
  );
};

export default Index;
