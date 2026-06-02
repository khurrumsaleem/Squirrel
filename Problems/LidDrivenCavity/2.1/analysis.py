import numpy as np
from scipy.optimize import curve_fit
from scipy.signal import argrelextrema
import matplotlib.pyplot as plt
#########################################################
# Plot setup
#########################################################
def set_size(width, fraction=1):
    """Set figure dimensions to avoid scaling in LaTeX.

    Parameters
    ----------
    width: float
            Document textwidth or columnwidth in pts
    fraction: float, optional
            Fraction of the width which you wish the figure to occupy

    Returns
    -------
    fig_dim: tuple
            Dimensions of figure in inches
    """
    # Width of figure (in pts)
    fig_width_pt = width * fraction

    # Convert from pt to inches
    inches_per_pt = 1 / 72.27

    # Golden ratio to set aesthetic figure height
    # https://disq.us/p/2940ij3
    golden_ratio = (5**.5 - 1) / 2

    # Figure width in inches
    fig_width_in = fig_width_pt * inches_per_pt
    # Figure height in inches
    fig_height_in = fig_width_in * golden_ratio

    fig_dim = (fig_width_in, fig_height_in)

    return fig_dim

#plt.style.library['seaborn-whitegrid']
tex_fonts = {
    # Use LaTeX to write all text
    "text.usetex": True,
    "font.family": "serif",
    # Use 10pt font in plots, to match 10pt font in document
    "axes.labelsize": 10,
    "font.size": 10,
    # Make the legend/label fonts a little smaller
    "legend.fontsize": 8,
    "xtick.labelsize": 8,
    "ytick.labelsize": 8
}


width = 469.75
fig, ax = plt.subplots(1, 1, figsize=set_size(width))
plt.style.use('seaborn-whitegrid')
#########################################################
# Calculation
#########################################################

def func(x, a, b, c, d):
    return a * np.sin(b*x+c) +d

def gain(power_max, power_mean,gain_value):

    return (abs(power_max/power_mean))/(gain_value)

def phase(data, signal, time, freq):
    index_da = argrelextrema(data, np.greater)[:]
    index_sig = argrelextrema(signal, np.greater)[:]
    print("signal index", len(index_sig)) 
    print("data indec", len(index_da)) 
    return 2*np.pi*freq*(time[index_da]-time[index_sig])+1/(40*freq*2*np.pi)



# load CNRS data
path = "../../../../../CNRS_benchmark/input_data/"
CNRS_data = path + "CNRS_paper_raw_results/Step21/"
SEALION_data = path + "SEALION_raw_results/Step21/"


#Load Benchmark


x = [0.0125, 0.025, 0.05, 0.1, 0.2, 0.4, 0.8]
x = [0.0125, 0.8]
y_gain = []
y_phase = []
for k in x: 
#for name in ["","data/power_seabrain_0.8.csv"]:
    dt = 1/(21*k*np.pi)
    print("freq ", k, dt)
    print("time ", 1000*dt)
    MOOSE = np.loadtxt("data/2.1_dt=%s_4frequency=%s.csv"%(dt, k*np.pi), skiprows=1, delimiter=' ')
    #MOOSE = np.loadtxt("data/new_py2.1_init_dt=%s_4frequency=%s.csv"%(dt, k*np.pi), skiprows=1, delimiter=' ')
    MOOSE = MOOSE.T
    
    print("length moose data", len(MOOSE[0]))
    data = MOOSE[-1]
    t = MOOSE[0]
    # cut of initial
    cut = 20
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
    y_phase.append(popt[2])
    #y_phase.append(phase(da, func(t, popt[0], k*2*np.pi, 0, popt[3]), t, k))

uni_names =  ["CNRS-SP$_1$","CNRS-SP$_2$", "PoloMi", "PSI", "TUD-S$_2$", "TUD-S$_3$"]
cd = np.loadtxt(CNRS_data + "gain", skiprows=1, delimiter=',' )
cd = cd.T
    
if 1:
    plt.grid(True, which="both", ls="-")
    #Load Benchmark
    for i in range(len(uni_names)):
        plt.loglog(cd[0], cd[i+1], "o", label = uni_names[i])
        #print(cd[i+1])
    #Load SEALION
    sealion_d=[]
    for f in x:
        Sd = np.loadtxt(SEALION_data + "freq_%s.csv"%f, skiprows=1, delimiter=',' )
        Sd = Sd.T
        sealion_d.append(Sd[-1][1])
        print(Sd[-1][0])
    #plt.plot(x, sealion_d, "o", label ="SEALION")
    
    plt.loglog(np.array(x), y_gain, "o",color = "orange", label ="Squirrel")
    plt.legend()
    plt.xticks(x)
    plt.yticks([1,0.3, 0.1, 0.07])
    plt.xlabel("f(Hz)")
    plt.ylabel("Gain")
    plt.savefig("gain.pdf")
    plt.show()
    # calc difference
if 0:
    plt.xscale("log")
    for i in range(len(uni_names)):
        plt.plot(cd[0], cd[i+1]-1, "o", label = uni_names[i])
    print("phase: ", abs(np.degrees(y_phase)))
    #plt.plot(x, np.degrees(np.array(y_phase)/100), "o", label = "Squirrel")
    plt.plot(x[:-1], np.degrees(np.array(y_phase)/100)[:-1], "o", label = "Squirrel")
    plt.plot(x[-1:], -np.degrees(np.array(y_phase)/100)[-1:], "o", label = "Squirrel")
    #plt.plot(x, np.mean(-np.degrees(np.array(y_phase)/100), axis=1), "o", label = "Squirrel")
    #plt.plot(x[:-1], np.mean(-np.degrees(np.array(y_phase[:-1]))/100, axis = 1), "o")
    #plt.plot(x[-1:], np.mean(np.degrees(np.array(y_phase[-1:]))/100, axis = 1), "o")
    plt.legend()
    plt.grid(True, which="both", ls="-")
    plt.savefig("phase_20.pdf")
    plt.show()


