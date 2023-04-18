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
CPP=cpp CFLAGS="-fPIC -xHost -fno-alias -align" CXXFLAGS="-fPIC -xHost -fno-alias -align" FCFLAGS="-fPIC -xHost -fno-alias -align" CC=mpicc CXX=mpicxx FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/INTEL/2023.1.0
make -j 12
make install