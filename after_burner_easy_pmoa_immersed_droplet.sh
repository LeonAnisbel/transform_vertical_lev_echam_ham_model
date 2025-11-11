#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de) 
base_path='/work/bb1178/b324073'
exp="ac3_arctic"


years=('201609')
# '2017' '2018')
#for yr in "${years[@]}"
#do
#list=$(ls -d ${base_path}/${exp}/${exp}*$yr*.01_ham.nc)
#list=$(ls -d /scratch/b/b381361/${exp}/${exp}*$yr*.01_ham.nc)
list=$(ls -d ${base_path}/${exp}/${exp}*.01_ham.nc)
echo $list
for i in $list; do

fnm="${i%_*}"
echo $fnm
#fnm1=$(echo ${i} | cut -c1-50 )
fnm1=$(echo ${i} | cut -c1-67 )

fnm2=$(echo ${i} | cut -c33-49 )


#fnm2=$(echo ${i} | cut -c34-56 )
echo $fnm1
echo $fnm2
plev=$(awk '{print $3","}' pres.txt)

cdo selname,geosp,aps,lsp,gboxarea $i tmp0.nc

#cdo setrtoc,-1.e99,0,0 ${i} tmpnonzeros.nc
cdo expr,pmoa_immerse=NMOASOL_STRAT_A+NMOASOL_STRAT_C ${i} tmpsum.nc
cdo selname,rhoam1 ${fnm}_vphysc.nc tmpdens.nc
cdo merge tmpsum.nc tmpdens.nc tmpmix.nc

cdo -selname,pmoa_immerse tmpmix.nc tmpOA.nc
cdo setunit,'m-3' -setcode,157 -selname,pmoa_immerse tmpOA.nc tmp1.nc
cdo merge tmp0.nc tmp1.nc tmp2.nc
#cdo sp2gpl tmp2.nc tmp3.nc
# interpolation to pressure levels from file pres.txt
cdo after tmp2.nc ${fnm2}_pmoa_immerse_plev.nc << EON
        TYPE=30 CODE=157  LEVEL=${plev}  
EON

#cdo -R remapcon,t63grid ${fnm2}_pmoa_immerse_plev.nc ${fnm2}_pmoa_immerse_plev_t63.nc

rm tmp*.nc
done
#done
