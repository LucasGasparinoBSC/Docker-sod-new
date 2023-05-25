#!/bin/bash

# Get openMPI 4.1.5
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz

# Untar annd configure
tar -xvf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5
CC=gcc-12 CXX=g++-12 FC=gfortran-12 ./configure --prefix=/home/Apps/Compilers/gnu/12.3.0/openmpi/4.1.5
make -j 12
make install

# Cleanup
cd ..
rm -rf openmpi-4.1.5.tar.gz openmpi-4.1.5