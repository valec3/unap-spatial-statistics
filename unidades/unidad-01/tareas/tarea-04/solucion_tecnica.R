# Resolución Tarea 04 - Distribución Normal/Gaussiana

library(stats)

# --- Ejercicio 1: Sensores IoT ---
# X ~ N(70, 5^2)
mu1 <- 70
sigma1 <- 5

# a) Intervalo normal [mu - 3sigma, mu + 3sigma]
int_min <- mu1 - 3*sigma1
int_max <- mu1 + 3*sigma1
# b) P(X > 82)
p_x_gt_82 <- 1 - pnorm(82, mean = mu1, sd = sigma1)
# c) ¿Es 82 una anomalía? Si está fuera de [mu - 3sigma, mu + 3sigma]
is_anomaly <- 82 > int_max

cat("E1 - Intervalo:", int_min, "-", int_max, "\n")
cat("E1 - P(X > 82):", p_x_gt_82, "\n")
cat("E1 - Anomalía:", is_anomaly, "\n\n")

# --- Ejercicio 2: Crédito Bancario ---
# X ~ N(650, 80^2)
mu2 <- 650
sigma2 <- 80

# a) Z para X = 550
z2_a <- (550 - mu2) / sigma2
# b) P(X < 550) - Proporción de alto riesgo
p_x_lt_550 <- pnorm(550, mean = mu2, sd = sigma2)
# c) Umbral para que el riesgo sea solo 5% (P(X < T) = 0.05)
# Usando qnorm (percentil)
umbral_5pct <- qnorm(0.05, mean = mu2, sd = sigma2)

cat("E2 - Z(550):", z2_a, "\n")
cat("E2 - P(X < 550):", p_x_lt_550, "\n")
cat("E2 - Umbral 5%:", umbral_5pct, "\n\n")

# --- Ejercicio 3: Errores de Regresión ---
# epsilon ~ N(0, 200^2)
mu3 <- 0
sigma3 <- 200

# a) P(|epsilon| > 400) = P(epsilon > 400) + P(epsilon < -400) = 2 * P(epsilon < -400)
p_error_inacceptable <- 2 * pnorm(-400, mean = mu3, sd = sigma3)
# b) Esperanza en 30 días de errores inaceptables X ~ Bin(30, p)
esperanza_30d <- 30 * p_error_inacceptable
# c) Nueva sigma = 120. P(|epsilon| > 400)
sigma3_new <- 120
p_error_inacceptable_new <- 2 * pnorm(-400, mean = mu3, sd = sigma3_new)

cat("E3 - P(|e| > 400):", p_error_inacceptable, "\n")
cat("E3 - Esperanza 30d:", esperanza_30d, "\n")
cat("E3 - P con sigma=120:", p_error_inacceptable_new, "\n\n")

# --- Ejercicio 4: Streaming (Edades) ---
# X ~ N(34, 9^2)
mu4 <- 34
sigma4 <- 9

# a) P(25 < X < 43)
p_range_4 <- pnorm(43, mu4, sigma4) - pnorm(25, mu4, sigma4)
# b) ¿55 años es outlier? (Z > 2 o Z > 3?)
z_55 <- (55 - mu4) / sigma4
# c) Percentil 90 (P(X < T) = 0.90)
p90_age <- qnorm(0.90, mu4, sigma4)

cat("E4 - P(25-43):", p_range_4, "\n")
cat("E4 - Z(55):", z_55, "\n")
cat("E4 - Percentil 90:", p90_age, "\n\n")

# --- Ejercicio 5: Sistemas Distribuidos ---
# X ~ N(120, 25^2)
mu5 <- 120
sigma5 <- 25

# a) Tiempo T tal que P(X < T) = 0.99
t_99 <- qnorm(0.99, mu5, sigma5)
# b) Duplicación de varianza: Var_new = 2 * 25^2 -> sigma_new = sqrt(2) * 25
sigma5_new <- sqrt(2) * 25
t_99_new <- qnorm(0.99, mu5, sigma5_new)

cat("E5 - T(99%):", t_99, "\n")
cat("E5 - T con Var x2:", t_99_new, "\n")
