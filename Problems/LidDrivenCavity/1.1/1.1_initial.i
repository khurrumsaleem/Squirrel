
LAMBDA = 9.82015e-07

beta = 0.006882528
lambda1 = 0.0124667
lambda2 = 0.0282917
lambda3 = 0.0425244
lambda4 = 0.133042
lambda5 = 0.292467
lambda6 = 0.666488
lambda7 = 1.63478
lambda8 = 3.5546

[Problem]
    kernel_coverage_check=false
[]

dy = 20

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2.0
    ymin = 0
    ymax = 2.0
    nx = ${dy}
    ny = ${dy}
  []
[]


[Variables]
  [u]
    type = INSFVVelocityVariable
  []
  [v]
    type = INSFVVelocityVariable
  []
  [pressure]
    type = INSFVPressureVariable
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
  [T]
    type = INSFVEnergyVariable
    #scaling = 1e-4
  []
  [C1]
    type = INSFVScalarFieldVariable
  []
  [C2]
    type = INSFVScalarFieldVariable
  []
  [C3]
    type = INSFVScalarFieldVariable
  []
  [C4]
    type = INSFVScalarFieldVariable
  []
  [C5]
    type = INSFVScalarFieldVariable
  []
  [C6]
    type = INSFVScalarFieldVariable
  []
  [C7]
    type = INSFVScalarFieldVariable
  []
  [C8]
    type = INSFVScalarFieldVariable
  []
[]


[AuxVariables]
  [power]
    order = CONSTANT
    family = MONOMIAL
    fv = true
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
  [C1_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'timestep_end INITIAL'
    variable = C1
  []
 [B]
     type = ElementL2Norm
     variable = power
    execute_on = 'initial timestep_begin'
    execution_order_group = -1
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

[MultiApps]
  [Reader]
    type = FullSolveMultiApp
    input_files = "../Nuclear_data/Reader.i"
    execute_on= INITIAL
  []
[]


[Transfers]
   [pull_Power_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = flux
    variable = power
    execute_on= INITIAL
  [] 
  [pull_C1_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C1
    variable = C1
    execute_on = INITIAL
  [] 
  [pull_C2_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C2
    variable = C2
    execute_on = INITIAL
  [] 
  [pull_C3_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C3
    variable = C3
    execute_on = INITIAL
  [] 
  [pull_C4_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C4
    variable = C4
    execute_on = INITIAL
  [] 
  [pull_C5_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C5
    variable = C5
    execute_on = INITIAL
  [] 
  [pull_C6_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C6
    variable = C6
    execute_on = INITIAL
  [] 
  [pull_C7_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C7
    variable = C7
    execute_on = INITIAL
  [] 
  [pull_C8_inital]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C8
    variable = C8
    execute_on = INITIAL
  [] 
[]

