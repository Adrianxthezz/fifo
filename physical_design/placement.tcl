set_app_options -name place.coarse.continue_on_missing_scandef -value true

# Your design needs to change the congestion effort? Please try...

#set_app_options -name place_opt.place.congestion_effort -value high

redirect -file ${REPORTS_DIR}/DP.check_design.rpt -tee {check_design -checks pre_placement_stage}

place_opt

redirect -file ${REPORTS_DIR}/PO.timing.rpt {report_timing -nets -capacitance -attributes -physical -nosplit}
redirect -file ${REPORTS_DIR}/PO.qor.rpt {report_qor}
redirect -file ${REPORTS_DIR}/PO.congestion.rpt {report_congestion -mode summary}
