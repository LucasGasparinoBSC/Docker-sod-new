### Basic OS image that allows SOD2D to be built and tested

## Import the arch latest images
#FROM archlinux:latest
FROM archlinux:latest

## Update and install basic system packages
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm base-devel gcc gcc-fortran tcl autoconf\
        make cmake git wget vim curl ninja gdb less\
        linux-headers linux-lts openssh\
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

## Create directories for compilers, libraries and Modules
RUN mkdir -p Compilers && mkdir -p Libraries && mkdir -p Modules

## Create folders for compilers
WORKDIR /home/Apps/Compilers
RUN mkdir -p intel/oneapi && mkdir -p nvidia/hpc_sdk && mkdir -p modulefiles

## Create folders for libraries
WORKDIR /home/Apps/Libraries
RUN mkdir -p HDF5/1.14.5 && mkdir -p CGNS/4.5.0 && mkdir -p modulefiles

## Download and install NVHPC
WORKDIR /home/Apps/Compilers/nvidia
COPY nvhpcInstall.sh .
RUN chmod +x nvhpcInstall.sh && ./nvhpcInstall.sh

## Install the IntelOneAPI compilers
WORKDIR /home/Apps/Compilers/intel
COPY oneapiInstall.sh .
RUN chmod +x oneapiInstall.sh && ./oneapiInstall.sh

## Download and install environment-modules
WORKDIR /home/Apps/Modules
RUN mkdir -p 5.2.0
RUN curl -LJO https://github.com/cea-hpc/modules/releases/download/v5.2.0/modules-5.2.0.tar.gz
RUN tar -xvf modules-5.2.0.tar.gz
WORKDIR /home/Apps/Modules/modules-5.2.0
RUN ./configure --prefix=/home/Apps/Modules/5.2.0
RUN make && make install

## Add the modulefiles to the modulefiles folder
WORKDIR /home/Apps/Libraries/modulefiles
RUN mkdir -p hdf5
COPY 1.14.5 ./hdf5

## Move the NVHPC modulefiles to /Apps/Compilers modulefiles
WORKDIR /home/Apps/Compilers/nvidia/hpc_sdk
RUN cp -r modulefiles/* /home/Apps/Compilers/modulefiles/.

## Download HDF5-1.14.5
WORKDIR /home/Apps/Libraries/HDF5/1.14.5
RUN wget https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.5/hdf5-1.14.5.tar.gz
RUN tar -xvf hdf5-1.14.5.tar.gz
WORKDIR /home/Apps/Libraries/HDF5/1.14.5/hdf5-1.14.5

##  build and install the GNU version
COPY hdf5-gnu.sh .
RUN chmod +x hdf5-gnu.sh && ./hdf5-gnu.sh

## Build and innstall the intel version
## TODO: see oneAPI compiler note.
COPY hdf5-oneapi.sh .
RUN chmod +x hdf5-oneapi.sh && ./hdf5-oneapi.sh

# Build and install the nvhpc version
COPY hdf5-nvhpc.sh .
RUN chmod +x hdf5-nvhpc.sh && ./hdf5-nvhpc.sh

### Download and build smartRedis using GCC
#WORKDIR /home/Apps/Libraries
#COPY smartRedis.sh .
#RUN chmod +x smartRedis.sh && ./smartRedis.sh
#
### SmartRedis with NVHPC
#COPY smartRedis-nvhpc.sh .
#RUN chmod +x smartRedis-nvhpc.sh && ./smartRedis-nvhpc.sh
#
### Set the syystem startpoint
WORKDIR /home/Apps
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]