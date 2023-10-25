squirrel
=====

"Fork squirrel" to create a new MOOSE-based application.

For more information see: [http://mooseframework.org/create-an-app/](http://mooseframework.org/create-an-app/)

This application is intended as a light weight and flexible implementation of the PK equation with the ability to capture the change in reactivity caused by the DNP movement and changes in temperature.
## DNP movement 

For a given power 

$$ 
P (x,t) = P(t) |\psi(x)\rangle 
$$

with $|P(x)\rangle$ beeing the L2 normalized flux $\Phi$: 

$$
 |\psi(x) \rangle = \frac{\Phi_0}{\int_{x} dx \Phi_0}
$$


The squirrel app solves the PK by weighting the DNP $C$ concentration. 

$$ 
\dot P(t) = \frac{\rho-\beta}{\Lambda} P(t) + \sum_I \lambda_I \frac{\langle \psi(x) |C_I(x)\rangle}{\langle \psi(x)| \psi(x)\rangle}
$$ 

with 

$$ 
\langle \psi|\phi\rangle = \int dx \psi \phi   
$$ 

and for the DNPs: 

$$ 
|\dot C_I(x) \rangle = \frac{\beta_I}{\Lambda}P(t)|\psi(x) \rangle - \lambda_I |C_i(x) \rangle 
$$

we are imposing steady state initial conditions so that $|\dot C_I(x) \rangle = \dot P(t) = 0$
with that we get for $t = 0$

$$ 
|C_I(x) \rangle = \frac{\beta_I}{\Lambda \lambda_I}|\psi(x) \rangle 
$$

## Temperature feedback

For a given temperature field $T$ we can calculate the difference at each point $i$ from the steady state Temperature $T_{ref}$ .

$$ \delta T_i = T_i - T_{ref, i}  $$

We can now calculate the change in $\rho_{temp}$ introduced by a temperature change:

$$ 
\rho_{temp} = \langle \psi |\delta T \rangle \Delta_{pcm/K}.
$$

with $\Delta$ being the reactivity change in reactivity caused by a global increase by $1$ Kelvin and $\int dr \psi(r) = 1$




## Implementation 

### AuxKernel 

The ScalarMultiplication AuxKernel implements the multiplication of a scalar variable  with a variable. 

$$ P(t) |P(x)\rangle  $$

The ScalarMultiplicationPP AuxKernel does the same for a postprocessor

### Postprocessor
The WeightDNPPostprocessor implements the

$$
A_I = \lambda_I \frac{\langle \psi|C_I\rangle}{\text{Norm}}
$$

The TemperatureFeedback postprocessor implements


$$
\rho = \sum_i \psi_i\Delta  \delta T_i
$$

The TemperatureFeedbackInt postprocessor implements

$$
\rho = \int dr \psi_i \Delta  \delta T_i
$$

## Tests


### Problems

In [[Problems]] the performance of the PK within a multi physics context is tested. Namely the Lid driven cavity benchmark and the flushing of DNPs in the MSRE.
