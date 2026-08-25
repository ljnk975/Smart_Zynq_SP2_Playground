FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESPATH:prepend := "${FPGA_PROJECT_ROOT}/software/linux-xlnx/oe-local-files:"

inherit externalsrc
# NOTE: We use pn- overrides here to avoid affecting multiple variants in the case where the recipe uses BBCLASSEXTEND
EXTERNALSRC:pn-linux-xlnx = "${FPGA_PROJECT_ROOT}/software/linux-xlnx"
SRCTREECOVEREDTASKS = "do_validate_branches do_kernel_checkout do_fetch do_unpack do_kernel_configcheck"

do_patch[noexec] = "1"

do_configure:append() {
    cp ${B}/.config ${S}/.config.baseline
    ln -sfT ${B}/.config ${S}/.config.new
}

do_kernel_configme:prepend() {
    if [ -e ${S}/.config ]; then
        mv ${S}/.config ${S}/.config.old
    fi
}

do_configure:append() {
    if [ ${@oe.types.boolean(d.getVar("KCONFIG_CONFIG_ENABLE_MENUCONFIG"))} = True ]; then
        cp ${KCONFIG_CONFIG_ROOTDIR}/.config ${S}/.config.baseline
        ln -sfT ${KCONFIG_CONFIG_ROOTDIR}/.config ${S}/.config.new
    fi
}
