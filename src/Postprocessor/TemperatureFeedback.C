#include "TemperatureFeedback.h"
#include "MooseMesh.h"
#include "SubProblem.h"

registerMooseObject("squirrelApp", TemperatureFeedback);

InputParameters
TemperatureFeedback::validParams()
{
  InputParameters params = NodalVariablePostprocessor::validParams();
  params.addClassDescription("Calculates the temperature feedback depending on the Temperature");
  params.addRequiredCoupledVar("T_ref", "The refference temperature");
  params.addRequiredCoupledVar("flux", "The refference reactivity shape");
  params.addParam<Real>("total_rho", 0.0, "the total change in rho [1/K]");
  return params;
}

TemperatureFeedback::TemperatureFeedback(const InputParameters & parameters)
  : NodalVariablePostprocessor(parameters),_sum(0), _n(0),
	_T_ref(coupledValue("T_ref")),
	_flux(coupledValue("flux")),
    _total_rho(getParam<Real>("total_rho"))
{
}


void 
TemperatureFeedback::initialize()
{
	_sum = 0;
	_n = 0;
}

void 
TemperatureFeedback::execute()
{
	_sum += _flux[_qp] * (_u[_qp]-_T_ref[_qp]);
	_n++;
}

Real
TemperatureFeedback::getValue() const
{
	return _sum * _total_rho;
}

void
TemperatureFeedback::finalize()
{
	gatherSum(_sum);
	gatherSum(_n);
}

void 
TemperatureFeedback::threadJoin(const UserObject & y)
{
  const TemperatureFeedback & pps = static_cast<const TemperatureFeedback &>(y);
  _sum += pps._sum;
  _n += pps._n;
}
