rho = 2000 #density
cp = 3075 #specific_heat
k = 0 #thermal_conductivity
mu = 50 
alpha = ${fparse 2.0 1e-4}
viscosity = ${fparse 2.5e-2}
Schmidt = ${fparse 2e8}

gamma = ${fparse 1e6}
Tref = 900


velocity_interp_method = 'rc'
#advected_interp_method = 'average'
advected_interp_method = 'upwind'

LAMBDA = 9.82015e-07

beta = 0.006882528
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


dy = 75

[Mesh]
  file = 1.1_initial_out.e 
[]

[GlobalParams]
  rhie_chow_user_object = 'rc'
  gravity       = '0 0 0'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = u
    v = v
    pressure = pressure
  []
[]

[Variables]
  [u]
    type = INSFVVelocityVariable
     initial_from_file_var = u
  []
  [v]
    type = INSFVVelocityVariable
     initial_from_file_var = v
  []
  [C1]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C1
  []
  [C2]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C2
  []
  [C3]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C3
  []
  [C4]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C4
  []
  [C5]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C5
  []
  [C6]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C6
  []
  [C7]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C7
  []
  [C8]
    type = INSFVScalarFieldVariable
     initial_from_file_var = C8
  []
  [pressure]
    type = INSFVPressureVariable
     initial_from_file_var = pressure
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
  [T]
    type = INSFVEnergyVariable
     initial_from_file_var = T 
  []
[]


[AuxVariables]
  [power]
    order = CONSTANT
    family = MONOMIAL
    fv = true
     initial_from_file_var = power 
  []
[]


[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
  []
  [mean_zero_pressure]
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = lambda
  []

  [u_advection]
    type = INSFVMomentumAdvection
    variable = u
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
[]
[u_viscosity]
    type = INSFVMomentumDiffusion
    variable = u
    mu = ${mu}
    momentum_component = 'x'
  []

  [u_pressure]
    type = INSFVMomentumPressure
    variable = u
    momentum_component = 'x'
    pressure = pressure
  []
  [u_buoyancy]
    type = INSFVMomentumBoussinesq
    T_fluid = T
    variable = u
    rho = ${rho}
    ref_temperature = ${Tref}
    momentum_component = 'x'
  []
  [u_gravity]
    type = INSFVMomentumGravity
    variable = u
    momentum_component = 'x'
    rho = ${rho}
  []

  [v_advection]
    type = INSFVMomentumAdvection
    variable = v
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_viscosity]
    type = INSFVMomentumDiffusion
    variable = v
    mu = ${mu}
    momentum_component = 'y'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v
    momentum_component = 'y'
    pressure = pressure
  []
  [v_buoyancy]
    type = INSFVMomentumBoussinesq
    T_fluid = T
    variable = v
    rho = ${rho}
    ref_temperature = ${Tref}
    momentum_component = 'y'
  []
  [v_gravity]
    type = INSFVMomentumGravity
    variable = v
    momentum_component = 'y'
    rho = ${rho}
  []

  [temp_advection]
    type = INSFVEnergyAdvection
    variable = T
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [temp_source]
    type = FVCoupledForce
    variable = T
    v = power
    coef = ${fparse 1e9}
  []
  [temp_heat_sink1]
    type = FVCoupledForce
    variable = T
    v = 'T'
    coef = ${fparse -gamma}
  []
  [temp_heat_sink2]
    type = FVCoupledForce
    variable = T
    v = ${fparse Tref}
    coef = ${fparse gamma}
  []

  [C1_advection]
    type = INSFVScalarFieldAdvection
    variable = C1
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C1_diffusion]
    type = FVDiffusion
    variable = C1
    coeff = Difusion_coeff
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

  [C2_advection]
    type = INSFVScalarFieldAdvection
    variable = C2
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C2_diffusion]
    type = FVDiffusion
    variable = C2
    coeff = Difusion_coeff
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

  [C3_advection]
    type = INSFVScalarFieldAdvection
    variable = C3
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C3_diffusion]
    type = FVDiffusion
    variable = C3
    coeff = Difusion_coeff
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

  [C4_advection]
    type = INSFVScalarFieldAdvection
    variable = C4
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C4_diffusion]
    type = FVDiffusion
    variable = C4
    coeff = Difusion_coeff
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
  
  [C5_advection]
    type = INSFVScalarFieldAdvection
    variable = C5
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C5_diffusion]
    type = FVDiffusion
    variable = C5
    coeff = Difusion_coeff
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

  [C6_advection]
    type = INSFVScalarFieldAdvection
    variable = C6
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C6_diffusion]
    type = FVDiffusion
    variable = C6
    coeff = Difusion_coeff
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

  [C7_advection]
    type = INSFVScalarFieldAdvection
    variable = C7
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C7_diffusion]
    type = FVDiffusion
    variable = C7
    coeff = Difusion_coeff
  []
 [C7_interal]
    type = FVCoupledForce
    variable = C7
    coef =   ${fparse -lambda7}
    v = "C7"
  []
  [C7_external]
    type = FVCoupledForce
    variable = C7
    coef = ${fparse beta7/LAMBDA}  
    v = 'power'
  []

  [C8_advection]
    type = INSFVScalarFieldAdvection
    variable = C8
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [C8_diffusion]
    type = FVDiffusion
    variable = C8
    coeff = Difusion_coeff
  []
 [C8_interal]
    type = FVCoupledForce
    variable = C8
    coef =   ${fparse -lambda8}
    v = "C8"
  []
  [C8_external]
    type = FVCoupledForce
    variable = C8
    coef = ${fparse beta8/LAMBDA}  
    v = 'power'
  []
[]

[FVBCs]
  [top_x]
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'top'
    function = 'lid_function'
  []

  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'left right bottom'
    function = 0
  []

  [no_slip_y]
    type = INSFVNoSlipWallBC
    variable = v
    boundary = 'left right top bottom'
    function = 0
  []
[]

[Functions]
  [lid_function]
    type = ParsedFunction
    value = '0.5'
  []
[]

[Materials]
  [const_functor]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha_b cp k'
    prop_values = '${alpha} ${cp} ${k}'
  []
  [ins_fv]
    type = INSFVEnthalpyMaterial
    temperature = 'T'
    rho = ${rho}
  []
  [diffusion_constant]
    type = ADGenericFunctorMaterial
    prop_names = 'Difusion_coeff'
    prop_values = ${fparse viscosity/Schmidt}
  []
[]


[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type  -pc_factor_shift_type'
  petsc_options_value = 'lu      NONZERO'
[]

[Outputs]
  exodus = true
  [outfile]
    type = CSV
    delimiter = ' '
    file_base = 'data/'
  []
[]

[Postprocessors]
 [B]
     type = ElementL2Norm
     variable = power
    execute_on = 'initial timestep_begin'
    execution_order_group = -1
 []
  [C1_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'timestep_end INITIAL'
    variable = C1
  []
 [A1]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C1
     Norm = B
     lambda = ${lambda1}
    execute_on = 'initial timestep_end '
 []
 [A2]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C2
     Norm = B
     lambda = ${lambda2}
    execute_on = 'initial timestep_end '
 []
 [A3]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C3
     Norm = B
     lambda = ${lambda3}
    execute_on = 'initial timestep_end '
 []
 [A4]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C4
     Norm = B
     lambda = ${lambda4}
    execute_on = 'initial timestep_end '
 []
 [A5]
     type = WeightDNPPostprocessor
     variable = power
    other_variable = C5
     Norm = B
     lambda = ${lambda5}
    execute_on = 'initial timestep_end '
 []
 [A6]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C6
     Norm = B
     lambda = ${lambda6}
    execute_on = 'initial timestep_end '
 []
 [A7]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C7
     Norm = B
     lambda = ${lambda7}
    execute_on = 'initial timestep_end '
 []
 [A8]
     type = WeightDNPPostprocessor
     variable = power
     other_variable = C8
     Norm = B
     lambda = ${lambda8}
    execute_on = 'initial timestep_end '
 []
 [A]
 type = ParsedPostprocessor
  function = 'A1+A2+A3+A4+A5+A6+A7+A8'
  pp_names = 'A1 A2 A3 A4 A5 A6 A7 A8'
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


[VectorPostprocessors]
  [MOOSE_T_AA]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    num_points = ${dy} 
    variable = 'T'
    sort_by = id
  []
  [MOOSE_uy_AA]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    num_points = ${dy} 
    variable = 'v'
    sort_by = id
  []
  [y1]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    num_points = ${dy} 
    variable = 'C1'
    sort_by = id
  []
  [y2]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    num_points = ${dy} 
    variable = 'C2'
    sort_by = id
  []
  [y3]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    num_points = ${dy} 
    variable = 'C3'
    sort_by = id
  []
  [y4]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    num_points = ${dy} 
    variable = 'C4'
    sort_by = id
  []
  [y5]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'C5'
    num_points = ${dy} 
    sort_by = id
  []
  [y6]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'C6'
    num_points = ${dy} 
    sort_by = id
  []
  [y7]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'C7'
    num_points = ${dy} 
    sort_by = id
  []
  [y8]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'C8'
    num_points = ${dy} 
    sort_by = id
  []
[]
