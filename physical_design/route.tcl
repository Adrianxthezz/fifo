define_antenna_rule [current_lib] -name antenna_r1 -mode 1 -diode_mode 1 -metal_nratio 1000 -metal_pratio 1000 -cut_ratio 0

route_auto -save_after_global_route true -save_after_track_assignment true -save_after_detail_route true
route_opt

redirect -file ${REPORTS_DIR}/PRO.timing.rpt {report_timing -nets -capacitance -attributes -physical -nosplit}
redirect -file ${REPORTS_DIR}/PRO.qor.rpt {report_qor}
redirect -file ${REPORTS_DIR}/PRO.congestion.rpt {report_congestion -mode summary}
redirect -file ${REPORTS_DIR}/PRO.power.rpt {report_power}
