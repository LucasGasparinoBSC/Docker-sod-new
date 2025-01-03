#!/bin/bash

## Set the appropriate environment variables for installing NVHPC
export NVHPC_INSTALL_DIR=/home/Apps/Compilers/nvidia/hpc_sdk
export NVHPC_SILENT="true"
export NVHPC_INSTALL_TYPE="single"

## Download the nvhpc installer
wget https://developer.download.nvidia.com/hpc-sdk/24.11/nvhpc_2024_2411_Linux_x86_64_cuda_12.6.tar.gz

tar xpzf nvhpc_2024_2411_Linux_x86_64_cuda_12.6.tar.gz

## Run the installer
/home/Apps/Compilers/nvidia/nvhpc_2024_2411_Linux_x86_64_cuda_12.6/install

## Cleanup
rm -rf *.tar.gz nvhpc_2024_2411_Linux_x86_64_cuda_12.6