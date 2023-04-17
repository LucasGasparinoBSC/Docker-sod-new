#!/bin/bash

## There's no module to load, so just configure and build HDF5
CPP=cpp CC=mpicc CXX=mpicxx FC=mpif90 ./configure --with-zlib --enable-threadsafe --enable-cxx --enable-fortran --enable-unsupported --enable-parallel --enable-shared --prefix=/home/Apps/Libraries/HDF5/1.14.0/GNU/12.2.1
make -j 12
make install