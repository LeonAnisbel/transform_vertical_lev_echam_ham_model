#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de) 
base_path='/work/bb1005/b381361/my_experiments'
exp="ac3_arctic"
years=('2016' '2017' '2018')

var='m_radius'
for yr in "${years[@]}"
do
list=$(ls -d ${base_path}/${exp}/${exp}*$yr*.01_ham.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm
fnm1=$(echo ${i} | cut -c1-50 )
fnm1=$(echo ${i} | cut -c1-67 )

fnm2=$(echo ${i} | cut -c31-57 )
plev=$(awk '{print $3","}' pres.txt)
cdo selname,geosp,aps,lsp,gboxarea $i tmp0.nc

cdo setrtoc,-1.e99,0,0 ${i} tmpnonzeros.nc

cdo expr,rwet_AS=rwet_AS tmpnonzeros.nc tmpsum_AS.nc
cdo expr,rdry_AI=rdry_AI tmpnonzeros.nc tmpsum_AI.nc


cdo expr,rwet_KS=rwet_KS tmpnonzeros.nc tmpsum_KS.nc
cdo expr,rdry_KI=rdry_KI tmpnonzeros.nc tmpsum_KI.nc


cdo expr,rwet_CS=rwet_CS tmpnonzeros.nc tmpsum_CS.nc
cdo expr,rdry_CI=rdry_CI tmpnonzeros.nc tmpsum_CI.nc


cdo expr,rwet_NUC=rwet_NS tmpnonzeros.nc tmpsum_N.nc

cdo merge tmpsum_AS.nc tmpsum_AI.nc tmpsum_KS.nc tmpsum_KI.nc tmpsum_CS.nc tmpsum_CI.nc tmpsum_N.nc tmpmix.nc

cdo  -selname,rwet_AS tmpmix.nc tmpAS.nc
cdo setunit,'m' -setcode,157 -selname,rwet_AS tmpAS.nc tmpAS1.nc
cdo merge tmp0.nc tmpAS1.nc tmpAS2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpAS2.nc ${fnm}_${var}_AS_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

cdo  -selname,rdry_AI tmpmix.nc tmpAI.nc
cdo setunit,'m' -setcode,157 -selname,rdry_AI tmpAI.nc tmpAI1.nc
cdo merge tmp0.nc tmpAI1.nc tmpAI2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpAI2.nc ${fnm}_${var}_AI_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON




cdo -selname,rwet_KS tmpmix.nc tmpKS.nc
cdo setunit,'m' -setcode,157 -selname,rwet_KS tmpKS.nc tmpKS1.nc
cdo merge tmp0.nc tmpKS1.nc tmpKS2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpKS2.nc ${fnm}_${var}_KS_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

cdo -selname,rdry_KI tmpmix.nc tmpKI.nc
cdo setunit,'m' -setcode,157 -selname,rdry_KI tmpKI.nc tmpKI1.nc
cdo merge tmp0.nc tmpKI1.nc tmpKI2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpKI2.nc ${fnm}_${var}_KI_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON



cdo -selname,rwet_CS tmpmix.nc tmpCS.nc
cdo setunit,'m' -setcode,157 -selname,rwet_CS tmpCS.nc tmpCS1.nc
cdo merge tmp0.nc tmpCS1.nc tmpCS2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpCS2.nc ${fnm}_${var}_CS_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

cdo -selname,rdry_CI tmpmix.nc tmpCI.nc
cdo setunit,'m' -setcode,157 -selname,rdry_CI tmpCI.nc tmpCI1.nc
cdo merge tmp0.nc tmpCI1.nc tmpCI2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpCI2.nc ${fnm}_${var}_CI_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON


cdo -selname,rwet_NUC tmpmix.nc tmpN.nc
cdo setunit,'m' -setcode,157 -selname,rwet_NUC tmpN.nc tmpN1.nc
cdo merge tmp0.nc tmpN1.nc tmpN2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpN2.nc ${fnm}_${var}_NUC_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

rm tmp*.nc
done
done
