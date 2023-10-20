#include "TemperatureFeedbackInt.h"
#include "MooseMesh.h"
#include "SubProblem.h"

registerMooseObject("squirrelApp", TemperatureFeedbackInt);

InputParameters
TemperatureFeedbackInt::validParams()
{
  InputParameters params = ElementIntegralVariablePostprocessor::validParams();
  params.addClassDescription("Calculates the temperature feedback depending on the Temperature");
  params.addRequiredCoupledVar("T_ref", "The refference temperature");
  params.addRequiredCoupledVar("flux", "The refference reactivity shape");
  params.addParam<Real>("total_rho", 0.0, "the total change in rho [1/K]");
  return params;
}

TemperatureFeedbackInt::TemperatureFeedbackInt(const InputParameters & parameters)
  : ElementIntegralVariablePostprocessor(parameters),
	_T_ref(coupledValue("T_ref")),
	_flux(coupledValue("flux")),
	_total_rho(getParam<Real>("total_rho"))
{
}



Real
TemperatureFeedbackInt::getValue()
{
	return ElementIntegralVariablePostprocessor::getValue();
}

Real
TemperatureFeedbackInt::computeQpIntegral()
{
	 return _flux[_qp] * (_u[_qp]-_T_ref[_qp])* _total_rho;
}

