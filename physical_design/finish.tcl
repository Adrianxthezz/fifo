set DECAP_CELLS [get_object_name [sort_collection -descending [get_lib_cells */*_decap_*] area ] ]
set FILLER_CELLS [get_object_name [sort_collection -descending [get_lib_cells */* -filter "design_type==filler"] area ] ]

create_stdcell_fillers -lib_cells $DECAP_CELLS
create_stdcell_fillers -lib_cells $FILLER_CELLS

redirect -file ${REPORTS_DIR}/chip_finish.connect_pg.rpt {connect_pg_net -auto -verbose}

# Reroute for yield opt, minimize wire length and via count
optimize_routes -reroute_all_shapes_in_nets true

# Route detail for DRC convergence
route_detail -incremental true -max_number_iterations 50 
check_lvs -max_errors 1000
