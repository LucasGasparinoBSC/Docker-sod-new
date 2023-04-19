#!/bin/bash

## First need to make sure the NVHPPC modules are loaded
source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load compiler/2023.1.0 mkl/2023.1.0 mpi/2021.9.0

## Export intel MPI vars
export I_MPI_CC=icx
export I_MPI_CXX=icpx
export I_MPI_FC=ifort
export I_MPI_F77=ifort
export I_MPI_F90=ifort

## Configure and build and install
make clean

## Determine if the CPU is Intel or AMD
CPU=$(grep -m 1 vendor_id /proc/cpuinfo | awk '{print $3}')

## Configure according to the CPU architecture
if [ "$CPU" == "GenuineIntel" ]; then
    CPU="INTEL"
    CPP=cpp CFLAGS="-fPIC -xHost -fno-alias -align" CXXFLAGS="-fPIC -xHost -fno-alias -align" FCFLAGS="-fPIC -xHost -fno-alias -align" CC=mpicc CXX=mpicxx FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/INTEL/2023.1.0
elif [ "$CPU" == "AuthenticAMD" ]; then
    CPU="AMD"
    CPP=cpp CFLAGS="-fPIC -fno-alias -align" CXXFLAGS="-fPIC -fno-alias -align" FCFLAGS="-fPIC -fno-alias -align" CC=mpicc CXX=mpicxx FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/INTEL/2023.1.0
fi

make -j 12
make install