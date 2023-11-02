#!/bin/bash

##export CC=gcc
##export CXX=g++
##export NO_CHECKS=1 # skip build checks
##smart build --device cpu --no_pt
##pip install smartredis

mkdir -p smartredis/0.4.0/gcc
cd smartredis/0.4.0/gcc
git clone https://github.com/CrayLabs/SmartRedis.git --depth=1 --branch v0.4.0
cd SmartRedis
CC=/home/Apps/GCC12/gcc CXX=/home/Apps/GCC12/g++ FC=/home/Apps/GCC12/gfortran make lib-with-fortran