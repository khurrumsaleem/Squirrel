#include "FVTwoCoupledForces.h"

registerMooseObject("MooseApp", FVTwoCoupledForces);

InputParameters
FVTwoCoupledForces::validParams()
{
  InputParameters params = FVElementalKernel::validParams();

  params.addClassDescription("Implements a source term proportional to the value of a coupled "
                             "variable.");
  params.addRequiredParam<MooseFunctorName>("v", "The first coupled functor which provides the force");
  params.addRequiredParam<MooseFunctorName>("u", "The second coupled functor which provides the force");
  params.addParam<Real>("coef", 1.0, "Coefficent multiplier for the coupled force term.");

  return params;
}

FVTwoCoupledForces::FVTwoCoupledForces(const InputParameters & parameters)
  : FVElementalKernel(parameters), 
	_u(getFunctor<ADReal>("u")), 
	_v(getFunctor<ADReal>("v")), 
	_coef(getParam<Real>("coef"))
{
}

ADReal
FVTwoCoupledForces::computeQpResidual()
{
  return -_coef * _v(makeElemArg(_current_elem), determineState()) * _u(makeElemArg(_current_elem), determineState());
}
