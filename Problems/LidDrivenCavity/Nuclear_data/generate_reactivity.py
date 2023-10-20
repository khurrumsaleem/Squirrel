import numpy as np
import matplotlib.pyplot as plt
import csv
from scipy.optimize import curve_fit

betas =[0.000233102, 0.00103262, 0.000681878, 0.00137726, 0.00214493, 0.000640917, 0.000605805, 0.000166016]
lambdas = [0.0124667, 0.0282917, 0.0425244, 0.133042, 0.292467, 0.666488, 1.63478,3.5546]

name = "Powershape.csv"
#############################################
#   load kinetics
#############################################
kinetic_data = np.loadtxt("kinetic_data")
print(kinetic_data)

LAM = kinetic_data[2]
beta = kinetic_data[0]
print("beta",beta)
lam = kinetic_data[1]
print("lam", lam)
#############################################
#   load static
#############################################
shape = np.loadtxt("Powershape.csv", delimiter = ",")

num_cell = len(shape)
print("num_cell", num_cell)

vol = 4/num_cell
print("vol", vol)

#############################################
#   POWER
#############################################
# normalize 
power = shape/np.sum(shape*vol)
#L2 normalize
#power = shape/np.sum(shape*vol) 
vol = 4/(19*19)
print("power = ", np.sum(vol*power))
print("PP = ", np.sqrt(np.sum(vol*power*power)))

#save 
np.savetxt("power.csv", power)


#############################################
#   DNP
#############################################
C_tot = power * 0
temp = 0
for i in range(8):
    # normalize 
    C = power*betas[i]/LAM/lambdas[i]
    print("C%s"%(i+1), np.sum(C))
    C_tot += C
    #C = power*betas[i]
    temp += np.sum(C)
    #save 
    #np.savetxt("C%s.csv"%(i+1), C)

print("C_tot", np.sum(C_tot), temp)
np.savetxt("C_tot.csv", C_tot)


#############################################
#   Testing
#############################################
def a(P,C,vol, lam):
    b = vol * np.sum(P*C)
    return lam*b/(vol*np.sum(P*P))

print("zähler",  np.sum(vol *power*C_tot))
print("beta/LAM", beta/LAM)
print(a(power, C_tot, vol, lam))




