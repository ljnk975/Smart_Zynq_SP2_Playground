set proj_name [get_property NAME [current_project]]

# TODO: write bd tcl, import bd tcl
write_project_tcl -no_ip_version -force $proj_name.tcl
