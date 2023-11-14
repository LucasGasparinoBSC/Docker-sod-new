#!/bin/bash

##export CC=gcc
##export CXX=g++
##export NO_CHECKS=1 # skip build checks
##smart build --device cpu --no_pt
##pip install smartredis

## First need to make sure the NVHPPC modules are loaded
source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module load nvhpc-hpcx-cuda12/23.9

mkdir -p smartredis/0.4.0/nvhpc && cd smartredis/0.4.0/nvhpc
git clone https://github.com/ashao/SmartRedis --depth=1 --branch f2003
cd SmartRedis
mkdir build && cd build
rm -rf * && cmake -DSR_PYTHON=ON -DSR_FORTRAN=ON -DCMAKE_CXX_COMPILER=nvc++ -DCMAKE_C_COMPILER=nvc -DCMAKE_Fortran_COMPILER=nvfortran -DCMAKE_INSTALL_PREFIX=/home/Apps/Libraries/SmartRedis/0.4.0/NVHPC/23.9 ..
make -j 12
make install