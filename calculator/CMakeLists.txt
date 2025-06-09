cmake_minimum_required(VERSION 3.10)
project(CalculatorRPC)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Validar que ACE_ROOT y TAO_ROOT estén definidos
if(NOT DEFINED ENV{ACE_ROOT})
  message(FATAL_ERROR "La variable de entorno ACE_ROOT no está definida")
endif()
if(NOT DEFINED ENV{TAO_ROOT})
  message(FATAL_ERROR "La variable de entorno TAO_ROOT no está definida")
endif()
set(ACE_ROOT $ENV{ACE_ROOT})
set(TAO_ROOT $ENV{TAO_ROOT})
# Incluir headers de TAO y del IDL generado
include_directories(
  ${ACE_ROOT}
  ${TAO_ROOT}
  ${ACE_ROOT}/TAO/orbsvcs
  ${ACE_ROOT}/TAO/orbsvcs/orbsvcs
  ${CMAKE_CURRENT_SOURCE_DIR}/generated
)
link_directories(
  ${ACE_ROOT}/lib
  ${TAO_ROOT}/lib
)
# Fuentes generados por tao_idl
set(GENERATED_SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/calculatorC.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/calculatorS.cpp
)
# # Cliente CORBA
add_executable(calculator_client
  ${CMAKE_CURRENT_SOURCE_DIR}/cpp/calculator_client.cpp
  ${GENERATED_SOURCES}
)
# Servidor CORBA
add_executable(calculator_server
  ${CMAKE_CURRENT_SOURCE_DIR}/cpp/calculator_server.cpp
  ${GENERATED_SOURCES}
)
# Bibliotecas necesarias para CORBA
set(CORBA_LIBS
  TAO
  TAO_CosNaming
  TAO_AnyTypeCode
  TAO_PortableServer
  ACE
)
target_link_libraries(calculator_client
  ${CORBA_LIBS}
)
target_link_libraries(calculator_server
  ${CORBA_LIBS}
)
