# Proceso de analisis: CACAO (ENA 2014-2024)

## 1) Objetivo

Construir una base integrada (modulos 1893 y 1895), calcular altitud para cada productor, clasificar pisos altitudinales con Jenks y generar indicadores para decidir donde conviene cultivar CACAO con mayor estabilidad.

## 2) Insumos principales

- Dataset consolidado con variables productivas y georeferenciadas.
- DEMs locales (GeoTIFF) para extraer altitud de los puntos.
- Shapefile de departamentos para mapas por departamento.

## 3) Flujo de trabajo (resumen)

1. **Consolidacion de datos**: se unifican modulos 1893 (caratula y uso de tierra) con 1895 (produccion). Se calcula `PROD_TOTAL_KG` y `RENDIMIENTO_HA`.
2. **Altitud**: se extrae el valor de altitud desde los DEMs usando las coordenadas `LONGITUD`/`LATITUD`.
3. **Pisos altitudinales**: se aplica Jenks para agrupar altitudes en 5 pisos.
4. **Indicadores**: se resume por piso y cultivo con mediana, desviacion estandar y conteo.
5. **Recomendacion**: se clasifica cada piso en optimo, riesgo o descartado.
6. **Mapas**: se crea un mapa coropletico de CACAO por departamento.

## 4) Que es Jenks y por que se usa

**Jenks Natural Breaks** es un metodo de clasificacion que encuentra cortes optimos en una variable continua. Su objetivo es:

- Minimizar la variacion dentro de cada clase.
- Maximizar la variacion entre clases.

En este caso, Jenks se aplica sobre `ALTITUD`, lo que genera pisos altitudinales que representan cambios naturales en el relieve (y en condiciones productivas).

## 5) Indicadores calculados

Para cada **PISO_ALTITUDINAL** y **cultivo** (en este caso CACAO), se calcula:

- **Mediana de rendimiento**: valor tipico de rendimiento (mas robusto que el promedio).
- **Desviacion estandar**: estabilidad del rendimiento (alta = inestable).
- **Conteo**: cantidad de observaciones (para evitar conclusiones con pocos datos).
- **Heladas (P223B_3)**: riesgo de afectacion climatica.

## 6) Matriz de recomendacion

Se usa una logica simple basada en cuantiles:

- **Zona Optima**: mediana alta y desviacion baja.
- **Zona de Riesgo**: mediana alta pero con muchas heladas.
- **Zona Descartada**: mediana baja y desviacion alta.
- **Zona Intermedia**: el resto.

Esto permite identificar **donde conviene** y **donde es riesgoso** invertir en CACAO.

## 7) Interpretacion: como decidir donde cultivar

1. Abre `matriz_recomendacion.csv`.
2. Filtra por `P204_NOM = CACAO`.
3. Observa los pisos con **Zona Optima**: esos pisos son los recomendados.
4. Verifica tambien el **conteo** para asegurar robustez.

## 8) Salidas principales

- `Dataset_Final_Analisis_Altitud.csv`: base completa con altitud y pisos.
- `resumen_pisos_cultivo.csv`: resumen por piso y cultivo.
- `matriz_recomendacion.csv`: clasificacion optimo/riesgo/descartado.
- `cacao_mapa_departamentos.png`: mapa coropletico del promedio por departamento.
- `cacao_promedio_departamentos.csv`: tabla de promedios por departamento.

## 9) Notas importantes

- Los mapas solo muestran departamentos con datos disponibles.
- Si un punto no cae dentro de los DEMs, su altitud queda como NA.
- Si quieres mas precision, se puede reemplazar el DEM por uno de mayor resolucion.

## 10) Recomendaciones de uso

- No uses solo un indicador; combina rendimiento, estabilidad y riesgo.
- Evita conclusiones con conteos bajos.
- Revalida con datos locales y conocimiento agronomico.
