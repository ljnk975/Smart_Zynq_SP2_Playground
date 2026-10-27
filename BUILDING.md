
# Project structure

- bd: Vivado block design and wrapper RTL
- constrs: Vivado constraints
- petalinux: Petalinux config files
- scripts: Script files
- software: Uboot/Linux source code
- sources: Vivado RTL files
- third_party: External RTL and IP
- WORK: Vivado/Petalinux working folder

# Main flow

## Init vivado project:

```
make vivado-init
```

This will create vivado project, import block design file.

**NOTE: This command will erase current existing WORK/Vivado project and reinit one.**

## Build vivado project:

```
make vivado-build
```

This command will make vivado project, export xsa file for Petalinux.

## Init petalinux project:

```
make petalinux-init
```

This command will create petalinux project, import config file from petalinux/ folder

**NOTE: This command will erase current existing WORK/Petalinux project and reinit one.**

## Update petalinux hardware:

```
make petalinux-update-hardware
```

This command will update Vivado xsa file to Petalinux project.

## Build petalinux project:

```
make petalinux-build
```

This command will build Petalinux project, create SD image and prebuilt image for JTAG boot.

# JTAG boot flow

## Init Vivado hardware server:

```
make vivado-hw_server
```

This command will create hardware server for JATG boot up.

Remember to switch JATG boot and connect the board to Computer.

## Run project over JTAG

```
make petalinux-run
```

This command will download bitstream, uboot, linux, rootfs over JTAG and start boot up.

View console output with picocom:

```
picocom -b 115200 /dev/ttyUSB1
```

Check the right number of ttyUSB on your Computer!

# SD boot flow

## Init SD card:

Follow instruction at http://www.hellofpga.com/index.php/2025/02/23/zynq_creating_sd_card/

## Run project on SD card:

Attach the card, switch to SD boot and power up the board.

# Vivado edit flow

## Open vivado GUI:

```
make vivado-gui
```

This command open Vivado on GUI mode. Enjoy editing your project!

## Export vivado project:

```
make vivado-export
```

This command export project as TCL file scripts/project.tcl and export block design files as TCL files locate on bd/ folder.

## Update vivado design:

Vivado can manage all RTL files, contraints file we used in this project. The only exception is the block design (BD) files.

The vivado-export make target export block design files as TCL files. We can update block design in the project with this:

```
make vivado-import
```

This command read block design TCL files in bd/ folder, and re-create block design in current woking WORK/Vivado project.

**NOTE: this command will delete all block design files in WORK/Vivado project**

# Petalinux edit flow

## Config:

Config petalinux with:

```
make petalinux-config
```

Config uboot with:

```
make petalinux-config-uboot
```

Config kernel with:

```
make petalinux-config-kernel
```

Config rootfs with:

```
make petalinux-config-rootfs
```

Update config:

```
make petalinux-update
```

TODO: export petalinux config

## Update hardware:

Update hardware:

```
make petalinux-update-hardware
```

Rebuild:

```
make petalinux-build
```
