# Análisis Detallado: Tarea 04 - Variable Aleatoria Gaussiana

Este documento proporciona una explicación técnica y conceptual profunda de los ejercicios resueltos sobre la **Distribución Normal** o **Gaussiana**. No se trata solo de números; es entender cómo la variabilidad gobierna los sistemas reales.

---

## 🧠 El Concepto Fundamental: ¿Por qué Gauss?

La distribución normal $N(\mu, \sigma^2)$ es el pilar de la estadística espacial y la ingeniería de datos. Se define por dos parámetros:
- **Media ($\mu$):** El centro de masa de tus datos.
- **Desviación Estándar ($\sigma$):** Qué tan "nerviosos" o dispersos están los datos.

La clave de estos ejercicios es la **Estandarización**: llevar cualquier mundo real al mundo de la Normal Estándar $Z \sim N(0, 1)$ usando la fórmula:
$$Z = \frac{X - \mu}{\sigma}$$

---

## 📡 Ejercicio 1: Sensores IoT (Temperatura)
**Contexto:** Monitoreo térmico donde $X \sim N(70, 5^2)$.

### 1. Intervalo de Normalidad ($3\sigma$)
En ingeniería, la regla de las "Tres Sigmas" nos dice que el 99.7% de los datos caen dentro de este rango. Es el límite de lo "esperable".
- **Cálculo:** $70 \pm 3(5) \rightarrow [55, 85]$.
- **Significado:** Si un sensor marca fuera de este rango, probablemente esté roto o algo muy grave está pasando.

### 2. Probabilidad de Eventos Extremos ($X > 82$)
Para hallar esto, "viajamos" al mundo de $Z$:
$$Z = \frac{82 - 70}{5} = 2.4$$
Un valor de 2.4 desviaciones estándar por encima de la media. La probabilidad es ínfima ($\approx 0.82\%$).

### 3. El Dilema de la Anomalía
¿Es 82 una anomalía? Técnicamente está dentro del rango $3\sigma$, pero su probabilidad es tan baja que en un sistema de monitoreo real, esto debería disparar una **alerta preventiva**. No es un error del sensor, pero es un comportamiento atípico.

---

## 🏦 Ejercicio 2: Crédito Bancario (Riesgo)
**Contexto:** Evaluación de clientes con $X \sim N(650, 80^2)$.

### 1. Estandarización de Riesgo
Para un puntaje de 550, calculamos su posición relativa:
$$Z = \frac{550 - 650}{80} = -1.25$$
El cliente está a 1.25 desviaciones estándar por debajo del promedio.

### 2. Proporción de Alto Riesgo
Buscamos el área a la izquierda de $-1.25$. El resultado es **10.56%**. Uno de cada diez clientes es considerado de alto riesgo bajo este umbral.

### 3. Ingeniería de Umbrales (Targeting)
Si el banco solo quiere aceptar un 5% de riesgo, necesitamos encontrar el puntaje exacto ($T$). 
Usamos el valor crítico $Z = -1.645$:
$$T = 650 + (-1.645 \cdot 80) = 518.4$$
**Lección:** Al bajar el umbral de 550 a 518, el banco se vuelve más permisivo pero controla estadísticamente su exposición al fracaso.

---

## 📉 Ejercicio 3: Errores de Regresión
**Contexto:** Precisión de modelos con errores $\epsilon \sim N(0, 200^2)$.

### 1. Probabilidad de Error Crítico
Un error de $\pm 400$ es el doble de la desviación estándar ($Z = 2$). La probabilidad de que el error supere este límite (en ambas direcciones) es del **4.55%**.

### 2. Esperanza Matemática
Si operamos el modelo por 30 días, ¿cuántos días fallará?
$$E[Y] = 30 \times 0.0455 \approx 1.36 \text{ días}$$
**Interpretación:** No podemos esperar perfección; la estadística nos dice que al menos un día al mes tendremos un problema serio.

### 3. Optimización de Procesos (Reducción de $\sigma$)
Si mejoramos el algoritmo y bajamos $\sigma$ a 120:
El mismo error de 400 ahora representa un $Z = 3.33$. La probabilidad de fallo cae a **0.086%**.
**MORALEJA:** En ingeniería, no intentes cambiar la media, **¡ataca la varianza!** La consistencia es lo que hace a un sistema robusto.

---

## 🎬 Ejercicio 4: Streaming (Segmentación)
**Contexto:** Audiencia joven/adulta con $X \sim N(34, 9^2)$.

### 1. El "Sweet Spot" de la Audiencia
El rango [25, 43] años corresponde exactamente a $\pm 1\sigma$. La regla empírica dicta que el **68.27%** de tus usuarios están ahí. Es tu mercado principal.

### 2. ¿Cuándo alguien es "Viejo" para el sistema?
Un usuario de 55 años tiene un $Z = 2.33$. 
- Es un **outlier ligero** (más allá de $2\sigma$).
- No es un **outlier extremo** (no llega a $3\sigma$).

### 3. El Top 10% (Early Adopters/Senior Users)
Buscamos el percentil 90 ($Z = 1.282$).
$$\text{Edad} = 34 + (1.282 \cdot 9) \approx 45.5 \text{ años}$$
Cualquier persona mayor de 45 años pertenece al 10% más veterano de la plataforma.

---

## 💻 Ejercicio 5: Sistemas Distribuidos (Latencia)
**Contexto:** Tiempo de respuesta de servidores $X \sim N(120, 25^2)$ ms.

### 1. Definición de SLA (Service Level Agreement)
Para garantizar que el 99% de las peticiones carguen rápido, fijamos el umbral en $Z = 2.326$:
$$T = 120 + (2.326 \cdot 25) = 178.15 \text{ ms}$$
Este es el tiempo máximo que le prometes al cliente.

### 2. El Caos de la Varianza
Si la varianza se duplica (inestabilidad en la red), el SLA sube a **202.24 ms**. 
**Conclusión Técnica:** Aunque el promedio de respuesta siga siendo 120ms, la inestabilidad (varianza) arruina la experiencia del usuario final al aumentar los tiempos máximos.

---

> [!TIP]
> **Recuerda siempre:** La media te dice dónde estás, pero la desviación estándar te dice qué tan confiable es esa posición. ¡No ignores los extremos!
