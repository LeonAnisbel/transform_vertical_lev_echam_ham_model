#!/bin/bash
#Main contributions:
#Anisbel Leon (leon@tropos.de) and Bernd Heinold (heinold@tropos.de)
base_path='/work/bb1005/b381361/my_experiments'
exp="ac3_arctic"
years=('2016' '2017' '2018')

var='NUM'
for yr in "${years[@]}"
do
list=$(ls -d ${base_path}/${exp}/${exp}*$yr*.01_tracer.nc)

for i in $list; do

fnm="${i%_*}"
echo $fnm
fnm1=$(echo ${i} | cut -c1-50 )
fnm1=$(echo ${i} | cut -c1-67 )

fnm2=$(echo ${i} | cut -c31-57 )
plev=$(awk '{print $3","}' pres.txt)
cdo selname,geosp,aps,lsp,gboxarea $i tmp0.nc

cdo setrtoc,-1.e99,0,0 ${i} tmpnonzeros.nc

cdo expr,NUM_AS=NUM_AS tmpnonzeros.nc tmpsum_AS.nc
cdo expr,NUM_AI=NUM_AI tmpnonzeros.nc tmpsum_AI.nc


cdo expr,NUM_KS=NUM_KS tmpnonzeros.nc tmpsum_KS.nc
cdo expr,NUM_KI=NUM_KI tmpnonzeros.nc tmpsum_KI.nc


cdo expr,NUM_CS=NUM_CS tmpnonzeros.nc tmpsum_CS.nc
cdo expr,NUM_CI=NUM_CI tmpnonzeros.nc tmpsum_CI.nc


cdo expr,NUM_NUC=NUM_NS tmpnonzeros.nc tmpsum_N.nc

cdo merge tmpsum_AS.nc tmpsum_AI.nc tmpsum_KS.nc tmpsum_KI.nc tmpsum_CS.nc tmpsum_CI.nc tmpsum_N.nc tmpmix.nc

cdo  -mulc,1.2927 -selname,NUM_AS tmpmix.nc tmpAS.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_AS tmpAS.nc tmpAS1.nc
cdo merge tmp0.nc tmpAS1.nc tmpAS2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpAS2.nc ${fnm}_NUM_AS_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

cdo  -mulc,1.2927 -selname,NUM_AI tmpmix.nc tmpAI.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_AI tmpAI.nc tmpAI1.nc
cdo merge tmp0.nc tmpAI1.nc tmpAI2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpAI2.nc ${fnm}_NUM_AI_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON




cdo -mulc,1.2927 -selname,NUM_KS tmpmix.nc tmpKS.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_KS tmpKS.nc tmpKS1.nc
cdo merge tmp0.nc tmpKS1.nc tmpKS2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpKS2.nc ${fnm}_NUM_KS_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

cdo -mulc,1.2927 -selname,NUM_KI tmpmix.nc tmpKI.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_KI tmpKI.nc tmpKI1.nc
cdo merge tmp0.nc tmpKI1.nc tmpKI2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpKI2.nc ${fnm}_NUM_KI_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON



cdo -mulc,1.2927 -selname,NUM_CS tmpmix.nc tmpCS.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_CS tmpCS.nc tmpCS1.nc
cdo merge tmp0.nc tmpCS1.nc tmpCS2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpCS2.nc ${fnm}_NUM_CS_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

cdo -mulc,1.2927 -selname,NUM_CI tmpmix.nc tmpCI.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_CI tmpCI.nc tmpCI1.nc
cdo merge tmp0.nc tmpCI1.nc tmpCI2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpCI2.nc ${fnm}_NUM_CI_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON


cdo -mulc,1.2927 -selname,NUM_NUC tmpmix.nc tmpN.nc
cdo setunit,'m-3' -setcode,157 -selname,NUM_NUC tmpN.nc tmpN1.nc
cdo merge tmp0.nc tmpN1.nc tmpN2.nc
# interpolation to pressure levels from file pres.txt
cdo after tmpN2.nc ${fnm}_NUM_NUC_plev.nc << EON
   TYPE=30 CODE=157  LEVEL=${plev}
EON

rm tmp*.nc
done
done
