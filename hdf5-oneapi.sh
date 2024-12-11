#!/bin/bash

## First need to make sure the NVHPPC modules are loaded
source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load compiler/2025.0.0 mkl/2025.0 mpi/2021.14

## Export intel MPI vars
export I_MPI_CC=icx
export I_MPI_CXX=icpx
export I_MPI_FC=ifx
export I_MPI_F77=ifx
export I_MPI_F90=ifx

## Configure and build and install
make clean

## Determine if the CPU is Intel or AMD
CPU=$(grep -m 1 vendor_id /proc/cpuinfo | awk '{print $3}')

## Configure according to the CPU architecture
if [ "$CPU" == "GenuineIntel" ]; then
    CPU="INTEL"
    CPP=cpp CFLAGS="-fPIC -xHost -fno-alias -align" FCFLAGS="-fPIC -xHost -fno-alias -align" CC=mpicc FC=mpif90 ./configure --with-zlib --enable-fortran --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.5/INTEL/2025.0.0
elif [ "$CPU" == "AuthenticAMD" ]; then
    CPU="AMD"
    CPP=cpp CFLAGS="-fPIC -fno-alias -align" FCFLAGS="-fPIC -fno-alias -align" CC=mpicc FC=mpif90 ./configure --with-zlib --enable-fortran --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.5/INTEL/2025.0.0
fi

make -j 12
make install