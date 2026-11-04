import math

# Pisot inflation constants and their topological entropies
pisot = {
    'Fibonacci (phi)': (1.6180339887, 'A->AB, B->A'),
    'Tribonacci (eta)': (1.8392867552, 'A->AB, B->AC, C->A'),
    'Tetranacci (eta4)': (1.9275619755, 'A->AB, B->AC, C->AD, D->A'),
    'Padovan (rho)': (1.3247179572, 'A->B, B->AC, C->A'),
    'Narayana (psi)': (1.4655712319, 'A->AB, B->C, C->A'),
}

print("=== Pisot Family Topological Entropy ===")
for name, (val, rule) in pisot.items():
    h = math.log(val)
    print(f"{name}: beta={val:.6f}, h=log(beta)={h:.6f}")

# Non-Pisot for comparison
nonpisot = {
    'sqrt(2)': 1.4142135623,
    'sqrt(3)': 1.7320508076,
    'golden_conj': 0.6180339887,  # conjugate, <1
}

print("\n=== Non-Pisot Perron (for contrast) ===")
for name, val in nonpisot.items():
    if val > 1:
        h = math.log(val)
        print(f"{name}: beta={val:.6f}, h=log(beta)={h:.6f}")
    else:
        print(f"{name}: beta={val:.6f} (conjugate <1, not Perron)")

print("\n=== Key insight ===")
print("Pisot: h=log(beta) BUT spectrum is pure point (discrete)")
print("Non-Pisot Perron: h=log(beta) BUT spectrum is continuous/weak mixing")
print("Same entropy formula, DIFFERENT spectral type!")
