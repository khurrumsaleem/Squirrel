#pragma once

#include "FVElementalKernel.h"

/**
 * Simple class to demonstrate off diagonal Jacobian contributions.
 */
class FVTwoCoupledForces : public FVElementalKernel
{
public:
  static InputParameters validParams();

  FVTwoCoupledForces(const InputParameters & parameters);

protected:
  ADReal computeQpResidual() override;

protected:
  /// The coupled functor applying the force
  const Moose::Functor<ADReal> & _v;
  const Moose::Functor<ADReal> & _u;
  /// An optional coefficient multiplying the coupled force
  const Real _coef;
};
