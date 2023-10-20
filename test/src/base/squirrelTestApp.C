//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "squirrelTestApp.h"
#include "squirrelApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
squirrelTestApp::validParams()
{
  InputParameters params = squirrelApp::validParams();
  return params;
}

squirrelTestApp::squirrelTestApp(InputParameters parameters) : MooseApp(parameters)
{
  squirrelTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

squirrelTestApp::~squirrelTestApp() {}

void
squirrelTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  squirrelApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"squirrelTestApp"});
    Registry::registerActionsTo(af, {"squirrelTestApp"});
  }
}

void
squirrelTestApp::registerApps()
{
  registerApp(squirrelApp);
  registerApp(squirrelTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
squirrelTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  squirrelTestApp::registerAll(f, af, s);
}
extern "C" void
squirrelTestApp__registerApps()
{
  squirrelTestApp::registerApps();
}
