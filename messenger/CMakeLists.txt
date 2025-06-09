cmake_minimum_required(VERSION 3.10)
project(OpenDDSMessenger)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Validar que DDS_ROOT esté definido
if(NOT DEFINED ENV{DDS_ROOT})
  message(FATAL_ERROR "La variable de entorno DDS_ROOT no está definida")
endif()

if(NOT DEFINED ENV{ACE_ROOT})
  message(FATAL_ERROR "La variable de entorno ACE_ROOT no está definida")
endif()

if(NOT DEFINED ENV{TAO_ROOT})
  message(FATAL_ERROR "La variable de entorno TAO_ROOT no está definida")
endif()

set(DDS_ROOT $ENV{DDS_ROOT})
set(ACE_ROOT $ENV{ACE_ROOT})
set(TAO_ROOT $ENV{TAO_ROOT})

# Incluir headers de OpenDDS y del IDL
include_directories(
  $ENV{DDS_ROOT}
  $ENV{DDS_ROOT}/dds
  $ENV{ACE_ROOT}         
  $ENV{TAO_ROOT}           
  ${CMAKE_CURRENT_SOURCE_DIR}/generated
)

link_directories(
  $ENV{DDS_ROOT}/lib
  $ENV{ACE_ROOT}/lib
  $ENV{TAO_ROOT}/lib
)

# Rutas absolutas para los archivos fuente generados por opendds_idl y tao_idl
set(GENERATED_SOURCES  
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/MessengerC.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/MessengerTypeSupportC.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/MessengerTypeSupportS.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/MessengerS.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/generated/MessengerTypeSupportImpl.cpp
)

# Crear ejecutable del subscriber
add_executable(subscriber
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/Subscriber.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/DataReaderListenerImpl.cpp
    ${GENERATED_SOURCES}
)

# Crear ejecutable del publisher
add_executable(publisher
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/Publisher.cpp
    ${GENERATED_SOURCES}
)

set(OPENDDS_LIBS
  OpenDDS_Dcps
  TAO
  TAO_AnyTypeCode
  TAO_PortableServer
  ACE
)

# Vincular bibliotecas requeridas por OpenDDS
target_link_libraries(subscriber
  ${OPENDDS_LIBS}
)

target_link_libraries(publisher
  ${OPENDDS_LIBS}
)
