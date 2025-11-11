#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) 
base_path='/scratch/b/b381361'
exp="ac3_arctic"
years=(2018)







list=$(ls -d ${base_path}/${exp}/${exp}*.01_tracer.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm
fnm1=$(echo ${i} | cut -c1-50 )


fnm2=$(echo ${i} | cut -c31-57 )
plev=$(awk '{print $3","}' pres.txt)



mv ${fnm}_OC_plev.nc ${fnm}_OA_plev.nc









  



done

