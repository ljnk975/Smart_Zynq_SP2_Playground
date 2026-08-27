FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://xilinx_gmii2xgmii.cfg \
            file://st7789.cfg \
            file://framebuffer.cfg \
            file://logo.cfg \
            "
