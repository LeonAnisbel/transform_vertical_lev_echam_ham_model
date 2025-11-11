#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de) 
base_path='/work/bb1005/b381361/my_experiments'
exp="echam_base"
years=("2017")


var1="SS_AS"
var2="SS_CS"
var="SS"
for yr in $years; do
list=$(ls -d ${base_path}/${exp}/${exp}*${yr}*.01_tracer.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm

fnm1=$(echo ${i} | cut -c1-67 )

fnm2=$(echo ${i} | cut -c31-57 )
plev=$(awk '{print $3","}' pres.txt)
cdo selname,geosp,aps,lsp,gboxarea $i tmp0.nc

cdo setrtoc,-1.e99,0,0 ${i} tmpnonzeros.nc
cdo expr,SS_tot=SS_AS+SS_CS tmpnonzeros.nc tmpsum.nc
cdo selname,rhoam1 ${fnm1}_vphysc.nc tmpdens.nc
cdo merge tmpsum.nc tmpdens.nc tmpmix.nc

cdo expr,SS=SS_tot*rhoam1 tmpmix.nc tmpSS.nc
cdo setunit,'kg/m3' -setcode,157 -selname,SS tmpSS.nc tmp1.nc
cdo merge tmp0.nc tmp1.nc tmp2.nc

# interpolation to pressure levels from file pres.txt
cdo after tmp2.nc ${fnm}_${var}_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
  
EON

rm tmp*.nc
done
done
