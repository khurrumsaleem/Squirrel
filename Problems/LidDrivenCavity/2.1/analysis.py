import numpy as np
from scipy.optimize import curve_fit
from scipy.signal import argrelextrema
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq, fftshift

#########################################################
# def functions 
#########################################################
def func(x, a, b, c, d):
    return -a * np.sin(b*x+c) +d

def gain(power_max, power_mean,gain_value):

    return (abs(power_max/power_mean))/(gain_value)

def phase(data, signal, time, freq):
    index_da = argrelextrema(data, np.greater)[:]
    index_sig = argrelextrema(signal, np.greater)[:]
    print("delta t", time[index_da]-time[index_sig]) 
    print("data index", time[index_da]) 
    return -(np.mean(np.abs(time[index_da]-time[index_sig]))*freq*360)



x = [0.0125, 0.025, 0.05, 0.1, 0.2, 0.4, 0.8]
y_gain = []
y_phase = []

#########################################################
# Calculation
#########################################################
for k in x: 
    dt = 1/(40*k*np.pi)
    print("freq ", k, dt)
    print("time ", 1000*dt)
    Squirrel = np.loadtxt("data/2.1_dt=%s_4frequency=%s.csv"%(dt, k*np.pi), skiprows=1, delimiter=' ')
    Squirrel = Squirrel.T
    
    data = Squirrel[-1]
    t = Squirrel[0]
    # cut of initial
    cut = 2000
    da = data [cut:]
    t = t[cut:] 
    popt, pcov = curve_fit(func, t, da, [10, 2*k*np.pi, 0, 1.1])
    
    print("mean power: ", np.mean(da))
    print("popt",popt)
    print(np.sqrt(np.diagonal(pcov)))
    if 0:
        plt.plot(t, func(t, *popt), '--', label = "fit")
        plt.plot(t, da, label="data")
        plt.legend()
        plt.plot(t, func(t, popt[0], k*2*np.pi, 0, popt[3]), label = "signal")
        plt.legend()
        if k == 0.8 or k==0.4 or k==0.0125:
            plt.savefig("data_plot_%s.pdf" %k)
        plt.show()
    data_gain = gain(popt[0], popt[3], 0.4) 
    # cut of initial
    print("gain = ", data_gain)
    y_gain.append(data_gain)

    y_phase.append(phase(da, func(t, popt[0], k*2*np.pi, 0, popt[3]), t, k))
    print()
plt.show() 



#########################################################
#Plot figures 
#########################################################
plt.figure(figsize=(8.27, 4))
if 1:
    plt.subplot(1,2,1)
    plt.xscale("log")
    plt.yscale("log")
    plt.grid(True, which="both", ls="-")
    plt.plot(np.array(x), y_gain, "o",color = "orange", label ="Squirrel")
    plt.legend()
    plt.xticks([0.0125, 0.1, 1])
    plt.yticks([0.05, 0.1, 1])
    plt.ylabel("Magnitude [-]")
    plt.xlabel("Frequency [Hz]")

if 1:
    plt.subplot(1,2,2)
    plt.xscale("log")
    plt.plot(x, np.array(y_phase), "o", label = "Squirrel", color = "orange")
    plt.ylabel("Phase [degrees]")
    plt.xlabel("Frequency [Hz]")
    plt.xticks([0.0125, 0.1, 1])
    plt.grid(True, which="both", ls="-")

plt.tight_layout()
plt.savefig("Bode_21.pdf")
plt.show()


