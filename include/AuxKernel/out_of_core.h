
#pragma once

#include "AuxKernel.h"


class out_of_core : public AuxKernel
{
public:
  static InputParameters validParams();

  out_of_core(const InputParameters & parameters);

protected:
  /// ADKernelValue objects must override precomputeQpResidual
  virtual Real computeValue() override;
  void initialSetup();
  void determineDofIndices();
  void meshChanged();
  void timestepSetup();
  
  Real _n;
  const PostprocessorValue & _C_in;
  
  //these contain the precursor concentration
  const unsigned int _C_number;
  libMesh::NumericVector<double> & _serial_solution;
  std::vector<dof_id_type> _C_indices;
   
  std::vector<double> _solution;
  //contains solution vector
};
