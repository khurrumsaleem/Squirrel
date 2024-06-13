rho_external = ${fparse 1.08e-03 }
LAMBDA = 9.82015e-07
beta_sum = 0.006882528

[Problem]
allow_initial_conditions_with_restart = true
[]

[Mesh]
  file =Feedback_steady_out.e 
[]

[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
    initial_condition = 1
  []
[]

[ScalarKernels]
  [Dt]
    type = ODETimeDerivative
    variable = power_scalar
  []
  [expression]
    type = ParsedODEKernel
    expression = '-(rho_external+rho_temp-beta_sum)/LAMBDA*power_scalar-A'
    constant_expressions = '${fparse rho_external} ${fparse beta_sum} ${fparse LAMBDA}'
    constant_names = 'rho_external beta_sum LAMBDA'
    variable = power_scalar
    postprocessors = 'rho_temp A'
  []
[]


[AuxVariables]
  [psi]
    initial_from_file_var = psi
  []
  [T]
    initial_from_file_var = T
  []
  [T_ref]
    initial_from_file_var = T
  []
[]


[Executioner]
  type = Transient
  solve_type = 'PJFNK'
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


[Postprocessors]
  [rho_temp]
      type = TemperatureFeedback
      variable = T
      flux = psi
      T_ref = T_ref
      total_rho = ${fparse -3.8*1e-5}
  []
 [A]
     type = Receiver 
    default = ${fparse 5.782321e+03}
 []
 [psi_sum]
     type = NodalSum 
     variable = psi
 []
  [total_psi]
    type = ElementIntegralVariablePostprocessor
    variable =psi 
  []
 [T_ref_sum]
     type = NodalSum 
     variable = T_ref
    execute_on= "INITIAL timestep_end"
 []
 [T_sum]
     type = NodalSum 
     variable = T
    execute_on= "INITIAL timestep_end"
 []
[]
