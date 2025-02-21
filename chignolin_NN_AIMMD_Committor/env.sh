#!/bin/bash

# Set up environment for dynamics
# source /usr/local/gromacs/bin/GMXRC
conda activate gromacs-pytorch

# Set WESTPA-related variables
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

# Set runtime commands
export GMX=$(which gmx)
