FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    build-essential cmake git wget curl nano \
    python3 python3-pip python3-setuptools \
    libssl-dev libxerces-c-dev \
    && rm -rf /var/lib/apt/lists/*

# Clonar e instalar OpenDDS
WORKDIR /opt

RUN git clone https://github.com/OpenDDS/OpenDDS.git && \
    cd OpenDDS && \
    git checkout DDS-3.13.2  # o la última versión compatible con Ubuntu 20.04

# Configurar e instalar OpenDDS
RUN cd /opt/OpenDDS && \
    ./configure --no-tests && \
    make -j$(nproc)

# Definición de variables de entorno para OpenDDS + ACE/TAO
ENV DDS_ROOT=/opt/OpenDDS
ENV ACE_ROOT=$DDS_ROOT/ACE_wrappers
ENV TAO_ROOT=$ACE_ROOT/TAO

# Añadir herramientas de OpenDDS al PATH
ENV PATH=$DDS_ROOT/bin:$PATH

# Incluir todas las rutas necesarias de bibliotecas compartidas
ENV LD_LIBRARY_PATH=$DDS_ROOT/lib:$ACE_ROOT/lib:$TAO_ROOT/TAO_IDL:$LD_LIBRARY_PATH

ENV PATH=$DDS_ROOT/bin:$DDS_ROOT/ACE_wrappers/TAO/TAO_IDL:$PATH

#------------------------------------------------------------------------------------------------
# TAO cosnaming
#------------------------------------------------------------------------------------------------

# Generate Makefiles for TAO tools using MPC
RUN cd /opt/OpenDDS && \
    export MPC_ROOT=/opt/OpenDDS/ACE_wrappers/MPC && \
    export DDS_ROOT=/opt/OpenDDS && \
    export ACE_ROOT=/opt/OpenDDS/ACE_wrappers && \
    export TAO_ROOT=$ACE_ROOT/TAO && \
    cd /opt/OpenDDS/ACE_wrappers/TAO/orbsvcs/ && \
    $ACE_ROOT/bin/mwc.pl -type gnuace -features xerces3=1 && \
    make -j$(nproc)

RUN ln -s $TAO_ROOT/orbsvcs/Naming_Service/tao_cosnaming /usr/local/bin/tao_cosnaming && \
    ln -s $TAO_ROOT/orbsvcs/IFR_Service/tao_ifr_service /usr/local/bin/tao_ifr_service && \
    ln -s $TAO_ROOT/orbsvcs/ImplRepo_Service/implrepo_service /usr/local/bin/implrepo_service

#------------------------------------------------------------------------------------------------


# A partir de Ububtu 24.04 viene creado un usuario no root "ubuntu"
ARG USERNAME=ubuntu

USER $USERNAME
ENV HOME=/home/$USERNAME
WORKDIR /workspace
