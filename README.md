# Legacy OpenDDS 3.13.2 docker development environment

Environment to experiment with OpenDDS. Includes its dependencies ACE and TAO (CORBA), configured to be compatible with legacy systems that make use of `DCPSInfoRepo`, `tao_cosnaming` and IORs. Based in Ubuntu 20.04. OpenDDS is built from its official github repository.

## Contents

- Ubuntu 20.04
- [OpenDDS 3.13.2](https://github.com/OpenDDS/OpenDDS/tree/DDS-3.13.2).
- ACE/TAO installed as submodules (inside `ACE_wrappers`)
- Available tools: `opendds_idl`, `tao_idl`, `DCPSInfoRepo`, `tao_cosnaming`, etc.
- Environment variables automatically configured.

## Basic usage

### 1. Build container (run only first time)

~~~bash
./build.sh
~~~

### 2. Start interactive container

```bash
./run.sh
```
This mounts the `./workspace` directory inside the container.

### 3. Instructions to build `.idl` files

```bash
cd /workspace

# Step 1: generate DDS files from IDL
opendds_idl Sum.idl

# Step 2: generate CORBA files from TypeSupport
tao_idl SumTypeSupport.idl
```

## Installation paths

The following table describes the main paths and their content:

| Path                                    | Contents                                                   |
|-----------------------------------------|------------------------------------------------------------|
| `/opt/OpenDDS`                          | Código fuente y herramientas de OpenDDS                    |
| `/opt/OpenDDS/bin`                      | Ejecutables como `opendds_idl`, `DCPSInfoRepo`, etc.       |
| `/opt/OpenDDS/lib`                      | Bibliotecas de OpenDDS                                     |
| `/opt/OpenDDS/ACE_wrappers`             | Submódulo con ACE y TAO                                    |
| `/opt/OpenDDS/ACE_wrappers/lib`         | Bibliotecas como `libACE.so`, `libTAO_*.so`, etc.          |
| `/opt/OpenDDS/ACE_wrappers/TAO`         | Código fuente de TAO                                       |
| `/opt/OpenDDS/ACE_wrappers/TAO/TAO_IDL` | Librerías específicas para el compilador IDL de TAO   |

## Relevant environment variables

Estas variables están configuradas automáticamente al construir la imagen docker:

```bash
export DDS_ROOT=/opt/OpenDDS
export ACE_ROOT=/opt/OpenDDS/ACE_wrappers
export TAO_ROOT=$ACE_ROOT/TAO
export PATH=$DDS_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$DDS_ROOT/lib:$ACE_ROOT/lib:$TAO_ROOT/TAO_IDL:$LD_LIBRARY_PATH
```

Estas rutas permiten la ejecución de herramientas y aplicaciones sin instalación adicional en el sistema.

## Available tools

| Comando         | Función                                                  |
|-----------------|----------------------------------------------------------|
| `opendds_idl`   | Genera código DDS (TypeSupport, C++ stub/skeleton)       |
| `tao_idl`       | Genera código CORBA tradicional                          |
| `DCPSInfoRepo`  | Servicio de descubrimiento centralizado de OpenDDS       |
| `tao_cosnaming` | Naming Service CORBA                                     |


## Additional resources

- [OpenDDS 3.13.2 Github](https://github.com/OpenDDS/OpenDDS/tree/DDS-3.13.2)
- [OpenDDS Developer's Guide for OpenDDS 3.13.2](https://github.com/OpenDDS/OpenDDS/releases/download/DDS-3.12/OpenDDS-3.12.pdf)
- [TAO y ACE](https://www.dre.vanderbilt.edu/~schmidt/TAO.html)
