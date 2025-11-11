#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de) 
base_path='/work/bb1005/b381361/my_experiments'
exp="ac3_arctic"
years=("2016")

for yr in $years; do
list=$(ls -d ${base_path}/${exp}/${exp}*.01_echam.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm

fnm1=$(echo ${i} | cut -c1-67 )
plev=$(awk '{print $3","}' pres.txt)

# interpolation to pressure levels from file pres.txt
cdo after ${i} tmp16.nc << EON
   TYPE=30 LEVEL=${plev}
  
EON
cdo selname,st,siced tmp16.nc ${fnm}_atmos_plev.nc

done
done
