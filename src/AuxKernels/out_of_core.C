
#include "out_of_core.h"
#include "SystemBase.h"

#include "AuxiliarySystem.h"

registerMooseObject("squirrelApp", out_of_core);
InputParameters
out_of_core::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("This AuxKernel handels the out of core time");
 
  params.addParam<PostprocessorName>("C_in", 1.0, "The C input");
  params.addRequiredCoupledVar("precursors_concentration", "Concentration of precursors");
  
  return params;
}

out_of_core::out_of_core(const InputParameters & parameters)
  : AuxKernel(parameters),
  _n(0), 
 
  _C_in(getPostprocessorValue("C_in")),
  _C_number(getVar("precursors_concentration", 0)->number()),
  _serial_solution(_aux_sys.serializedSolution())
  
{
}


// gathering the precursor concentration vector
void
out_of_core::determineDofIndices()
{
  _C_indices.clear();
  _C_indices.reserve(_mesh.getMesh().n_nodes());

  for (auto * const node : _mesh.getMesh().local_node_ptr_range())
  {
    if (!node->active())
      continue;
  // the indices in the non linear  solution vector with the precursor concentration.
	_C_indices.push_back(node->dof_number(_aux_sys.number(), _C_number, 0));
  }


  _communicator.allgather(_C_indices, false);
  _C_indices.shrink_to_fit();
}

void
out_of_core::initialSetup()
{
  determineDofIndices();
}

void
out_of_core::meshChanged()
{
  determineDofIndices();
}

void
out_of_core::timestepSetup()
{
	_n = 0;
	_solution.clear();
	_solution.reserve(_C_indices.size());
    for(unsigned int i = 0; i<_C_indices.size(); i++){

		if ( i == 0) {

			_solution.push_back(_C_in);
		}

		else{
			_solution.push_back(_serial_solution(_C_indices[i-1]));
		}

	}
	_solution.shrink_to_fit();
}
Real
out_of_core::computeValue()
{  
   
        //for(unsigned int i = 0; i<_C_indices.size(); i++){
        //  _weight_sum += _psi_serial_solution(_psi_indices[i]) *  _serial_solution(_C_indices[i]);
	_n = _n+1;
	if(_n >_C_indices.size()){
		_n = 1;
	}
	return _solution[_n-1];
}

