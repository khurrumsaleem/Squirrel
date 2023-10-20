#pragma once

#include "AuxKernel.h"

class ScalarMultiplicationPP : public AuxKernel
{
public:
  static InputParameters validParams();

  ScalarMultiplicationPP(const InputParameters & parameters);


protected:

  virtual Real computeValue() override;
  const VariableValue & _src;
  const Real * const _pp_on_source;
};
