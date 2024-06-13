#set mesh
[Mesh]
  allow_renumbering = false
  type = GeneratedMesh
  dim = 2 
  xmin = 0 
  xmax = 1
  nx = 2
  ymin = 0
  ymax = 1
  ny = 2
[]

# PK
[AuxVariables]
  [a]
    initial_condition = 1
  []
  [b]
    initial_condition = 10
  []
[]

[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
    initial_condition = 10
  []
[]


[ScalarKernels]
  [Dt]
    type = ODETimeDerivative
    variable = power_scalar
  []
[]

[AuxKernels]
    [scalar_multiplication]
       type = ScalarMultiplicationPP
       variable = b
       source_variable = a
       factor = factor 
    []
[]

[Executioner]
  type = Transient
  start_time = 0
  dt = 1 
  num_steps = 2 
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
[]

[Postprocessors]
  [power_int]
    type = NodalExtremeValue
    execute_on = 'initial timestep_end'
    variable = b
  []
  [factor]
    type = ConstantPostprocessor
    execute_on = 'initial timestep_end'
    value = 2
  []
[]
