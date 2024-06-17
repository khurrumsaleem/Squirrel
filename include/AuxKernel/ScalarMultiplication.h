#pragma once

#include "AuxKernel.h"

class ScalarMultiplication : public AuxKernel
{
public:
  static InputParameters validParams();

  ScalarMultiplication(const InputParameters & parameters);


protected:

  virtual Real computeValue() override;
  const VariableValue & _src;
  MooseVariableScalar & _var;
  unsigned int _idx;
  Real _normal_factor;
};
