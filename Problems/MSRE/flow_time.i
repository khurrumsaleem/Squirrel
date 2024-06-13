#PARAMETER
time_out_of_core = 16.74
L = 1.6 # m

beta= 0.00264
beta1 =  0.00023
beta2 =  0.00079
beta3 =  0.00067
beta4 =  0.00073
beta5 =  0.00013
beta6 =  9e-05
lambda1 =  0.0126
lambda2 =  0.0337
lambda3 =  0.139
lambda4 =  0.325
lambda5 =  1.13
lambda6 =  2.5
LAMBDA =  0.0004

u = 0.189
rho = 1.425752e-03 #steady state
rho_external = 11.4e-5

[Problem]
allow_initial_conditions_with_restart = true
[]


[Mesh]
    file = initial.e
[]

[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
    initial_condition = 1
  []
  [C1]
      family = MONOMIAL
      order = CONSTANT
      fv = true
      initial_from_file_var = C1
  []
  [C2]
      family = MONOMIAL
      order = CONSTANT
      fv = true
      initial_from_file_var = C2
  []
  [C3]
      family = MONOMIAL
      order = CONSTANT
      fv = true
      initial_from_file_var = C3
  []
  [C4]
      family = MONOMIAL
      order = CONSTANT
      fv = true
      initial_from_file_var = C4
  []
  [C5]
      family = MONOMIAL
      order = CONSTANT
      fv = true
      initial_from_file_var = C5
  []
  [C6]
      family = MONOMIAL
      order = CONSTANT
      fv = true
      initial_from_file_var = C6
  []
[]



[AuxVariables]
  [flux]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  initial_from_file_var = flux
  []
  [power]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  initial_from_file_var = flux
  []
[]


[FVBCs]
  [C1_out]
    type = FVConstantScalarOutflowBC
    velocity = '${u} 0 0' 
    variable = C1
    boundary = 'right'
  []
  [C1_in]
    type = FVFunctionDirichletBC
    boundary = 'left'
    function = 'inlet_func_C1'
    variable = C1
  []
  [C2_out]
    type = FVConstantScalarOutflowBC
    velocity = '${u} 0 0' 
    variable = C2
    boundary = 'right'
  []
  [C2_in]
    type = FVFunctionDirichletBC
    boundary = 'left'
    function = 'inlet_func_C2'
    variable = C2
  []
  [C3_out]
    type = FVConstantScalarOutflowBC
    velocity = '${u} 0 0' 
    variable = C3
    boundary = 'right'
  []
  [C3_in]
    type = FVFunctionDirichletBC
    boundary = 'left'
    function = 'inlet_func_C3'
    variable = C3
  []
  [C4_out]
    type = FVConstantScalarOutflowBC
    velocity = '${u} 0 0' 
    variable = C4
    boundary = 'right'
  []
  [C4_in]
    type = FVFunctionDirichletBC
    boundary = 'left'
    function = 'inlet_func_C4'
    variable = C4
  []
  [C5_out]
    type = FVConstantScalarOutflowBC
    velocity = '${u} 0 0' 
    variable = C5
    boundary = 'right'
  []
  [C5_in]
    type = FVFunctionDirichletBC
    boundary = 'left'
    function = 'inlet_func_C5'
    variable = C5
  []
  [C6_out]
    type = FVConstantScalarOutflowBC
    velocity = '${u} 0 0' 
    variable = C6
    boundary = 'right'
  []
  [C6_in]
    type = FVFunctionDirichletBC
    boundary = 'left'
    function = 'inlet_func_C6'
    variable = C6
  []
[]

[Functions]
  [inlet_func_C1]
      type = ParsedFunction
      expression = 'BC_in_C1*exp(-lambda1 * time_out_of_core)'
      symbol_names = 'BC_in_C1 lambda1 time_out_of_core'
      symbol_values = 'BC_in_C1 ${lambda1} ${time_out_of_core}'
  []
  [inlet_func_C2]
      type = ParsedFunction
      expression = 'BC_in_C2*exp(-lambda2 * time_out_of_core)'
      symbol_names = 'BC_in_C2 lambda2 time_out_of_core'
      symbol_values = 'BC_in_C2 ${lambda2} ${time_out_of_core}'
  []
  [inlet_func_C3]
      type = ParsedFunction
      expression = 'BC_in_C3*exp(-lambda3 * time_out_of_core)'
      symbol_names = 'BC_in_C3 lambda3 time_out_of_core'
      symbol_values = 'BC_in_C3 ${lambda3} ${time_out_of_core}'
  []
  [inlet_func_C4]
      type = ParsedFunction
      expression = 'BC_in_C4*exp(-lambda4 * time_out_of_core)'
      symbol_names = 'BC_in_C4 lambda4 time_out_of_core'
      symbol_values = 'BC_in_C4 ${lambda4} ${time_out_of_core}'
  []
  [inlet_func_C5]
      type = ParsedFunction
      expression = 'BC_in_C5*exp(-lambda5 * time_out_of_core)'
      symbol_names = 'BC_in_C5 lambda5 time_out_of_core'
      symbol_values = 'BC_in_C5 ${lambda5} ${time_out_of_core}'
  []
  [inlet_func_C6]
      type = ParsedFunction
      expression = 'BC_in_C6*exp(-lambda6 * time_out_of_core)'
      symbol_names = 'BC_in_C6 lambda6 time_out_of_core'
      symbol_values = 'BC_in_C6 ${lambda6} ${time_out_of_core}'
  []
[]

[ScalarKernels]
  [Dt_Power]
    type = ODETimeDerivative
    variable = power_scalar
  []
  [expression]
    type = ParsedODEKernel
    expression = '-(rho-rho_temp+rho_external-beta)/LAMBDA*power_scalar-A'
    constant_expressions = '${fparse rho} ${rho_external} ${fparse beta} ${fparse LAMBDA}'
    constant_names = 'rho rho_external beta LAMBDA'
    variable = power_scalar
    postprocessors = 'A rho_temp'
  []
[]

[AuxKernels]
    [power_scaling]
        type = ScalarMultiplication
        variable = power
        source_variable = flux
       factor = power_scalar
    []
[]

[FVKernels]
  [C1_time]
    type = FVTimeKernel
    variable = C1
  []
 [C1_interal]
    type = FVCoupledForce
    variable = C1
    coef =   ${fparse -lambda1}
    v = "C1"
  []
  [C1_external]
    type = FVCoupledForce
    variable = C1
    coef = ${fparse beta1/LAMBDA}  
    v = 'power'
  []
  [C1_advection]
    type = FVAdvection
    variable = C1
    velocity = '${u} 0 0'
  []
  [C2_time]
    type = FVTimeKernel
    variable = C2
  []
 [C2_interal]
    type = FVCoupledForce
    variable = C2
    coef =   ${fparse -lambda2}
    v = "C2"
  []
  [C2_external]
    type = FVCoupledForce
    variable = C2
    coef = ${fparse beta2/LAMBDA}  
    v = 'power'
  []
  [C2_advection]
    type = FVAdvection
    variable = C2
    velocity = '${u} 0 0'
  []
  [C3_time]
    type = FVTimeKernel
    variable = C3
  []
 [C3_interal]
    type = FVCoupledForce
    variable = C3
    coef =   ${fparse -lambda3}
    v = "C3"
  []
  [C3_external]
    type = FVCoupledForce
    variable = C3
    coef = ${fparse beta3/LAMBDA}  
    v = 'power'
  []
  [C3_advection]
    type = FVAdvection
    variable = C3
    velocity = '${u} 0 0'
  []
  [C4_time]
    type = FVTimeKernel
    variable = C4
  []
 [C4_interal]
    type = FVCoupledForce
    variable = C4
    coef =   ${fparse -lambda4}
    v = "C4"
  []
  [C4_external]
    type = FVCoupledForce
    variable = C4
    coef = ${fparse beta4/LAMBDA}  
    v = 'power'
  []
  [C4_advection]
    type = FVAdvection
    variable = C4
    velocity = '${u} 0 0'
  []
  [C5_time]
    type = FVTimeKernel
    variable = C5
  []
 [C5_interal]
    type = FVCoupledForce
    variable = C5
    coef =   ${fparse -lambda5}
    v = "C5"
  []
  [C5_external]
    type = FVCoupledForce
    variable = C5
    coef = ${fparse beta5/LAMBDA}  
    v = 'power'
  []
  [C5_advection]
    type = FVAdvection
    variable = C5
    velocity = '${u} 0 0'
  []
  [C6_time]
    type = FVTimeKernel
    variable = C6
  []
 [C6_interal]
    type = FVCoupledForce
    variable = C6
    coef =   ${fparse -lambda6}
    v = "C6"
  []
  [C6_external]
    type = FVCoupledForce
    variable = C6
    coef = ${fparse beta6/LAMBDA}  
    v = 'power'
  []
  [C6_advection]
    type = FVAdvection
    variable = C6
    velocity = '${u} 0 0'
  []
[]


[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 100 
  dt = 1e-1
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-4
  l_max_its = 200
[]

[Outputs]
  exodus = true
[]


[MultiApps]
  [out_of_core]
    type = TransientMultiApp
    input_files = "out_of_core.i"
    execute_on= "timestep_end"
    sub_cycling = true 
  []
  [temp_core]
    type = TransientMultiApp
    input_files = "steady_core_model.i"
    execute_on= "timestep_end"
    sub_cycling = true 
  []
[]


[Transfers]
#######################  
# temp core 
#######################  
  [push_power_scalar]
    type = MultiAppScalarToAuxScalarTransfer 
    to_multi_app = temp_core
    source_variable = power_scalar 
    to_aux_scalar = Power 
    execute_on= "timestep_begin initial"
  []
  [pull_rho_temp]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = temp_core
    from_postprocessor = rho_temp  
    to_postprocessor = rho_temp 
    execute_on= "timestep_begin initial"
    reduction_type = sum
  []
#######################  
# out of core 
#######################  
   [Push_BC_out_C1]
    type = MultiAppPostprocessorTransfer 
    to_multi_app = out_of_core
    from_postprocessor = BC_out_C1
    to_postprocessor = BC_out_C1
    execute_on= 'initial timestep_end'
  [] 
   [Pull_BC_in_C1]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = out_of_core
    from_postprocessor = BC_in_C1
    to_postprocessor = BC_in_C1
    execute_on= 'initial timestep_begin'
    reduction_type = sum
  [] 
   [Push_BC_out_C2]
    type = MultiAppPostprocessorTransfer 
    to_multi_app = out_of_core
    from_postprocessor = BC_out_C2
    to_postprocessor = BC_out_C2
    execute_on= 'initial timestep_end'
  [] 
   [Pull_BC_in_C2]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = out_of_core
    from_postprocessor = BC_in_C2
    to_postprocessor = BC_in_C2
    execute_on= 'initial timestep_begin'
    reduction_type = sum
  [] 
   [Push_BC_out_C3]
    type = MultiAppPostprocessorTransfer 
    to_multi_app = out_of_core
    from_postprocessor = BC_out_C3
    to_postprocessor = BC_out_C3
    execute_on= 'initial timestep_end'
  [] 
   [Pull_BC_in_C3]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = out_of_core
    from_postprocessor = BC_in_C3
    to_postprocessor = BC_in_C3
    execute_on= 'initial timestep_begin'
    reduction_type = sum
  [] 
   [Push_BC_out_C4]
    type = MultiAppPostprocessorTransfer 
    to_multi_app = out_of_core
    from_postprocessor = BC_out_C4
    to_postprocessor = BC_out_C4
    execute_on= 'initial timestep_end'
  [] 
   [Pull_BC_in_C4]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = out_of_core
    from_postprocessor = BC_in_C4
    to_postprocessor = BC_in_C4
    execute_on= 'initial timestep_begin'
    reduction_type = sum
  [] 
   [Push_BC_out_C5]
    type = MultiAppPostprocessorTransfer 
    to_multi_app = out_of_core
    from_postprocessor = BC_out_C5
    to_postprocessor = BC_out_C5
    execute_on= 'initial timestep_end'
  [] 
   [Pull_BC_in_C5]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = out_of_core
    from_postprocessor = BC_in_C5
    to_postprocessor = BC_in_C5
    execute_on= 'initial timestep_begin'
    reduction_type = sum
  [] 
   [Push_BC_out_C6]
    type = MultiAppPostprocessorTransfer 
    to_multi_app = out_of_core
    from_postprocessor = BC_out_C6
    to_postprocessor = BC_out_C6
    execute_on= 'initial timestep_end'
  [] 
   [Pull_BC_in_C6]
    type = MultiAppPostprocessorTransfer 
    from_multi_app = out_of_core
    from_postprocessor = BC_in_C6
    to_postprocessor = BC_in_C6
    execute_on= 'initial timestep_begin'
    reduction_type = sum
  [] 
[]

[Postprocessors]
    [rho_temp]
     type = Receiver 
     default = ${fparse 0}
    []
  [sum_C1]
    type = ElementIntegralVariablePostprocessor
    variable = 'C1'
    execute_on = 'initial timestep_end'
  []
 [B]
     type = ElementL2Norm
     variable = flux
    execute_on = 'initial timestep_begin timestep_end'
    execution_order_group = -1
 []
  [BC_out_C1]
    type = PointValue
    point = '${L} 0 0'
    variable = 'C1'
    execute_on = " initial timestep_end"
  []
  [BC_in_C1]
    type = Receiver
    default = 9.31497730860366
    execute_on = " initial timestep_end"
  []
  [BC_out_C2]
    type = PointValue
    point = '${L} 0 0'
    variable = 'C2'
    execute_on = " initial timestep_end"
  []
  [BC_in_C2]
    type = Receiver
    default = 10.583052387332343
    execute_on = " initial timestep_end"
  []
  [BC_out_C3]
    type = PointValue
    point = '${L} 0 0'
    variable = 'C3'
    execute_on = " initial timestep_end"
  []
  [BC_in_C3]
    type = Receiver
    default = 0.6317326111132855
    execute_on = " initial timestep_end"
  []
  [BC_in_C4]
    type = Receiver
    default = 0.013461430164158171
    execute_on = " initial timestep_end"
  []
  [BC_out_C4]
    type = PointValue
    point = '${L} 0 0'
    variable = 'C4'
    execute_on = " initial timestep_end"
  []
  [BC_in_C5]
    type = Receiver
    default = 4.097656598160685e-06
    execute_on = " initial timestep_end"
  []
  [BC_out_C5]
    type = PointValue
    point = '${L} 0 0'
    variable = 'C5'
    execute_on = " initial timestep_end"
  []
  [BC_in_C6]
    type = Receiver
    default = 2.8659337791317837e-06
    execute_on = " initial timestep_end"
  []
  [BC_out_C6]
    type = PointValue
    point = '${L} 0 0'
    variable = 'C6'
    execute_on = " initial timestep_end"
  []
 [A1]
     type = WeightDNPPostprocessor
     variable = flux
     other_variable = C1
     Norm = B
     lambda = ${lambda1}
    execute_on = 'initial timestep_end'
 []
 [A2]
     type = WeightDNPPostprocessor
     variable = flux
     other_variable = C2
     Norm = B
     lambda = ${lambda2}
    execute_on = 'initial timestep_end'
 []
 [A3]
     type = WeightDNPPostprocessor
     variable = flux
     other_variable = C3
     Norm = B
     lambda = ${lambda3}
    execute_on = 'initial timestep_end'
 []
 [A4]
     type = WeightDNPPostprocessor
     variable = flux
     other_variable = C4
     Norm = B
     lambda = ${lambda4}
    execute_on = 'initial timestep_end'
 []
 [A5]
     type = WeightDNPPostprocessor
     variable = flux
     other_variable = C5
     Norm = B
     lambda = ${lambda5}
    execute_on = 'initial timestep_end'
 []
 [A6]
     type = WeightDNPPostprocessor
     variable = flux
     other_variable = C6
     Norm = B
     lambda = ${lambda6}
    execute_on = 'initial timestep_end'
 []
 [A]
 type = ParsedPostprocessor
  function = 'A1+A2+A3+A4+A5+A6'
  pp_names = 'A1 A2 A3 A4 A5 A6'
  execute_on = 'initial timestep_end '
[]
 [Calc_rho]
  type = ParsedPostprocessor
  function = '-A*LAMBDA+beta'
  pp_names = 'A'
  constant_names =  'LAMBDA beta'
  constant_expressions ='${LAMBDA} ${beta}'
 []
[]
