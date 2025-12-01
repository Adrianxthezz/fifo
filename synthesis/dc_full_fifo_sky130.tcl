#----------------------------------------------------------------
# Search Path and Logic Library Setup
#----------------------------------------------------------------
set_app_var search_path "$search_path . ../rtl /opt/pdk/sky130/lib/sky130_fd_sc_hd/db_nldm"
set_app_var target_library "sky130_fd_sc_hd__tt_025C_1v80.db"
                            #sky130_fd_sc_hd__ff_100C_1v65.db\
                            #sky130_fd_sc_hd__ss_n40C_1v28.db\
                            #sky130_fd_sc_hd__ff_100C_1v95.db\
                            #sky130_fd_sc_hd__ss_n40C_1v35.db\
                            #sky130_fd_sc_hd__ff_n40C_1v56.db\
                            #sky130_fd_sc_hd__ss_n40C_1v40.db\
                            #sky130_fd_sc_hd__ff_n40C_1v65.db\
                            #sky130_fd_sc_hd__ss_n40C_1v44.db\
                            #sky130_fd_sc_hd__ff_n40C_1v76.db\
                            #sky130_fd_sc_hd__ss_n40C_1v76.db\
                            #sky130_fd_sc_hd__ss_100C_1v40.db\
                            #sky130_fd_sc_hd__tt_025C_1v80.db\
                            #sky130_fd_sc_hd__ss_100C_1v60.db\
                            #sky130_fd_sc_hd__tt_100C_1v80.db\

set_app_var link_library "* $target_library" 

#----------------------------------------------------------------
# RTL Reading and link
#----------------------------------------------------------------
analyze -format sverilog {fifo.v}

elaborate fifo
link

#----------------------------------------------------------------
# Constraints Setup
#----------------------------------------------------------------
set clk_val 10
create_clock -period [expr $clk_val] [get_ports clk_i]
set_clock_uncertainty -setup [expr $clk_val*0.1] [get_clocks clk_i]
set_clock_transition -max [expr $clk_val*0.1] [get_clocks  clk_i]
set_clock_latency -source -max [expr $clk_val*0.05] [get_clocks clk_i]
set_clock_latency -max [expr $clk_val*0.03] [get_clocks clk_i]
set_input_delay -max [expr $clk_val*0.05] -clock clk_i [remove_from_collection [all_inputs] clk_i]
set_input_delay -min [expr $clk_val*0.01] -clock clk_i [remove_from_collection [all_inputs] clk_i]
set_output_delay -max [expr $clk_val*0.05] -clock clk_i [all_outputs]
set_load -max [expr {40.0/1000.0}] [all_outputs]
set_input_transition -min [expr $clk_val*0.01] [remove_from_collection [all_inputs] clk_i]
set_input_transition -max [expr $clk_val*0.1] [remove_from_collection [all_inputs] clk_i]

#----------------------------------------------------------------
# Pre-compile Reports
#----------------------------------------------------------------
report_clock > reports/report_clock_fullsky130.rpt
report_clock -skew > reports/report_clock_fullsky130.rpt
report_port -verbose > reports/report_port_fullsky130.rpt


#----------------------------------------------------------------
# Compile - synthesis 
#----------------------------------------------------------------

compile_ultra -no_autoungroup -incremental 
optimize_netlist -area 

#----------------------------------------------------------------
# Post-compile Reports
#----------------------------------------------------------------
report_area > reports/report_area_sky130.rpt
report_qor > reports/report_qor_sky130.rpt
report_constraints -all_violators > reports/report_constraints_sky130.rpt
report_timing > reports/report_timing_sky130.rpt
report_power > reports/report_power_sky130.rpt
check_timing
check_design

#----------------------------------------------------------------
# Save Design
#----------------------------------------------------------------

write_file -format verilog -hier -out outputs/mapped_fifo_sky130.v
write_file -format ddc -hier -out outputs/mapped_fifo_sky130.ddc
write_sdc ../constraints/mapped_fifo_sky130.sdc
# Exit
return
exit
