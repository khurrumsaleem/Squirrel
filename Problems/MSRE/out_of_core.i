dt = 1e-2
time_out_of_core = 16.74
number_of_timesteps = ${fparse time_out_of_core/dt}

[Mesh]
    file = initial_out_of_core.e
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
  [C1]
      initial_from_file_var = C1
  []
  [C2]
      initial_from_file_var = C2
  []
  [C3]
      initial_from_file_var = C3
  []
  [C4]
      initial_from_file_var = C4
  []
  [C5]
      initial_from_file_var = C5
  []
  [C6]
      initial_from_file_var = C6
  []
[]


[AuxKernels]
    [move_C1]
        type = out_of_core
        variable = C1
        precursors_concentration = C1
        C_in = BC_out_C1 
    []
    [move_C2]
        type = out_of_core
        variable = C2
        precursors_concentration = C2
        C_in = BC_out_C2 
    []
    [move_C3]
        type = out_of_core
        variable = C3
        precursors_concentration = C3
        C_in = BC_out_C3 
    []
    [move_C4]
        type = out_of_core
        variable = C4
        precursors_concentration = C4
        C_in = BC_out_C4 
    []
    [move_C5]
        type = out_of_core
        variable = C5
        precursors_concentration = C5
        C_in = BC_out_C5 
    []
    [move_C6]
        type = out_of_core
        variable = C6
        precursors_concentration = C6
        C_in = BC_out_C6 
    []
[]

[Executioner]
  type = Transient
  dt = ${dt}
  solve_type = 'NEWTON'
[]


[Outputs]
  exodus = true
[]

[Postprocessors]
  [C1_sum]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial timestep_end'
    variable = C1 
  []
  # here in and out referes to the core
  [BC_out_C1]
    type = Receiver
    default =0 
  []
  [BC_in_C1]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'C1'
    execute_on = "initial timestep_end"
  []
  [C2_sum]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial timestep_end'
    variable = C2 
  []
  [BC_out_C2]
    type = Receiver
    default =0 
  []
  [BC_in_C2]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'C2'
    execute_on = "initial timestep_end"
  []
  [C3_sum]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial timestep_end'
    variable = C3 
  []
  [BC_out_C3]
    type = Receiver
    default = 0 
  []
  [BC_in_C3]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'C3'
    execute_on = "initial timestep_end"
  []
  [C4_sum]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial timestep_end'
    variable = C4 
  []
  [BC_out_C4]
    type = Receiver
    default = 0
  []
  [BC_in_C4]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'C4'
    execute_on = "initial timestep_end"
  []
  [C5_sum]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial timestep_end'
    variable = C5 
  []
  [BC_out_C5]
    type = Receiver
    default = 0
  []
  [BC_in_C5]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'C5'
    execute_on = "initial timestep_end"
  []
  [C6_sum]
    type = ElementIntegralVariablePostprocessor
    execute_on = 'initial timestep_end'
    variable = C6 
  []
  [BC_out_C6]
    type = Receiver
    default = 0 
  []
  [BC_in_C6]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'C6'
    execute_on = "initial timestep_end"
  []
[]
