#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/nacl_prod.py > nacl_prod.py

## uncomment the following code when HDF5 framework is off ##
# ln -sv $WEST_SIM_ROOT/common_files/bstate.pdb .

# if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
#   ln -sv $WEST_PARENT_DATA_REF/seg.xml ./parent.xml
# elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
#   ln -sv $WEST_PARENT_DATA_REF/basis.xml ./parent.xml
# fi

# Run the dynamics with OpenMM
python nacl_prod.py

#Calculate pcoord with MDAnalysis
python $WEST_SIM_ROOT/common_files/get_distance.py
cat dist.dat > $WEST_PCOORD_RETURN

python $WEST_SIM_ROOT/common_files/get_coord.py
cp coord.npy $WEST_COORD_RETURN
#cat coord.pdb | grep 'ATOM' | awk '{print $7, $8, $9}' > $WEST_COORD_RETURN

cp bstate.pdb $WEST_TRAJECTORY_RETURN
cp seg.dcd $WEST_TRAJECTORY_RETURN

cp bstate.pdb $WEST_RESTART_RETURN
cp seg.xml $WEST_RESTART_RETURN/parent.xml

cp seg.log $WEST_LOG_RETURN

# Clean up
rm -f dist.dat nacl_prod.py coord.dat
