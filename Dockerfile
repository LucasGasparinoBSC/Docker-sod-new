### Basic OS image that allows SOD2D to be built and tested

## Import the arch latest images
FROM archlinux:latest

## Update and install basic system packages
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm gcc gcc-fortran tcl autoconf\
        make cmake git wget vim curl ninja gdb tcl base-devel\
        linux-headers linux-lts\
        nvidia nvidia-utils nvidia-settings cuda

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

## Install the IntelOneAPI compilers
RUN mkdir -p intel/oneapi && cd intel
RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/7deeaac4-f605-4bcf-a81b-ea7531577c61/l_BaseKit_p_2023.1.0.46401.sh
RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/1ff1b38a-8218-4c53-9956-f0b264de35a4/l_HPCKit_p_2023.1.0.46346.sh

## Install the Base toolkit
#RUN sh l_BaseKit_p_2023.1.0.46401.sh -a -c --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi
## Install the HPC toolkit
#RUN sh l_HPCKit_p_2023.1.0.46346.sh -a -c --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi

## Run the modulefile generator
WORKDIR /home/Apps/Compilers/intel/oneapi
#RUN ./modulefiles-setup.sh --output-dir=/home/Apps/Compilers/modulefiles --ignore-latest --force

## Download and install environment-modules
WORKDIR /home/Apps/Modules
RUN mkdir -p 5.2.0
RUN curl -LJO https://github.com/cea-hpc/modules/releases/download/v5.2.0/modules-5.2.0.tar.gz
RUN tar -xvf modules-5.2.0.tar.gz
WORKDIR /home/Apps/Modules/modules-5.2.0
RUN ./configure --prefix=/home/Apps/Modules/5.2.0
RUN make && make install
WORKDIR /home/Apps
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]