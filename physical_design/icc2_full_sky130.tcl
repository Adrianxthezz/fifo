########################
#.1 Design Library
set REPORTS_DIR "reports"
set INPUTS_DIR "../synthesis/outputs"
set CONSTRAINTS_DIR "../constraints"
set OUTPUTS_DIR "outputs"
source scripts/setup.tcl -echo

sh rm -rf $ndm_design_library  

# Waive some non critical messages
set_msg -limit 1 ZRT-030
suppress_message {TECH-002 TECH-026 TECH-034}
suppress_message {TLUP-011}
suppress_message {ATTR-12}
suppress_message {NDMUI-136}
create_lib -technology $TECH_FILE -ref_libs $LIBRARY_FILES ${ndm_design_library}

########################
#.2 Design Setup
read_verilog ${INPUTS_DIR}/mapped_fifo_sky130.v
########################
# Scenario Setup
create_corner "worst"
read_parasitic_tech  -tlup ${TLUPLUS_MAX_FILE} -layermap ${MAP_FILE} -name maxTLU
set_parasitic_parameters -early_spec maxTLU -late_spec maxTLU -corner "worst"
set_process_label "nominal"
redirect -file ./reports/connect_pg.rpt {connect_pg_net -auto -verbose}
create_mode functional 
create_scenario -mode "functional" -name "functional_worst" -corner worst
report_pvt
set_msg -limit 1 CSTR-021
read_sdc ${CONSTRAINTS_DIR}/mapped_fifo_sky130.sdc


########################
# Floorplan
source scripts/floorplan.tcl -echo
check_physical_constraints
save_block -as floorplan_done


########################
# Placement
source scripts/placement.tcl -echo
save_block -as placement_done

########################
# Clock Tree Synthesis
source scripts/cts.tcl -echo
save_block -as cts_done

########################
# Route

source scripts/route.tcl -echo
save_block -as route_done

########################
# Chip Finish

source scripts/finish.tcl -echo
save_block -as finish_done
