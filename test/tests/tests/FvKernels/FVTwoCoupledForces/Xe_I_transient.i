gamma_I  = 0.4 #fission yield
lambda_I = 1 #decay constant

lambda_Xe = 2 # decay_constant
sigma_Xe = 0.5 #mic absorbtion crossection Xe

Sigma_f = 3 # Macros_fiss 

#Analytical solution N_I = 1.2 N_Xe = 0.57142857 

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = 10 
  []
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS, BOUNDARY CONDITIONS
################################################################################
[AuxVariables]
  [flux]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    initial_condition = 0
  []
[]

[Variables]
  [I]
    type = MooseVariableFVReal
    initial_condition = 1.2
  []
  [Xe]
    type = MooseVariableFVReal
    initial_condition = 0.48
  []
[]

[FVKernels]
  [I_time]
    type = FVTimeKernel
    variable = I
  []
  [I_decay]
    type = FVCoupledForce
    variable = I
    coef =   ${fparse -lambda_I}
    v = "I"
  []
  [I_prod]
    type = FVCoupledForce
    variable = I
    coef = ${fparse gamma_I*Sigma_f}  
    v = 'flux'
  []

  [Xe_time]
    type = FVTimeKernel
    variable = Xe
  []
  [Xe_burn]
    type = FVTwoCoupledForces
    variable = Xe
    coef =   ${fparse -sigma_Xe}
    v = "flux"
    u = "Xe"
  []
  [Xe_decay]
    type = FVCoupledForce
    variable = Xe
    coef =   ${fparse -lambda_Xe}
    v = "Xe"
  []
  [Xe_prod]
    type = FVCoupledForce
    variable = Xe
    coef = ${fparse lambda_I}  
    v = 'I'
  []
[]


################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Transient

  # Time stepping parameters
  # The time step is imposed by the neutronics app
  start_time = 0.0
  #end_time = ${fparse 60*60*75}
  end_time = 10
  dt = ${fparse 1e-2}

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'lu NONZERO 50'
  line_search = 'none'

  # Time integration scheme
  scheme = 'implicit-euler'

  nl_rel_tol = 1e-9
  automatic_scaling = true
[]


[Outputs]
  exodus = true
[]


[Postprocessors]
################################################################################
#weights 
################################################################################
  [total_I]
    type = ElementIntegralVariablePostprocessor
    variable = I
    execute_on = timestep_end
  []
  [total_Xe]
    type = ElementIntegralVariablePostprocessor
    variable = Xe
    execute_on = timestep_end
  []
  [total_flux]
    type = ElementIntegralVariablePostprocessor
    variable = flux 
    execute_on = timestep_end
  []
[]
