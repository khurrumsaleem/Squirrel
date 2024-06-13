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


[Variables]
    [Dummy]
    []
[]
# PK
[AuxVariables]
  [C_tot]
  []
  [power]
  []
  [flux]
  []
[]

[ICs]
  [Initial_Power]
    type = FunctionIC
    variable = 'power'
    function =  power_func
  []
[]

[UserObjects]
  [reader_power]
    type = PropertyReadFile
    prop_file_name = 'power.csv'
    read_type = 'node'
    nprop = 1  # number of columns in CSV
    execute_on = 'INITIAL'
  []
[]

[Functions]
#load from CSV
  [power_func]
    type = PiecewiseConstantFromCSV
    read_prop_user_object = 'reader_power'
    read_type = 'node'
    column_number = '0'
  []
[]

[Kernels]
 [Dummy]
    type = NullKernel
    variable = Dummy
 []
[]

[AuxKernels]
    [power_scale]
        type = NormalizationAux 
        variable = flux 
        source_variable = power
        normalization = power_sum
        normal_factor = 3.14
    []
    [C_tot]
        type = ParsedAux
        variable = C_tot
        coupled_variables = "flux"
        expression = "5*flux"
    []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = false
[]

[Postprocessors]
  [power_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = power
  []
  [power_int]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL TIMESTEP_END'
    variable = power
  []
  [flux_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = flux 
  []
  [flux_int]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL TIMESTEP_END'
    variable = flux
  []
  [C_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = C_tot
  []
[]
