import numpy as np
import matplotlib.pyplot as plt



Exp_data = np.loadtxt("U233_8MW_step.csv", delimiter = ",",skiprows = 1)
Exp_data = Exp_data.T 
plt.plot(Exp_data[0], Exp_data[1], color = "black", label = "ORNL-data")

data = np.loadtxt("flow.csv", skiprows=1,delimiter=",")
data = data.T
power = data[-4]*8/data[-4][0]
Delta_power = power-8
plt.plot(data[-1], Delta_power, color= "orange", label = "Squirrel flow")

data = np.loadtxt("solid_14pcm.csv", skiprows=1,delimiter=",")
data = data.T
power = data[-4]*8/data[-4][0]
Delta_power = power-8
plt.plot(data[-1], Delta_power, "--", color= "orange",label = "Squirrel static")

one_region_data = np.loadtxt("1_region_14.csv", delimiter = ",",skiprows = 1)
one_regionP_0 = one_region_data[10000][1]
one_region_data = one_region_data[11000:12100]
one_region_data = one_region_data.T
plt.plot(one_region_data[0] -1000,one_region_data[1]*8/one_regionP_0-8, "--", label = "One-Region-Model")

only_core_data = np.loadtxt("only_core_14.csv", delimiter = ",",skiprows = 1)
only_coreP_0 = only_core_data[9000][1]
only_core_data = only_core_data[10003:11003]
only_core_data = only_core_data.T 
plt.plot(only_core_data[0] -1000,only_core_data[1]*8/only_coreP_0-8, "--", color = "green",label = "Only-Primary")


plt.grid()
plt.xlabel("time[s]")
plt.ylabel(r"$\Delta P$ [MW]")
plt.tight_layout()
plt.legend()
plt.savefig("0.09.pdf")
plt.show()


