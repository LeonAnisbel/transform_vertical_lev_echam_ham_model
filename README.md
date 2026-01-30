# transform_vertical_lev_echam_ham_model
> The bash scripts transform the vertical model levels from ECHAM6.3-HAM2.3 model to pressure levels.\
> The aerosol-climate model output is archived on Levante HPC system.\
> They are used to generate the netcdf files for the comparison to aerosol aircraft meassurements and cloud analysis.

Use:
* after_burner_easy_num.sh and after_burner_easy_radius.sh for the number concentration analysis (ATom_number_concentration_evaluation project) when considering marine organic aerosol
  
* after_burner_easy_moa_conc.sh and after_burner_easy_oa_mass.sh for the mass concentration analysis (ATom_mass_concentration_evaluation project) when considering marine organic aerosol
  
* bash_scripts_echam_base_exp_no_MOA.tar.gz contains the same scripts for the simulation experiment without marine organic aerosol
  
* *immersed_droplet.sh for the immersed aerosol in cloud droplets and after_burner_easy_temperature.sh for tempererature (offline_INP_concentration project)
