# Testing convergence to true solution by refining the timesteps 
#
import os
import numpy as np

def time_ref(dt):
    
    #refine dt
    extension = " Executioner/dt=%s " %dt
    return extension

def parallel(N_treads):
    return " --n-threads=%s "%N_treads 

def freq(frequency):
    return " frequency=%s "%frequency 

def trans(power, num_points):
    
    #refine dt
    extension = " Transfers/push_C/num_points=%s " %num_points
    extension += " Transfers/push_C/power=%s " %power
    return extension

def save_data(name, N_treads, dt, fre):

    extension = "Outputs/outfile/file_base=data/"  
    extension +=  name
    extension += "_dt=%s_" %dt 
    extension += "%s"%N_treads 
    extension += "frequency=%s"%fre 
    #extension += "num_points=%s"%num_points
    
    return extension


para = True
file_name = "2.1"
executable = "../../../squirrel-opt -i "
N_treads = 4
frequencies = [0.0125, 0.025, 0.05, 0.1, 0.2, 0.4, 0.8]
frequencies = [0.0125]
frequencies = [0.8,0.0125]
for frequency in frequencies:
    frequency = frequency*np.pi
    dt = 1/(21*frequency)
    comand = executable + file_name + ".i" 
    comand += parallel(N_treads)
    comand += time_ref(dt) 
    comand += freq(frequency) 
    #comand += trans(power, num_points)
    comand += save_data(file_name, N_treads, dt, frequency)
    print(comand)
    os.system(comand)

    
