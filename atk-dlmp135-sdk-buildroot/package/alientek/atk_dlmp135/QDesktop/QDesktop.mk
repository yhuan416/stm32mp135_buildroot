###############################################################################
#
# QDesktop
#
################################################################################

QDESKTOP_VERSION = 1.0
QDESKTOP_SITE = $(TOPDIR)/package/alientek/atk_dlmp135/QDesktop/src
QDESKTOP_SITE_METHOD = local

QDESKTOP_LICENSE = Apache V2.0
QDESKTOP_LICENSE_FILES = NOTICE
QDESKTOP_DEPENDENCIES += qt5base qt5declarative qt5multimedia qt5virtualkeyboard

define QDESKTOP_CONFIGURE_CMDS
        cd $(@D)/desktop; $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake
endef

define QDESKTOP_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/desktop
endef
QDESKTOP_INSTALL_TARGET_DIR = $(TARGET_DIR)/opt/qtapp

define QDESKTOP_INSTALL_TARGET_CMDS
        mkdir -p $(QDESKTOP_INSTALL_TARGET_DIR)
        cp -r $(@D)/src $(QDESKTOP_INSTALL_TARGET_DIR)
        $(INSTALL) -D -m 0755 $(@D)/desktop/QDesktop $(QDESKTOP_INSTALL_TARGET_DIR)
        $(INSTALL) -D -m 0755 $(@D)/S50QDesktop $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))

