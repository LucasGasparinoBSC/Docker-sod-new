#!/bin/bash

## First need to make sure the NVHPPC modules are loaded
source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load nvhpc-hpcx-cuda12/23.9

## Workaround for using gcc-12 toolchain
#ln -s /usr/bin/gcc-12 /usr/local/bin/gcc
#ln -s /usr/bin/g++-12 /usr/local/bin/g++
#ln -s /usr/bin/gfortran-12 /usr/local/bin/gfortran

## Configure and build and install
make clean
CPP=cpp CFLAGS="-fPIC -m64 -tp=px --gcc-toolchain=/home/Apps/GCC12" CXXFLAGS="-fPIC -m64 -tp=px --gcc-toolchain=/home/Apps/GCC12" FCFLAGS="-fPIC -m64 -tp=px --gcc-toolchain=/home/Apps/GCC12" CC=mpicc CXX=mpic++ FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/NVHPC/23.9
make -j 12
make install