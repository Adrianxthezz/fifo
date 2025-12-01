set DESIGN_REF_PATH "/opt/pdk/sky130"
set MW_REFERENCE_LIB_DIRS  " \
       ${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/mw/sky130_fd_sc_hd
       " 
set NDM_REFERENCE_LIB_DIRS  " \
       ${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/ndm/sky130_fd_sc_hd.ndm
       " 
#${DESIGN_REF_PATH}/techNDM/v10_0_2/xh018-synopsys-techNDM-v10_0_2
set TECH_FILE        "${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/tech/milkyway/sky130_fd_sc_hd.tf"
set MAP_FILE         "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.mw2itf.map"
set TLUPLUS_MAX_FILE "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.nominal.tluplus"
set TLUPLUS_MIN_FILE "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.nominal.tluplus"

set MW_POWER_NET                "VDD" ;#
set MW_POWER_PORT               "VDD" ;#
set MW_GROUND_NET               "VSS" ;#
set MW_GROUND_PORT              "VSS" ;#

set MIN_ROUTING_LAYER            "met2"   ;# Min routing layer
set MAX_ROUTING_LAYER            "met5"   ;# Max routing layer

set LIBRARY_FILES "${NDM_REFERENCE_LIB_DIRS}"
lappend search_path "${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/db_nldm"

set_host_options -max_cores 4
set ndm_reference_library ${NDM_REFERENCE_LIB_DIRS}
set ndm_design_library lib_icc2
