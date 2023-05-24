### Basic OS image that allows SOD2D to be built and tested

## Import the arch latest images
FROM archlinux:latest

## Update and install basic system packages
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm gcc gcc-fortran tcl autoconf\
        make cmake git wget vim curl ninja gdb tcl base-devel\
        linux-headers linux-lts cuda

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
WORKDIR /home/Apps/Libraries
RUN mkdir -p modulefiles

## Install the IntelOneAPI compilers
WORKDIR /home/Apps/Compilers
RUN mkdir -p modulefiles && mkdir -p intel/oneapi
WORKDIR /home/Apps/Compilers/intel
COPY oneapiInstall.sh .
RUN chmod +x oneapiInstall.sh && ./oneapiInstall.sh

## Download and install NVHPC
WORKDIR /home/Apps/Compilers
RUN mkdir -p nvidia/hpc_sdk
WORKDIR /home/Apps/Compilers/nvidia
COPY nvhpcInstall.sh .
RUN chmod +x nvhpcInstall.sh && ./nvhpcInstall.sh

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

## Download and build smartRedis using GCC
WORKDIR /home/Apps/Libraries
COPY smartRedis.sh .
RUN chmod +x smartRedis.sh

## Set the syystem startpoint
WORKDIR /home/Apps
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]