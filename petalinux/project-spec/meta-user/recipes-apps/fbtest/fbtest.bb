#
# This file is the fbtest recipe.
#

SUMMARY = "Simple fbtest application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://Makefile \
	   file://common.h \
	   file://common.c \
	   file://font_8x8.c \
	   file://offset.c \
	   file://perf.c \
	   file://rect.c \
	   file://fb-test.c \
		  "

S = "${WORKDIR}"

do_compile() {
	     oe_runmake
}

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 fb-test ${D}${bindir}
}
