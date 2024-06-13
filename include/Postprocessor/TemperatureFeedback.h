#pragma once

#include "NodalVariablePostprocessor.h"

class TemperatureFeedback : public NodalVariablePostprocessor
{
public:
  static InputParameters validParams();

  TemperatureFeedback(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;
  virtual void finalize() override;
  virtual void threadJoin(const UserObject & y) override;
  virtual Real getValue () const override;

protected:
  /// The variable to compare to
  const VariableValue & _T_ref;
  const VariableValue & _flux;
  Real _total_rho;
  Real _sum;
  Real _n;
};
