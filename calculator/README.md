Calculator example (CORBA/TAO)
===============================

This example illustrates a CORBA client-server application implementing a simple calculator service with two methods, `add` and `multiply`.

## Build instructions

1. Build IDL files. The first parameter is the path were the IDL files are located and the second the destination of the generated files. 

~~~bash
./generate_corba_types.sh idl generated
~~~

2. Build client and server with CMake:

~~~bash
mkdir build
cd build
cmake ..
make
~~~

## Execution instructions

If not already created in the [Messenger example](../messenger/), a docker network is required:

~~~bash
../messenger/create-network.sh
~~~

Three terminals are required.

1. Terminal 1. Run the TAO Naming Service:

~~~bash
docker run --rm -it \
  --name naming \
  --network opendds_net \
  --ip 172.30.0.2 \
  ubuntu20.04-opendds \
  tao_cosnaming -ORBListenEndpoints iiop://0.0.0.0:2809
~~~

2. Terminal 2. Run the server:

~~~bash
docker run --rm -it \
  --name calculator_server \
  --network opendds_net \
  --ip 172.30.0.3 \
  -v "$PWD/build:/workspace" \
  -w /workspace \
  ubuntu20.04-opendds \
  ./calculator_server \
    -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService
~~~

3. Terminal 3. Run the client:

~~~bash
docker run --rm -it \
  --name calculator_client \
  --network opendds_net \
  --ip 172.30.0.4 \
  -v "$PWD/build:/workspace" \
  -w /workspace \
  ubuntu20.04-opendds \
  ./calculator_client \
    -ORBInitRef NameService=corbaloc::172.30.0.2:2809/NameService
~~~

