###############################################################################
# Design Planning
# Floorplan:
################################################################################

set_attribute -name routing_direction [get_layer li1 ] -value  vertical 
set_attribute -name routing_direction [get_layer met1] -value  horizontal 
set_attribute -name routing_direction [get_layer met2] -value  vertical 
set_attribute -name routing_direction [get_layer met3] -value  horizontal 
set_attribute -name routing_direction [get_layer met4] -value  vertical 
set_attribute -name routing_direction [get_layer met5] -value  horizontal 

initialize_floorplan -core_utilization 0.7 -core_shape R -orientation N  -core_side_ratio {1.0 1.0}  -core_offset {2} -flip_first_row true  -coincident_boundary true

set ROUTING_LAYER_DIRECTION_OFFSET_LIST "{li1  vertical  0 3.40 1.60 3.40}
                                         {met1 horizontal 0 0.34 0.14 0.34} \
                                         {met2 vertical   0 0.46 0.14 0.46} \
                                         {met3 horizontal 0 0.68 0.30 0.68} \
                                         {met4 vertical   0 0.92 0.30 0.92} \
                                         {met5 horizontal 0 3.40 1.60 3.40}" ;
remove_tracks -all
foreach direction_offset_pair $ROUTING_LAYER_DIRECTION_OFFSET_LIST {
    set layer [lindex $direction_offset_pair 0]
    set offset [lindex $direction_offset_pair 2]
    set pitch [lindex $direction_offset_pair 3]
    if {[lindex $direction_offset_pair 1] == "horizontal" } \
    {set GridDirection "Y"} else { set GridDirection "X"}
    create_track -layer $layer -space $pitch -dir $GridDirection -coord $offset
}

set_ignored_layers -min_routing_layer met1
set_block_pin_constraints -self -allowed_layers {met2 met3 met4 met5}
place_pins  -self

create_tap_cells \
	-lib_cell sky130_fd_sc_hd/sky130_fd_sc_hd__tap_1 \
	-pattern stagger \
	-distance 25 

set_app_options -name plan.place.place_inside_blocks -value true
set_app_options -name place.fix_hard_macros -value false
set_app_options -name plan.place.auto_generate_blockages -value true
create_placement -effort low  -floorplan

#width:3pitch:10
create_pg_mesh_pattern pg_mesh1 -layers {{{horizontal_layer: met3 met5} {width: 1} {spacing: 1} {pitch: 10} {trim: true} }} -via_rule {} 
create_pg_mesh_pattern pg_mesh2 -layers {{{vertical_layer: met2 met4} {width: 1} {spacing: 1} {pitch: 10} {trim: true} }} -via_rule {}

create_pg_std_cell_conn_pattern std_pattern_1 -layers {met1}

set_pg_strategy  pg_strategy1  -core  -pattern {{pattern: pg_mesh1}{nets: {VSS VDD }} }
set_pg_strategy  pg_strategy2  -core  -pattern {{pattern: pg_mesh2}{nets: {VSS VDD }} }
set_pg_strategy  pg_std_cell -core  -pattern {{pattern: std_pattern_1 }{nets: {VSS VDD}} }

set_app_options -name plan.pgroute.ignore_signal_route -value true
compile_pg
set_app_options -name plan.pins.incremental -value false -block [current_block]
set_app_options -name plan.pins.layer_range -value 2 -block [current_block]
set_app_options -name plan.pins.pin_range -value 10 -block [current_block]
write_floorplan -output ./floorplan -format icc -force -nosplit  -include { die_area  rows  tracks  vias  nets  cells  macros  \
pin_guides  pins  route_guides  blockages  voltage_areas  bounds  corridors  io_guides  edit_groups  module_boundaries  }
