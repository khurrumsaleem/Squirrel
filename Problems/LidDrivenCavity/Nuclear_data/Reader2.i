#set mesh
[Mesh]
  type = GeneratedMesh
  allow_renumbering = false
  dim = 2
  xmin = 0
  xmax = 2
  ymin = 0
  ymax = 2
  nx = 19 
  ny = 19
[]

# PK
[Variables]
  [C1]
  []
  [C2]
  []
  [C3]
  []
  [C4]
  []
  [C5]
  []
  [C6]
  []
  [C7]
  []
  [C8]
  []
  [C_tot]
  []
  [power]
  []
  [Delta_rho]
  []
[]

[ICs]
  [Initial_C1]
    type = FunctionIC
    variable = 'C1'
    function =  C1_func
  []
  [Initial_C2]
    type = FunctionIC
    variable = 'C2'
    function =  C2_func
  []
  [Initial_C3]
    type = FunctionIC
    variable = 'C3'
    function =  C3_func
  []
  [Initial_C4]
    type = FunctionIC
    variable = 'C4'
    function =  C4_func
  []
  [Initial_C5]
    type = FunctionIC
    variable = 'C5'
    function =  C5_func
  []
  [Initial_C6]
    type = FunctionIC
    variable = 'C6'
    function =  C6_func
  []
  [Initial_C7]
    type = FunctionIC
    variable = 'C7'
    function =  C7_func
  []
  [Initial_C8]
    type = FunctionIC
    variable = 'C8'
    function =  C8_func
  []
  [Initial_tot]
    type = FunctionIC
    variable = 'C_tot'
    function =  C_tot_func
  []
  [Initial_Power]
    type = FunctionIC
    variable = 'power'
    function =  power_func
  []
  [Initial_Delta_rho]
    type = FunctionIC
    variable = 'Delta_rho'
    function =  Delta_rho_func
  []
[]

[UserObjects]
  [reader_C1]
    type = PropertyReadFile
    prop_file_name = 'C1.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C2]
    type = PropertyReadFile
    prop_file_name = 'C1.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C3]
    type = PropertyReadFile
    prop_file_name = 'C3.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C4]
    type = PropertyReadFile
    prop_file_name = 'C4.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C5]
    type = PropertyReadFile
    prop_file_name = 'C5.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C6]
    type = PropertyReadFile
    prop_file_name = 'C6.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C7]
    type = PropertyReadFile
    prop_file_name = 'C7.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C8]
    type = PropertyReadFile
    prop_file_name = 'C8.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_C_tot]
    type = PropertyReadFile
    prop_file_name = 'C_tot.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_power]
    type = PropertyReadFile
    prop_file_name = 'power.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
  [reader_Delta_rho]
    type = PropertyReadFile
    prop_file_name = 'rho_feedback.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
[]

[Functions]
#load from CSV
  [C1_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C1'
    read_type = 'node'
    column_number = '0'
  []
  [C2_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C2'
    read_type = 'node'
    column_number = '0'
  []
  [C3_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C3'
    read_type = 'node'
    column_number = '0'
  []
  [C4_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C4'
    read_type = 'node'
    column_number = '0'
  []
  [C5_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C5'
    read_type = 'node'
    column_number = '0'
  []
  [C6_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C6'
    read_type = 'node'
    column_number = '0'
  []
  [C7_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C7'
    read_type = 'node'
    column_number = '0'
  []
  [C8_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C8'
    read_type = 'node'
    column_number = '0'
  []
  [C_tot_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_C_tot'
    read_type = 'node'
    column_number = '0'
  []
  [power_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_power'
    read_type = 'node'
    column_number = '0'
  []
  [Delta_rho_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_Delta_rho'
    read_type = 'node'
    column_number = '0'
  []
[]



[Kernels]
 [C1]
    type = NullKernel
    variable = C1
 []
 [C2]
    type = NullKernel
    variable = C2
 []
 [C3]
    type = NullKernel
    variable = C3
 []
 [C4]
    type = NullKernel
    variable = C4
 []
 [C5]
    type = NullKernel
    variable = C5
 []
 [C6]
    type = NullKernel
    variable = C6
 []
 [C7]
    type = NullKernel
    variable = C7
 []
 [C8]
    type = NullKernel
    variable = C8
 []
 [C_tot]
    type = NullKernel
    variable = C_tot
 []
 [power]
    type = NullKernel
    variable = power
 []
 [Delta_rho]
    type = NullKernel
    variable = Delta_rho
 []
[]


[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
[]

[Postprocessors]
  [power_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = power
  []
  [Delta_rho_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = Delta_rho
  []
  [power_int]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_begin'
    variable = power
  []
  [C_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = C1
  []
[]
