#include "calculatorC.h"
#include <tao/corba.h>
#include <orbsvcs/CosNamingC.h>
#include <iostream>

int main(int argc, char* argv[]) {
  try {
    CORBA::ORB_var orb = CORBA::ORB_init(argc, argv);
    CORBA::Object_var nsObj = orb->resolve_initial_references("NameService");
    CosNaming::NamingContext_var ctx = CosNaming::NamingContext::_narrow(nsObj);

    CosNaming::Name name;
    name.length(1);
    name[0].id = CORBA::string_dup("Calculator");

    CORBA::Object_var obj = ctx->resolve(name);
    Example::Calculator_var calc = Example::Calculator::_narrow(obj);

    CORBA::Long r1 = calc->add(10, 5);
    CORBA::Long r2 = calc->multiply(4, 3);
    std::cout << "Resultado suma: " << r1 << "\nResultado mult: " << r2 << std::endl;

    orb->destroy();
  } catch (const CORBA::Exception& ex) {
    std::cerr << "Excepción: " << ex << std::endl;
    return 1;
  }

  return 0;
}
