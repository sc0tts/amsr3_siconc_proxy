#!/bin/bash
#
# run_amsr3_proxy_nh.sh
#
# Generate some sample amsr3_proxy data
# Northern Hemisphere
# Day: 2025-02-01 (see swath_list_file name)

set -e

config_file=./amsr3_siconc_proxy/config/am2mbt_e2n10_config.yaml
swath_list_file=./amsr3_proxy_data/amsr3proxy20250201.txt
bt_param_file=./amsr3_siconc_proxy/config/btparams_nam2sic_nh.yaml

# Set true/false for skipping steps
# ...mostly for saving time during development

do_process_swathfiles=true
#do_process_swathfiles=false

do_overlay_gridded_swaths=true
#do_overlay_gridded_swaths=false

do_compute_siconc=true
#do_compute_siconc=false


if [ "$do_process_swathfiles" == "true" ]; then
  for swath_file in $(cat ${swath_list_file}); do
    echo "Processing swath file: ${swath_file}"
  
    # Generate the intermediate TB files -- swath TBs gridded
    python ./amsr3_siconc_proxy/src/amsr3_siconc_proxy/grid_am2mbt.py ${swath_file} ${config_file}
  done
else
  echo "Skipping the processing of the swath files..."
fi

# Stack the gridded files
if [ "$do_overlay_gridded_swaths" == "true" ]; then
  python ./amsr3_siconc_proxy/src/amsr3_siconc_proxy/overlay_gridded.py ${swath_list_file} ${config_file}
else
  echo "Skipping the overlaying of the gridded files..."
fi

# Generate the siconc for this swath set
if [ "$do_compute_siconc" == "true" ]; then
  python ./amsr3_siconc_proxy/src/amsr3_siconc_proxy/compute_nam2_siconc.py ${swath_list_file} ${config_file} ${bt_param_file}
else
  echo "Skipping the computation of the siconc..."
fi
