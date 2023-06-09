#!/bin/bash

source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load gnu/12.3.0/openmpi/4.1.5

make clean
CPP=cpp CC=mpicc CXX=mpicxx FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/GNU/12.3.0
make -j 12
make install