module purge
module load gcc/9.4.0
module load openmpi/4.1.4
module load hdf5/1.12.2

conda create --name sod_drl 
conda activate sod_drl
pip install smartsim

export CC=gcc
export CXX=g++
export NO_CHECKS=1 # skip build checks
smart build --device cpu --no_pt
pip install smartredis

cd ~/Apps
mkdir -p smartredis/0.4.0/gcc
cd smartredis/0.4.1/gcc
git clone https://github.com/CrayLabs/SmartRedis.git --depth=1 --branch v0.4.0 9.4.0
cd 9.4.0
make deps
make lib-with-fortran

conda install mpi4py

