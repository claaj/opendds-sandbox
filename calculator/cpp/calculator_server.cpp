#include "calculatorS.h"
#include <tao/corba.h>
#include <orbsvcs/CosNamingC.h>
#include <iostream>

class CalculatorImpl : public virtual POA_Example::Calculator {
public:
  virtual CORBA::Long add(CORBA::Long a, CORBA::Long b) {
    std::cout << "Servidor: sumando " << a << " + " << b << std::endl;
    return a + b;
  }

  virtual CORBA::Long multiply(CORBA::Long a, CORBA::Long b) {
    std::cout << "Servidor: multiplicando " << a << " * " << b << std::endl;
    return a * b;
  }
};

int main(int argc, char* argv[]) {
  try {
    CORBA::ORB_var orb = CORBA::ORB_init(argc, argv);
    CORBA::Object_var obj = orb->resolve_initial_references("RootPOA");
    PortableServer::POA_var poa = PortableServer::POA::_narrow(obj);
    PortableServer::POAManager_var mgr = poa->the_POAManager();

    CalculatorImpl* calcImpl = new CalculatorImpl();
    PortableServer::ObjectId_var id = poa->activate_object(calcImpl);
    CORBA::Object_var ref = poa->id_to_reference(id);

    CORBA::Object_var nsObj = orb->resolve_initial_references("NameService");
    CosNaming::NamingContext_var ctx = CosNaming::NamingContext::_narrow(nsObj);
    CosNaming::Name name;
    name.length(1);
    name[0].id = CORBA::string_dup("Calculator");
    ctx->rebind(name, ref);

    mgr->activate();
    std::cout << "Servidor listo." << std::endl;
    orb->run();
  } catch (const CORBA::Exception& ex) {
    std::cerr << "Excepción: " << ex << std::endl;
    return 1;
  }

  return 0;
}
