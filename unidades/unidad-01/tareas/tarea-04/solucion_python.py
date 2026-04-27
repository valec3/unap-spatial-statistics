import scipy.stats as stats
import math

# --- Ejercicio 1: Sensores IoT ---
mu1, sigma1 = 70, 5
int_min, int_max = mu1 - 3*sigma1, mu1 + 3*sigma1
p_x_gt_82 = 1 - stats.norm.cdf(82, mu1, sigma1)
is_anomaly = 82 > int_max

print(f"E1 - Intervalo: {int_min} - {int_max}")
print(f"E1 - P(X > 82): {p_x_gt_82:.6f}")
print(f"E1 - Anomalía: {is_anomaly}\n")

# --- Ejercicio 2: Crédito Bancario ---
mu2, sigma2 = 650, 80
z2_a = (550 - mu2) / sigma2
p_x_lt_550 = stats.norm.cdf(550, mu2, sigma2)
umbral_5pct = stats.norm.ppf(0.05, mu2, sigma2)

print(f"E2 - Z(550): {z2_a:.4f}")
print(f"E2 - P(X < 550): {p_x_lt_550:.6f}")
print(f"E2 - Umbral 5%: {umbral_5pct:.4f}\n")

# --- Ejercicio 3: Errores de Regresión ---
mu3, sigma3 = 0, 200
p_error_inacceptable = 2 * stats.norm.cdf(-400, mu3, sigma3)
esperanza_30d = 30 * p_error_inacceptable
sigma3_new = 120
p_error_inacceptable_new = 2 * stats.norm.cdf(-400, mu3, sigma3_new)

print(f"E3 - P(|e| > 400): {p_error_inacceptable:.6f}")
print(f"E3 - Esperanza 30d: {esperanza_30d:.4f}")
print(f"E3 - P con sigma=120: {p_error_inacceptable_new:.6f}\n")

# --- Ejercicio 4: Streaming (Edades) ---
mu4, sigma4 = 34, 9
p_range_4 = stats.norm.cdf(43, mu4, sigma4) - stats.norm.cdf(25, mu4, sigma4)
z_55 = (55 - mu4) / sigma4
p90_age = stats.norm.ppf(0.90, mu4, sigma4)

print(f"E4 - P(25-43): {p_range_4:.6f}")
print(f"E4 - Z(55): {z_55:.4f}")
print(f"E4 - Percentil 90: {p90_age:.4f}\n")

# --- Ejercicio 5: Sistemas Distribuidos ---
mu5, sigma5 = 120, 25
t_99 = stats.norm.ppf(0.99, mu5, sigma5)
sigma5_new = math.sqrt(2) * 25
t_99_new = stats.norm.ppf(0.99, mu5, sigma5_new)

print(f"E5 - T(99%): {t_99:.4f}")
print(f"E5 - T con Var x2: {t_99_new:.4f}")
