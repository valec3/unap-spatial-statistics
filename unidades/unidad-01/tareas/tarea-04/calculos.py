import math

def erf(x):
    # Approximating erf for normal calculations
    a1 =  0.254829592; a2 = -0.284496736; a3 =  1.421413741;
    a4 = -1.453152027; a5 =  1.061405429; p  =  0.3275911;
    sign = 1 if x >= 0 else -1; x = abs(x);
    t = 1.0/(1.0 + p*x);
    y = 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t*math.exp(-x*x);
    return sign*y;

def norm_cdf(x, mu, sigma):
    return 0.5 * (1 + erf((x - mu) / (sigma * math.sqrt(2))));

print("--- RESULTADOS TAREA 04 ---")
# E1
mu1, sigma1 = 70, 5
print(f'E1 - Intervalo: {mu1-3*sigma1} - {mu1+3*sigma1}')
print(f'E1 - P(X > 82): {1 - norm_cdf(82, mu1, sigma1):.6f}')
print(f'E1 - Anomalia: {82 > mu1+3*sigma1}')

# E2
mu2, sigma2 = 650, 80
print(f'E2 - Z(550): {(550-650)/80:.4f}')
print(f'E2 - P(X < 550): {norm_cdf(550, mu2, sigma2):.6f}')
# P(Z < -1.6449) = 0.05
print(f'E2 - Umbral 5%: {mu2 - 1.6449 * sigma2:.4f}')

# E3
mu3, sigma3 = 0, 200
p_e = 2 * norm_cdf(-400, mu3, sigma3)
print(f'E3 - P(|e| > 400): {p_e:.6f}')
print(f'E3 - Esperanza 30d: {30 * p_e:.4f}')
print(f'E3 - P con sigma=120: {2 * norm_cdf(-400, mu3, 120):.6f}')

# E4
mu4, sigma4 = 34, 9
print(f'E4 - P(25-43): {norm_cdf(43, mu4, sigma4) - norm_cdf(25, mu4, sigma4):.6f}')
print(f'E4 - Z(55): {(55-34)/9:.4f}')
# P(Z < 1.2816) = 0.90
print(f'E4 - Percentil 90: {mu4 + 1.2816 * sigma4:.4f}')

# E5
mu5, sigma5 = 120, 25
# P(Z < 2.3263) = 0.99
print(f'E5 - T(99%): {mu5 + 2.3263 * sigma5:.4f}')
print(f'E5 - T con Var x2: {mu5 + 2.3263 * math.sqrt(2) * sigma5:.4f}')
