#!/bin/bash

## Download the Basekit and HPC packages
#wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/7deeaac4-f605-4bcf-a81b-ea7531577c61/l_BaseKit_p_2023.1.0.46401.sh
#wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/1ff1b38a-8218-4c53-9956-f0b264de35a4/l_HPCKit_p_2023.1.0.46346.sh

wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/96aa5993-5b22-4a9b-91ab-da679f422594/intel-oneapi-base-toolkit-2025.0.0.885_offline.sh
wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/0884ef13-20f3-41d3-baa2-362fc31de8eb/intel-oneapi-hpc-toolkit-2025.0.0.825_offline.sh

## Install the Basekit
#sh l_BaseKit_p_2023.1.0.46401.sh -a --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi --components intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.mkl.devel:intel.oneapi.lin.tbb.devel
sh intel-oneapi-base-toolkit-2025.0.0.885_offline.sh -a --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi --components intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.mkl.devel:intel.oneapi.lin.tbb.devel

## Install the HPC kit
#sh l_HPCKit_p_2023.1.0.46346.sh -a --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi --components intel.oneapi.lin.mpi.devel:intel.oneapi.lin.dpcpp-cpp-compiler-pro:intel.oneapi.lin.ifort-compiler
sh intel-oneapi-hpc-toolkit-2025.0.0.825_offline.sh -a --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi
## Generate the modulefiles
/home/Apps/Compilers/intel/oneapi/modulefiles-setup.sh --output-dir=/home/Apps/Compilers/modulefiles --ignore-latest --force

## Cleanup
rm -rf *.sh