#!/bin/bash

## First need to make sure the NVHPPC modules are loaded
source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load nvhpc-hpcx-cuda12/24.11

## Configure and build and install
make clean
CPP=cpp CFLAGS="-fPIC -m64" FCFLAGS="-fPIC -m64" CC=mpicc FC=mpif90 ./configure --with-zlib --enable-fortran --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.5/NVHPC/24.11
make -j 12
make install