#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de) 
base_path='/work/bb1005/b381361/my_experiments'
exp="ac3_arctic"
years=(2017)


var1=OC_AS
var2=OC_KS
var3=OC_KI
var=OA
for yr in $years; do
list=$(ls -d ${base_path}/${exp}/${exp}*$yr*.01_tracer.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm
fnm1=$(echo ${i} | cut -c1-67 )

plev=$(awk '{print $3","}' pres.txt)
cdo selname,geosp,aps,lsp,gboxarea $i tmp0.nc

cdo setrtoc,-1.e99,0,0 ${i} tmpnonzeros.nc
cdo expr,OC_tot=OC_AS+OC_KS+OC_KI+POL_AS+PRO_AS+LIP_AS tmpnonzeros.nc tmpsumoc.nc
cdo expr,MOA_tot=POL_AS+PRO_AS+LIP_AS tmpnonzeros.nc tmpsummoa.nc
cdo selname,rhoam1 ${fnm1}_vphysc.nc tmpdens.nc
cdo merge tmpsumoc.nc tmpsummoa.nc tmpmix.nc

cdo expr,ratio_MOA_OC=MOA_tot/OC_tot tmpmix.nc tmpratio.nc
cdo setunit,'kg/m3' -setcode,157 -selname,ratio_MOA_OC tmpratio.nc tmp1.nc
cdo merge tmp0.nc tmp1.nc tmp2.nc

# interpolation to pressure levels from file pres.txt
#   TYPE=30 CODE=157 LEVEL=100000,99000,98000,97000,96000,95000,94000,92500,90000,87500,85000,82500,80000,75000,72500,70000,65000,60000,50000,40000,30000,20000,10000,5000,2500,1000
cdo after tmp2.nc ${fnm}_ratio_MOA_OC_plev.nc << EON
    TYPE=30 CODE=157  LEVEL=${plev}  
EON

rm tmp*.nc
done
done
