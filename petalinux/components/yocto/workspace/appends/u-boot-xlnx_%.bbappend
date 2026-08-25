FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESPATH:prepend := "${FPGA_PROJECT_ROOT}/software/u-boot-xlnx/oe-local-files:"

inherit externalsrc
# NOTE: We use pn- overrides here to avoid affecting multiple variants in the case where the recipe uses BBCLASSEXTEND
EXTERNALSRC:pn-u-boot-xlnx = "${FPGA_PROJECT_ROOT}/software/u-boot-xlnx"

do_configure:append() {
    if [ ${@oe.types.boolean(d.getVar("KCONFIG_CONFIG_ENABLE_MENUCONFIG"))} = True ]; then
        cp ${KCONFIG_CONFIG_ROOTDIR}/.config ${S}/.config.baseline
        ln -sfT ${KCONFIG_CONFIG_ROOTDIR}/.config ${S}/.config.new
    fi
}
