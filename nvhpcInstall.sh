#!/bin/bash

## Set the appropriate environment variables for installing NVHPC
export NVHPC_INSTALL_DIR=/home/Apps/Compilers/nvidia/hpc_sdk
export NVHPC_SILENT="true"
export NVHPC_INSTALL_TYPE="single"

## Download the nvhpc installer
#wget https://developer.download.nvidia.com/hpc-sdk/23.3/nvhpc_2023_233_Linux_x86_64_cuda_multi.tar.gz
wget https://developer.download.nvidia.com/hpc-sdk/23.9/nvhpc_2023_239_Linux_x86_64_cuda_12.2.tar.gz

#tar -xvf nvhpc_2023_233_Linux_x86_64_cuda_multi.tar.gz
tar -xvf nvhpc_2023_239_Linux_x86_64_cuda_12.2.tar.gz

## Run the installer
#/home/Apps/Compilers/nvidia/nvhpc_2023_233_Linux_x86_64_cuda_multi/install
/home/Apps/Compilers/nvidia/nvhpc_2023_239_Linux_x86_64_cuda_12.2/install

## Cleanup
rm -rf *.tar.gz nvhpc_2023_239_Linux_x86_64_*