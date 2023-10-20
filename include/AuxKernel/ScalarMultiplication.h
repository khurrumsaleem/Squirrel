#pragma once

#include "AuxKernel.h"

class ScalarMultiplication : public AuxKernel
{
public:
  static InputParameters validParams();

  ScalarMultiplication(const InputParameters & parameters);


protected:

  virtual Real computeValue() override;
  MooseVariableScalar & _var;
  unsigned int _idx;
  const VariableValue & _src;
  Real _normal_factor;
};
