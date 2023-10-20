#include "ScalarMultiplicationPP.h"

#include "libmesh/dof_map.h"
registerMooseObject("squirrelApp", ScalarMultiplicationPP);

InputParameters
ScalarMultiplicationPP::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("Multiplies a variable based on a postprocessor.");
  params.addRequiredCoupledVar("source_variable", "The variable to be multiplied");
  params.addParam<PostprocessorName>("factor", "The postprocessor on the source");
  return params;
}

ScalarMultiplicationPP::ScalarMultiplicationPP(const InputParameters & parameters)
  : AuxKernel(parameters),
    _src(coupledValue("source_variable")),
    _pp_on_source(isParamValid("factor") ? &getPostprocessorValue("factor") : NULL)
{
}



Real
ScalarMultiplicationPP::computeValue()
{
  Real factor = _pp_on_source ? *_pp_on_source : 1.0;
  mooseAssert(factor != 0., "postprocessor value is zero");
  return _src[_qp] * factor;
}



