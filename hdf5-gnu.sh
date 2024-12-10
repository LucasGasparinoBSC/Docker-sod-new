#!/bin/bash

source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles

make clean
CPP=cpp CC=mpicc FC=mpif90 ./configure --with-zlib --enable-fortran --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.5/GNU/14.2.1
make -j 12
make install