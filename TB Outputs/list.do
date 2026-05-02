onerror {resume}
add list -width 20 /fsm_tb_sv/dut/clk
add list /fsm_tb_sv/dut/start
add list /fsm_tb_sv/dut/s
add list /fsm_tb_sv/dut/data_in
add list /fsm_tb_sv/dut/done
add list /fsm_tb_sv/dut/data_out
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
