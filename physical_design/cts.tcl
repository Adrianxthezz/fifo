create_routing_rule CLK_NDR -spacings {met1 2 met2 2 met3 2 met4 2}

clock_opt

redirect -file ${REPORTS_DIR}/CO.timing.rpt {report_timing -nets -capacitance -attributes -physical -nosplit}
redirect -file ${REPORTS_DIR}/CO.qor.rpt {report_qor}
redirect -file ${REPORTS_DIR}/CO.congestion.rpt {report_congestion -mode summary}
redirect -file ${REPORTS_DIR}/CO.clock_qor.rpt {report_clock_qor -type summary}
redirect -file ${REPORTS_DIR}/CO.clock_qor_latency.rpt {report_clock_qor -type latency}
