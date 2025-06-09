# Messenger example

This is the Messenger example from the original [OpenDDS Developer's Guide for OpenDDS 3.13.2](https://github.com/OpenDDS/OpenDDS/releases/download/DDS-3.12/OpenDDS-3.12.pdf).

## Build instructions

1. Build IDL files. The first parameter is the path were the IDL files are located and the second the destination of the generated files. 

~~~bash
./generate_dds_types.sh idl generated
~~~

2. Build publisher and subscriber with CMake:

~~~bash
mkdir build
cd build
cmake ..
make
~~~

## Execution instructions

There are two ways to run the example application:

1. With a Local IOR file.
2. With DCPS Inforepo and TAO Naming Service.

### Option 1. With Local IOR file

**Execution instructions**

Three terminals are needed:

1. Terminal 1 - Run IOR

~~~bash
./run.sh # Start docker
cd examples/messenger/build
DCPSInfoRepo -o simple.ior
~~~

2. Terminal 2 - Subscriber

~~~bash
./run.sh # Start docker
cd examples/messenger/build
./subscriber -DCPSInfoRepo file://simple.ior
~~~

2. Terminal 3 - Publisher

~~~bash
./run.sh # Start docker
cd examples/messenger/build
./publisher -DCPSInfoRepo file://simple.ior
~~~

### Option 2. With DCPS Inforepo and TAO Naming Service

This is a more realistic scenario of how a real distributed application is deployed, were processs do not share the same node. In this case, each service has been assigned a different node:

| Node               | IP         | Port  |
|--------------------|------------|-------|
| TAO Naming Service | 172.30.0.2 | 2809  |
| DCPS Inforepo      | 172.30.0.3 | 12345 |
| Subscriber         | 172.30.0.4 | N/A   |
| Publisher          | 172.30.0.5 | N/A   |

![deployment](./doc/assets/deployment-tao-discovery.png)

Create network (once):

~~~bash
./create-network.sh
~~~

Four terminals are required.

In terminal 1, run DCPS Inforepo:

~~~bash
./create-network.sh
~~~

In terminal 2, run TAO Naming Service:

~~~bash
./run-tao-naming-service.sh
~~~

In terminal 3, run subscriber:

~~~bash
./run-subscriber.sh
~~~

In terminal 4, run publisher:

~~~bash
./run-publisher.sh
~~~