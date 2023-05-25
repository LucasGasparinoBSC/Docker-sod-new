#!/bin/bash

source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load nvhpc/23.3

make clean
CPP=cpp CC=mpicc CXX=mpicxx FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/GNU/12.2.1
make -j 12
make install