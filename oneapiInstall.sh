#!/bin/bash

## Download the Basekit and HPC packages
wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/7deeaac4-f605-4bcf-a81b-ea7531577c61/l_BaseKit_p_2023.1.0.46401.sh
wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/1ff1b38a-8218-4c53-9956-f0b264de35a4/l_HPCKit_p_2023.1.0.46346.sh

## Install the Basekit
sh l_BaseKit_p_2023.1.0.46401.sh -a -c --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi

## Install the HPC kit
sh l_HPCKit_p_2023.1.0.46346.sh -a -c --eula accept -s --install-dir /home/Apps/Compilers/intel/oneapi

## Generate the modulefiles
/home/Apps/Compilers/intel/oneapi/modulefiles-setup.sh --output-dir=/home/Apps/Compilers/modulefiles --ignore-latest --force

## Cleanup
rm -rf l_BaseKit_p_2023.1.0.46401.sh l_HPCKit_p_2023.1.0.46346.sh