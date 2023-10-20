#include "ScalarMultiplication.h"
#include "MooseVariableScalar.h"
#include "libmesh/dof_map.h"

registerMooseObject("squirrelApp", ScalarMultiplication);

InputParameters
ScalarMultiplication::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("Multiplies a variable based on a scalar value.");
  params.addRequiredCoupledVar("source_variable", "The variable to be multiplied");
  params.addRequiredParam<VariableName>("factor", "Name of the factor");
  params.addParam<Real>("normal_factor", 1.0, "The normalization factor");
  params.addParam<unsigned int>("component", 0, "Component to output for this variable");
  return params;
}

ScalarMultiplication::ScalarMultiplication(const InputParameters & parameters)
  : AuxKernel(parameters),
    _src(coupledValue("source_variable")),
    _var(_subproblem.getScalarVariable(_tid, getParam<VariableName>("factor"))),
    _idx(getParam<unsigned int>("component")),
    _normal_factor(getParam<Real>("normal_factor"))
{
}



Real
ScalarMultiplication::computeValue()
{
  _var.reinit();

return _normal_factor*_src[_qp] * _var.sln()[0];
}



