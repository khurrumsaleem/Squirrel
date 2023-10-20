
 number_of_timesteps = 10
[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1
  nx = ${fparse number_of_timesteps-1}
[]

[Variables]
    [Dummy]
    []
[]

[Kernels]
    [dummy]
        type = NullKernel
        variable = Dummy
    []
[]

[AuxVariables]
    [C]
    []
[]


[AuxKernels]
    [move]
        type = out_of_core
        variable = C
        precursors_concentration = C
        C_in = C_in 
    []

[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  num_steps = 22
  dt  = 1e-2
[]


[Outputs]
  exodus = true
[]

[Postprocessors]
  [C_sum]
    type = NodalSum
    execute_on = 'initial timestep_end'
    variable = C 
  []
  [C_in]
    type = ConstantPostprocessor
    value = 10
  []
[]
