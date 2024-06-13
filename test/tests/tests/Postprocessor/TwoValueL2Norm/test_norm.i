#set mesh
[Mesh]
  type = GeneratedMesh
  allow_renumbering = false
  dim = 1
  xmin = 0
  xmax = 1
  nx = 10 
[]


[Variables]
    [Dummy]
    []
[]
# PK
[AuxVariables]
  [a]
  []
  [b]
  []
[]

[ICs]
  [Initial_a]
    type = FunctionIC
    variable = 'a'
    function =  a_func
  []
  [Initial_b]
    type = FunctionIC
    variable = 'b'
    function =  b_func
  []
[]

[Functions]
  [a_func]
    type = ParsedFunction
    expression = 'sin(x)'
  []
  [b_func]
    type = ParsedFunction
    expression = 'x'
  []
[]

[Kernels]
 [Dummy]
    type = NullKernel
    variable = Dummy
 []
[]


[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  exodus = true
[]

[Postprocessors]
  [Test_norm]
    type = TwoValuesL2Norm
    execute_on = 'INITIAL TIMESTEP_END'
    variable = a
    other_variable = b
  []
[]
