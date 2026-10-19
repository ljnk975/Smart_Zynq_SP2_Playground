set proj_name [get_property NAME [current_project]]

reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
write_hw_platform -fixed -include_bit -force -file $proj_name.xsa
