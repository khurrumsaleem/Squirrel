## this solves the 0D problem of temperature feedback in the MSRE
dt = 1e-2
time_out_of_core = 16.74
number_of_timesteps = ${fparse time_out_of_core/dt}

[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = ${fparse number_of_timesteps}
  nx = 1673 #${fparse number_of_timesteps-1}
[]

#alpha_f = -8.71e-5 # rho/K
#alpha_g = -6.66e-5 # rho/K

alpha_f    = -11.034e-5 # rho/K
alpha_g    = -05.814e-5 # rho/K

tau_c  = 8.46

Wf = 1.623879934566580e+02 #flow
mf_total = ${fparse Wf*tau_c}

nn_f = 2 #number of fuel nodes in core model
mf  = ${fparse ${mf_total}/nn_f} #fuel mass per node (kg)
Cpf = 1.9665e-3 #specific heat capacity of fuel salt (MJ/kg-C) ORNL-TM-0728 p.8

v_g      = 1.95386# graphite volume(m^3) ORNL-TM-0728 p. 101
rho_g    = 1.860e3# graphite density (kg/m^3) ORNL-3812 p.77, ORNL-TM-0728 p.87
mg      = ${fparse v_g*rho_g} #graphite mass (kg)
Cpg    = 1.773e-3 # cp_g/m_g; % graphite specific heat capacity (MW-s/kg-C) ORNL-TM-1647 p.3
hAfg    = ${fparse 0.02*9/5} # (fuel to graphite heat transfer coeff x heat transfer area) (MW/°C) ORNL-TM-1647 p.3, TDAMSRE p.5
Kg1      = 0.5  #fraction of heat transferred from graphite which goes to first fuel lump
Kg2      = 0.5  #fraction of heat transferred from graphite which goes to second fuel lump
k_f      = 0.93 #  % fraction of heat generated in fuel - that generated in external loop ORNL-TM-0728 p.9
K1     = ${fparse k_f/nn_f} # fraction of total power generated in lump f1
K2     = ${fparse k_f/nn_f} # fraction of total power generated in lump f2


#initial
#Tf_in  = 6.3222e2
T0_f2  = 6.555227e2
T0_f1  = 6.441907e2 
T0_g1  = 6.498938e2

p = 8
[Variables]
  [Tf1]
    family = SCALAR
    order = FIRST
    initial_condition = ${ T0_f1} 
  []
  [Tf2]
    family = SCALAR
    order = FIRST
    initial_condition =  ${ T0_f2}
  []
  [Tg]
    family = SCALAR
    order = FIRST
    initial_condition =  ${ T0_g1}
  []
[]

[ScalarKernels]
  [Dt_TF1]
    type = ODETimeDerivative
    variable = Tf1
  []
  [expression_TF1]
    type = ParsedODEKernel
    expression = '-(Wf/mf * ( ppTf_in-Tf1) + K1*Power*p/(mf*Cpf)+ (Kg1/(Kg1+Kg2))*(hAfg/(mf*Cpf))*(Tg-Tf1))'

    constant_names = 'p Wf K1 mf Cpf Kg1 Kg2 hAfg'
    constant_expressions = '${p} ${Wf} ${K1} ${mf} ${Cpf} ${Kg1} ${Kg2} ${hAfg}'
    variable = Tf1
    coupled_variables = "Power Tg"
    postprocessors = ppTf_in 
  []
  [Dt_TF2]
    type = ODETimeDerivative
    variable = Tf2
  []
  [expression_TF2]
    type = ParsedODEKernel
    expression = '-(Wf/mf * (Tf1 -Tf2) + K2*Power*p/(mf*Cpf)+ (Kg2/(Kg1+Kg2))*(hAfg/(mf*Cpf))*(Tg-Tf2))'
    constant_names = 'p Wf mf K2 Cpf Kg1 Kg2 hAfg'
    constant_expressions = '${p} ${Wf} ${mf} ${K2} ${Cpf} ${Kg1} ${Kg2} ${hAfg}'
    variable = Tf2
    coupled_variables = "Power Tg Tf1"
  []
  [Dt_Tg]
    type = ODETimeDerivative
    variable = Tg
  []
  [expression_Tg]
    type = ParsedODEKernel
    expression = '-((Kg1+Kg2)*Power*p/(mg*Cpg)*(hAfg/(mg*Cpg))*((Tf1+Tf2)/2-Tg))'
    constant_names = 'p Kg1 Kg2 mg Cpg hAfg '
    constant_expressions = '${p} ${Kg1} ${Kg2} ${mg} ${Cpg} ${hAfg}'
    variable = Tg
    coupled_variables = "Power Tf1 Tf2"
  []
[]

[AuxVariables]
    [T_out]
        initial_condition = ${T0_f2} 
    []
  [Power]
    family = SCALAR
    order = FIRST
    initial_condition = 1
  []
[]

[AuxKernels]
    [move_T]
        type = out_of_core
        variable = T_out
        precursors_concentration = T_out
        C_in = ppTf2 
    []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  dt = ${dt}
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
    [Tf_out_side]
    type = PointValue
    point = '${number_of_timesteps} 0 0'
    variable = 'T_out'
    execute_on = "initial timestep_end"
    []
    [ppTf_in]
        type = ParsedPostprocessor
        function = '(Tf_out_side - 23.3027)'  
        pp_names = 'Tf_out_side'
    execute_on = "initial timestep_end"
    []
    [ppTf1]
      type = ScalarVariable
      variable = Tf1
      execute_on = 'initial timestep_end'
    []
    [ppTf2]
      type = ScalarVariable
      variable = Tf2
      execute_on = 'initial timestep_end'
    []
    [ppTg]
      type = ScalarVariable
      variable = Tg
      execute_on = 'initial timestep_end'
    []
    [rho_temp]
        type = ParsedPostprocessor
        function = 'alpha_f/2*(T0_f1-ppTf1)+alpha_f/2*(T0_f2-ppTf2)+alpha_g*(T0_g1-ppTg)' 
        pp_names = 'ppTf1 ppTf2 ppTg'
        constant_names = 'T0_f1 T0_f2 T0_g1 alpha_f alpha_g'
        constant_expressions = '${T0_f1} ${T0_f2} ${T0_g1} ${alpha_f} ${alpha_g}'
      execute_on = 'initial timestep_end'
    []
[]
