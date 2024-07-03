################################################################################
#
# mmc mount
#
################################################################################

MMCMOUNT_SITE_METHOD = local
MMCMOUNT_INSTALL_STAGING = YES
MMCMOUNT_SITE = $(TOPDIR)/package/alientek/mmcmount/src
MMCMOUNT_DEPEND = $(TOPDIR)/package/alientek/mmcmount/src
MMCMOUNT_DEPENDENCIES = eudev

define MMCMOUNT_INSTALL_TARGET_CMDS
		$(INSTALL) -D -m 0755 $(@D)/automount.rules $(TARGET_DIR)/lib/udev/rules.d/    
		mkdir -p $(TARGET_DIR)/usr/share/mmcmount/
		mkdir -p $(TARGET_DIR)/usr/share/mmcmount/mount.blacklist.d
        $(INSTALL) -D -m 0755 $(@D)/mount.blacklist $(TARGET_DIR)/usr/share/mmcmount/
        $(INSTALL) -D -m 0755 $(@D)/mount.sh $(TARGET_DIR)/usr/share/mmcmount/
endef

$(eval $(generic-package))

