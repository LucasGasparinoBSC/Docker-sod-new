#!/bin/bash

## Set the appropriate environment variables for installing NVHPC
export NVHPC_INSTALL_DIR=/home/Apps/Compilers/nvidia/hpc_sdk
export NVHPC_SILENT="true"
export NVHPC_INSTALL_TYPE="single"

## Run the installer
/home/Apps/Compilers/nvidia/nvhpc_2023_233_Linux_x86_64_cuda_12.0/install