#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de) 
base_path='/work/bb1005/b381361/my_experiments'
exp="ac3_arctic"

var="SS_AS"


list=$(ls -d ${base_path}/${exp}/${exp}*.01_tracer.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm

fnm1=$(echo ${i} | cut -c1-67 )


cdo selname,geosp,aps,gboxarea $i tmp0.nc

#cdo setrtoc,-1.e99,0,0 ${i} tmpnonzeros.nc
#cdo expr,SS_mass=${var} tmpnonzeros.nc tmpsum.nc
cdo selname,${var} -sellevel,46 ${i} tmpconc.nc

cdo selname,rhoam1 -sellevel,46 ${fnm1}_vphysc.nc tmpdens.nc
cdo merge tmpconc.nc tmpdens.nc tmpmix.nc

cdo expr,SS_AS=${var}*rhoam1 tmpmix.nc tmpSS.nc
cdo setunit,'kg/m3' -selname,SS_AS tmpSS.nc tmp1.nc
cdo merge tmp0.nc tmp1.nc tmp2.nc

# interpolation to pressure levels from file pres.txt
cdo remapcon,t63grid tmp2.nc ${fnm}_${var}_t63.nc

rm tmp*.nc
done
	
