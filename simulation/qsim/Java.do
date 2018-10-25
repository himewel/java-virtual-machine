onerror {quit -f}
vlib work
vlog -work work Java.vo
vlog -work work Java.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Stack_vlg_vec_tst
vcd file -direction Java.msim.vcd
vcd add -internal Stack_vlg_vec_tst/*
vcd add -internal Stack_vlg_vec_tst/i1/*
add wave /*
run -all
