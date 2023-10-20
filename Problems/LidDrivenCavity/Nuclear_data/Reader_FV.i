#set mesh
[Mesh]
  type = GeneratedMesh
  allow_renumbering = false
  dim = 2
  xmin = 0
  xmax = 2
  ymin = 0
  ymax = 2
  nx = 20 
  ny = 20
[]

[Problem]
kernel_coverage_check=false
[]
# PK
[Variables]
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
  [C_tot]
    type = INSFVScalarFieldVariable
  []
  [power]
    type = INSFVScalarFieldVariable
  []
  [P]
    type = INSFVScalarFieldVariable
  []
  [psi]
    type = INSFVScalarFieldVariable
  []
  [Delta_rho]
    type = INSFVScalarFieldVariable
  []
[]



[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
[]

[MultiApps]
  [Reader]
    type = FullSolveMultiApp
    input_files = "Reader.i"
    execute_on= INITIAL
  []
[]

[Transfers]
   [pull_Power_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = power
    variable = power
    execute_on= INITIAL
  [] 
   [pull_P_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = P
    variable = P
    execute_on= INITIAL
  [] 
   [pull_Psi_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = psi
    variable = psi
    execute_on= INITIAL
  [] 
  [pull_C1_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C1
    variable = C1
    execute_on = INITIAL
  [] 
  [pull_C2_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C2
    variable = C2
    execute_on = INITIAL
  [] 
  [pull_C3_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C3
    variable = C3
    execute_on = INITIAL
  [] 
  [pull_C4_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C4
    variable = C4
    execute_on = INITIAL
  [] 
  [pull_C5_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C5
    variable = C5
    execute_on = INITIAL
  [] 
  [pull_C6_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C6
    variable = C6
    execute_on = INITIAL
  [] 
  [pull_C7_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C7
    variable = C7
    execute_on = INITIAL
  [] 
  [pull_C8_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C8
    variable = C8
    execute_on = INITIAL
  [] 
  [pull_C_tot_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C_tot
    variable = C_tot
    execute_on = INITIAL
  [] 
  [pull_Delta_rho_tot_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = Delta_rho 
    variable = Delta_rho
    execute_on = INITIAL
  [] 
[]

[Postprocessors]
  [power_int_begin]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = power
  []
  [C_int_end]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'INITIAL timestep_end'
    variable = C1
  []
[]
