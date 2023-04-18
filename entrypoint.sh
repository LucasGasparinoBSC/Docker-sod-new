#!/bin/bash
echo "Setting up env-modules..."
source /home/Apps/Modules/5.2.0/init/profile.sh
module use /home/Apps/Compilers/modulefiles
module use /home/Apps/Libraries/modulefiles
echo "All done!"
/bin/bash