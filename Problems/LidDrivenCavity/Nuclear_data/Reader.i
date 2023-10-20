
rhoPerK = -4 #[pcm/K]

LAMBDA = 9.82015e-07
beta_sum = 6.882528e-03
lambda_sum = 7.6221089e-02

beta1 = 0.000233102
beta2 = 0.00103262
beta3 = 0.000681878
beta4 = 0.00137726
beta5 = 0.00214493
beta6 = 0.000640917
beta7 = 0.000605805
beta8 = 0.000166016

lambda1 = 0.0124667
lambda2 = 0.0282917
lambda3 = 0.0425244
lambda4 = 0.133042
lambda5 = 0.292467
lambda6 = 0.666488
lambda7 = 1.63478
lambda8 = 3.5546
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

[Kernels]
 [Dummy]
    type = NullKernel
    variable = Dummy
 []
[]

# PK
[AuxVariables]
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
  [flux]
  []
  [Delta_rho]
  []
  [power]
  []
  [psi]
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

[AuxKernels]
    [Normalize_psi]
       type =NormalizationAux 
       variable =psi
       source_variable = power
       normalization = power_sum
    []
    [Normalize_flux]
       type =NormalizationAux 
       variable = flux
       source_variable = power
       normalization = B
    []
#    [Normalize_power]
#       type =NormalizationAux 
#       variable =power
#       source_variable = power
#       normalization = power_int
#    []
    [Calc_temp_feedback]
        type = ParsedAux
        variable = Delta_rho
        coupled_variables = flux
        expression = '0.001108*flux*${fparse rhoPerK}/4'
    []
    [Calc_C_tot]
       type = ParsedAux
       variable = C_tot
       coupled_variables = flux
       expression = '${fparse beta_sum}*flux/${fparse LAMBDA}/${fparse lambda_sum}'
    []
    [Calc_C1]
       type = ParsedAux
       variable = C1
       coupled_variables = flux
       expression = '${fparse beta1}*flux/${fparse LAMBDA}/${fparse lambda1}'
    []
    [Calc_C2]
       type = ParsedAux
       variable = C2
       coupled_variables = flux
       expression = '${fparse beta2}*flux/${fparse LAMBDA}/${fparse lambda2}'
    []
    [Calc_C3]
       type = ParsedAux
       variable = C3
       coupled_variables = flux
       expression = '${fparse beta3}*flux/${fparse LAMBDA}/${fparse lambda3}'
    []
    [Calc_C4]
       type = ParsedAux
       variable = C4
       coupled_variables = flux
       expression = '${fparse beta4}*flux/${fparse LAMBDA}/${fparse lambda4}'
    []
    [Calc_C5]
       type = ParsedAux
       variable = C5
       coupled_variables = flux
       expression = '${fparse beta5}*flux/${fparse LAMBDA}/${fparse lambda5}'
    []
    [Calc_C6]
       type = ParsedAux
       variable = C6
       coupled_variables = flux
       expression = '${fparse beta6}*flux/${fparse LAMBDA}/${fparse lambda6}'
    []
    [Calc_C7]
       type = ParsedAux
       variable = C7
       coupled_variables = flux
       expression = '${fparse beta7}*flux/${fparse LAMBDA}/${fparse lambda7}'
    []
    [Calc_C8]
       type = ParsedAux
       variable = C8
       coupled_variables = flux
       expression = '${fparse beta8}*flux/${fparse LAMBDA}/${fparse lambda8}'
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
 [B]
    type = ElementIntegralVariablePostprocessor
     variable = power
    execute_on = 'initial timestep_end'
 []
  [power_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = power
  []
  [psi_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = psi
  []
  [flux_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = flux
  []
  [Delta_rho_sum]
    type = NodalSum
    execute_on = 'INITIAL TIMESTEP_END'
    variable = Delta_rho
  []
  [Delta_rho_int]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL TIMESTEP_END'
    variable = Delta_rho
  []
  [power_int]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_begin'
    variable = power
  []
  [Flux_int]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = flux
  []
  [C1_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = C1
  []
  [C_tot_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = C_tot
  []
[]
