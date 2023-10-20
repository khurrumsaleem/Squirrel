[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2.0
    ymin = 0
    ymax = 2.0
    nx = 19
    ny = 19
  []
[]

[Variables]
  [C]
  []
[]


[AuxVariables]
  [flux]
  []
  [T]
    initial_condition = 1
  []
  [T_ref]
    initial_condition = 0
  []
[]

[Kernels]
  [C_time]
    type = NullKernel
    variable = C
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
  [outfile]
    type = CSV
    delimiter = ' '
  []
[]


[MultiApps]
  [Reader]
    type = FullSolveMultiApp
    input_files = "Reader.i"
    execute_on= INITIAL
  []
[]


[Transfers]
   [pull_flux_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = power_scaled
    variable = flux
    execute_on= INITIAL
  [] 
  [pull_C_tot_inital]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = Reader 
    source_variable = C_tot
    variable = C
    execute_on = INITIAL
  [] 
[]

[Postprocessors]
  [power_int]
    #type = ElementExtremeValue
    type = ElementIntegralVariablePostprocessor
    #type = NodalSum
    execute_on = 'initial timestep_end'
    variable = flux
  []
  [Temp_feedback]
      type = TemperatureFeedback
      variable = T
      flux = flux
      T_ref = T_ref
      total_rho = -4
  []
 [Flux_sum]
     type = NodalSum 
     variable = flux
 []
[]
