#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de)
base_path="/work/bb1005/b381361/my_experiments"
exp="ac3_arctic"
liste=$(ls -d ${base_path}/${exp}/1990-2019/${exp}_*.01_echam.nc)
data_dir=${base_path}/${exp}/1990-2019/

rm tmp_*
for i in $liste
do
fnm="${i%_*}"
#dat=$(echo $fnm | cut -b 67-72)
dat=$(echo $fnm | cut -b 58-77)
echo $fnm $dat


#cdo after $i tmp0.nc << EON
#   TYPE=30
#EON

#cdo selname,tsw,wind10,seaice tmp0.nc ${data_dir}${dat}_echam_regular_grid.nc 

cdo -setctomiss,0 $i ${data_dir}${dat}_echam_nan.nc 
done
