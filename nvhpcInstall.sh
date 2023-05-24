#!/bin/bash

## Set the appropriate environment variables for installing NVHPC
export NVHPC_INSTALL_DIR=/home/Apps/Compilers/nvidia/hpc_sdk
export NVHPC_SILENT="true"
export NVHPC_INSTALL_TYPE="single"

## Download the nvhpc installer
wget https://developer.download.nvidia.com/hpc-sdk/23.3/nvhpc_2023_233_Linux_x86_64_cuda_multi.tar.gz
tar -xvf nvhpc_2023_233_Linux_x86_64_cuda_12.0.tar.gz

## Run the installer
/home/Apps/Compilers/nvidia/nvhpc_2023_233_Linux_x86_64_cuda_muulti/install

## Cleanup
rm -rf nvhpc_2023_233_Linux_x86_64_cuda_12.0.tar.gz nvhpc_2023_233_Linux_x86_64_cuda_multi *.tar.gz