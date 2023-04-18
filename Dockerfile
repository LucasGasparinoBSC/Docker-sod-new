### Basic OS image that allows SOD2D to be built and tested

## Import the arch latest images
FROM archlinux:latest

## Update and install basic system packages
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm gcc gcc-fortran tcl autoconf\
        make cmake git wget vim curl ninja gdb tcl base-devel\
        linux-headers linux-lts\
        nvidia nvidia-utils nvidia-settings cuda

## Installl OpenMPI package
RUN pacman -S --noconfirm openmpi

## Setup the CUDA environment
ENV CUDA_PATH=/opt/cuda
## Add CUDA_PATH to PATH and LD_LIBRARY_PATH
ENV PATH=$PATH:$CUDA_PATH/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_PATH/lib64

## Create a workiing folder on home
WORKDIR /home
RUN mkdir -p Apps
WORKDIR /home/Apps

## Create directories for compilers, libraries and Moddules
RUN mkdir -p Compilers && mkdir -p Libraries && mkdir -p Modules

## Create a modulefiles folder
WORKDIR /home/Apps/Compilers
RUN mkdir -p modulefiles
WORKDIR /home/Apps/Libraries
RUN mkdir -p modulefiles

## Install the IntelOneAPI compilers
RUN mkdir -p intel/oneapi && cd intel
RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/7deeaac4-f605-4bcf-a81b-ea7531577c61/l_BaseKit_p_2023.1.0.46401.sh
RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/1ff1b38a-8218-4c53-9956-f0b264de35a4/l_HPCKit_p_2023.1.0.46346.sh

## Install the Base toolkit
RUN sh l_BaseKit_p_2023.1.0.46401.sh -a -c --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi
## Install the HPC toolkit
RUN sh l_HPCKit_p_2023.1.0.46346.sh -a -c --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi

## Cleanup the installation files
RUN rm -rf l_BaseKit_p_2023.1.0.46401.sh l_HPCKit_p_2023.1.0.46346.sh

## Run the modulefile generator
WORKDIR /home/Apps/Compilers/intel/oneapi
RUN ./modulefiles-setup.sh --output-dir=/home/Apps/Compilers/modulefiles --ignore-latest --force

## Download and install NVHPC
WORKDIR /home/Apps/Compilers
RUN mkdir -p nvidia/hpc_sdk
WORKDIR /home/Apps/Compilers/nvidia
RUN wget https://developer.download.nvidia.com/hpc-sdk/23.3/nvhpc_2023_233_Linux_x86_64_cuda_12.0.tar.gz
RUN tar -xvf nvhpc_2023_233_Linux_x86_64_cuda_12.0.tar.gz
COPY nvhpcInstall.sh .
RUN chmod +x nvhpcInstall.sh
RUN ./nvhpcInstall.sh

## Cleanup the installation files
RUN rm -rf nvhpc_2023_233_Linux_x86_64_cuda_12.0.tar.gz nvhpcInstall.sh

## Move the modulefiles to /Apps/Compilers modulefiles
WORKDIR /home/Apps/Compilers/nvidia/hpc_sdk
RUN cp modulefiles/* /home/Apps/Compilers/modulefiles -r

## Download and install environment-modules
WORKDIR /home/Apps/Modules
RUN mkdir -p 5.2.0
RUN curl -LJO https://github.com/cea-hpc/modules/releases/download/v5.2.0/modules-5.2.0.tar.gz
RUN tar -xvf modules-5.2.0.tar.gz
WORKDIR /home/Apps/Modules/modules-5.2.0
RUN ./configure --prefix=/home/Apps/Modules/5.2.0
RUN make && make install

## Download HDF5-1.14.0
WORKDIR /home/Apps/Libraries
RUN mkdir -p HDF5/1.14.0
WORKDIR /home/Apps/Libraries/HDF5/1.14.0
RUN wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.0/src/hdf5-1.14.0.tar.gz
RUN tar -xvf hdf5-1.14.0.tar.gz

##  build and install the GNU version
WORKDIR /home/Apps/Libraries/HDF5/1.14.0/hdf5-1.14.0
COPY hdf5-gnu.sh .
RUN chmod +x hdf5-gnu.sh
RUN ./hdf5-gnu.sh

## Buildd and install the nvhpc version
COPY hdf5-nvhpc.sh .
RUN chmod +x hdf5-nvhpc.sh
RUN ./hdf5-nvhpc.sh

## Build and innstall the intel version
COPY hdf5-oneapi.sh .
RUN chmod +x hdf5-oneapi.sh
RUN ./hdf5-oneapi.sh

## Add the modulefiles to the modulefiles folder
WORKDIR /home/Apps/Libraries/modulefiles
RUN mkdir -p hdf5
COPY 1.14.0 ./hdf5

## Set the syystem startpoint
WORKDIR /home/Apps
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]