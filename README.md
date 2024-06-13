Squirrel
=====

"Fork squirrel" to create a new MOOSE-based application. 

This application is intended as a light weight and flexible implementation of the PK equation with the ability to capture the change in reactivity caused by the DNP movement and changes in temperature.
# DNP movement 
A good derivation of this can be found in Chapter two of Mathematical-Methods-in-Nuclear-Reactor-Dynamics.
For a given power 
$$ 
P (x,t) = P(t) |\psi(x)\rangle 
$$
with $|P(x)\rangle$ being the L2 normalized flux $\Phi$: 

$$
 |\psi(x) \rangle = \frac{\Phi_0}{\int_{x} dx \Phi_0}
$$


The squirrel app solves the PK by weighting the DNP $C$ concentration. This is derived in [[Derivation]]  [[Derivation old]]
$$ 
\dot P(t) = \frac{\rho-\beta}{\Lambda} P(t) + \sum_I \lambda_I \frac{\langle \psi(x) |C_I(x)\rangle}{\langle \psi(x)| \psi(x)\rangle}
$$ 
with 
$$ 
\langle \psi|\phi\rangle = \int dx \psi^* \phi   
$$ 
and for the DNPs: 
$$ 
|\dot C_I(x) \rangle = \frac{\beta_I}{\Lambda}P(t)|\psi(x) \rangle - \lambda_I |C_i(x) \rangle + U \nabla C_I(x)
$$

we are imposing steady state initial conditions so that $|\dot C_I(x) \rangle = \dot P(t) = 0$
with that we get for $t = 0$
$$ 
|C_I(x) \rangle = \frac{\beta_I}{\Lambda \lambda_I}|\psi(x) \rangle 
$$
# Temperature feedback

For a given temperature field $T$ we can calculate the difference at each point $i$ from the steady state Temperature $T_{ref}$ .

$$ \delta T_i = T_i - T_{ref, i}  $$

We can now calculate the change in $\rho_{temp}$ introduced by a temperature change:

$$ 
\rho_{temp} = \langle \psi |\delta T \rangle \Gamma_{pcm/K}.
$$

with $\Gamma$ being the reactivity change in reactivity caused by a global increase by $1$ Kelvin and $\int dr \psi(r) = 1$

## Doppler and Density
It is possible that the reactivity change depends on the temperature $\Gamma(T)$. 
According to https://www.researchgate.net/publication/361864499 the Doppler effect follows a $\log(T)$ relation, while the Density feedback follows a linear relation.

In addition, the importance function is different.  
The Doppler follows $\psi^* \psi = \psi^2$ while the density feedback follows $\psi$


# Implementation 

## AuxKernel 

The ScalarMultiplication AuxKernel implements the multiplication of a scalar variable  with a variable. 
$$ P(t) |P(x)\rangle  $$
The ScalarMultiplicationPP AuxKernel does the same for a postprocessor

## Postprocessor
### WeightDNPPostprocessor
implements the
$$
A_I = \lambda_I \frac{\langle \psi|C_I\rangle}{\text{Norm}}
$$
for the $I$th group.
### TemperatureFeedback
postprocessor implements
$$
\rho = \sum_i \frac{\psi_i}{\Delta T} \delta T_i
$$

### TemperatureFeedbackInt
postprocessor implements

$$
\rho =  \frac{\langle \psi|\delta T \rangle}{\Delta T} 
$$

### TempDoppler
Implements 

$$
\rho =  \langle \psi^* \psi|
 (T_i - T_{ref, i}) \Gamma(T_i) 
 \rangle 
$$

with $\Gamma(T_i) = a\log(bT_i+c) + d$ . $a$, $b$, $c$ and $d$ are appropriate fit parameters.


### TempDensity
Implements 

$$
\rho =  \langle \psi|
 (T_i - T_{ref, i}) \Gamma(T_i) 
 \rangle 
$$

with $\Gamma(T_i) = a T_i+ b$ . $a$ and $b$ are appropriate fit parameters.

### TwoValuesL2Norm 

implements: 

$$
\sqrt{\int_\Omega uv d\Omega}
$$

## Tests

### Sanity checks

In [[Sanity_checks]] simple tests are preformed. They should confirm the correct implementation of the PK solver.

### Problems

In [[Problems]] the performance of the PK within a multi physics context is tested. Namely the Lid driven cavity benchmark and the flushing of DNPs in the MSRE.



