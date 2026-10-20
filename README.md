# Smart-Zynq-SP2 Full Flow Project
This project is a playground for Smart-Zynq-SP2 dev board.

![Smart Zynq SP2](image/board.png)

**Board homepage:** http://www.hellofpga.com/index.php/2024/01/21/smart-zynq-sp2/

This project contains full flow to building hardware and software from Vivado to Petalinux. With integration to Makefile and some necessary scripts, this project allow easy way to maintain and develop.

**Flow has been tested on Vivado 2025.2, PetaLinux 2025.2 on AlmaLinux 9/10.**

## Project structure

- bd: Vivado block design and wrapper RTL
- constrs: Vivado constraints
- petalinux: Petalinux config files
- scripts: Script files
- software: Uboot/Linux source code
- sources: Vivado RTL files
- WORK: Vivado/Petalinux working folder

## Main flow

### Init vivado project:

```
make vivado-init
```

This will create vivado project, import block design file.

**NOTE: This command will erase current existing WORK/Vivado project and reinit one.**

### Build vivado project:

```
make vivado-build
```

This command will make vivado project, export xsa file for Petalinux.

### Init petalinux project:

```
make petalinux-init
```

This command will create petalinux project, import config file from petalinux/ folder

**NOTE: This command will erase current existing WORK/Petalinux project and reinit one.**

### Update petalinux hardware:

```
make petalinux-update-hardware
```

This command will update Vivado xsa file to Petalinux project.

### Build petalinux project:

```
make petalinux-build
```

This command will build Petalinux project, create SD image and prebuilt image for JTAG boot.

## JTAG boot flow

### Init Vivado hardware server:

```
make vivado-hw_server
```

This command will create hardware server for JATG boot up.

Remember to switch JATG boot and connect the board to Computer.

### Run project over JTAG

```
make petalinux-run
```

This command will download bitstream, uboot, linux, rootfs over JTAG and start boot up.

View console output with picocom:

```
picocom -b 115200 /dev/ttyUSB1
```

Check the right number of ttyUSB on your Computer!

## SD boot flow

### Init SD card:

Follow instruction at http://www.hellofpga.com/index.php/2025/02/23/zynq_creating_sd_card/

### Run project on SD card:

Attach the card, switch to SD boot and power up the board.

## Vivado edit flow

### Open vivado GUI:

```
make vivado-gui
```

This command open Vivado on GUI mode. Enjoy editing your project!

### Export vivado project:

```
make vivado-export
```

This command export block design project as TCL file locate on bd/ folder.

### TODO: vivado import bd

## Petalinux edit flow

### Config:

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

### Update hardware:

Update hardware:

```
make petalinux-update-hardware
```

Rebuild:

```
make petalinux-build
```

# Licence and copyright

BSD 3-Clause. Copyright (c) 2026, Van Linh (Ljnk975@gmail.com). See [LICENSE](LICENSE).
