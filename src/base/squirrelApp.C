#include "squirrelApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
squirrelApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  return params;
}

squirrelApp::squirrelApp(InputParameters parameters) : MooseApp(parameters)
{
  /*squirrelApp::registerAll(_factory, _action_factory, _syntax);*/
  ModulesApp::registerAllObjects<squirrelApp>(_factory, _action_factory, _syntax);
}

squirrelApp::~squirrelApp() {}

void
squirrelApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<squirrelApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"squirrelApp"});
  Registry::registerActionsTo(af, {"squirrelApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
squirrelApp::registerApps()
{
  registerApp(squirrelApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
squirrelApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  squirrelApp::registerAll(f, af, s);
}
extern "C" void
squirrelApp__registerApps()
{
  squirrelApp::registerApps();
}
