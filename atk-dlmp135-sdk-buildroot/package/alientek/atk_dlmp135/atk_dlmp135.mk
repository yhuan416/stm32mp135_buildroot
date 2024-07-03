################################################################################
#
# atk_dlmp135 settings
#
################################################################################

ATK_DLMP135_SITE_METHOD = local
ATK_DLMP135_INSTALL_STAGING = YES
ATK_DLMP135_SITE = $(TOPDIR)/package/alientek/atk_dlmp135/src

define ATK_DLMP135_INSTALL_TARGET_CMDS
		$(INSTALL) -D -m 0755 $(@D)/customenv.sh $(TARGET_DIR)/etc/profile.d/    
        $(INSTALL) -D -m 0755 $(@D)/qtenv.sh $(TARGET_DIR)/etc/profile.d/    
		$(INSTALL) -D -m 0755 $(@D)/version $(TARGET_DIR)/etc/
        $(INSTALL) -D -m 0755 $(@D)/eeprom-rw $(TARGET_DIR)/usr/bin/
        $(INSTALL) -D -m 0755 $(@D)/factorytest.sh $(TARGET_DIR)/usr/bin/
        $(INSTALL) -D -m 0755 $(@D)/quectel-CM $(TARGET_DIR)/usr/bin/
        $(INSTALL) -D -m 0755 $(@D)/rtk_hciattach $(TARGET_DIR)/usr/bin/
		mkdir -p $(TARGET_DIR)/usr/share/misc/
        $(INSTALL) -D -m 0755 $(@D)/test.wav $(TARGET_DIR)/usr/share/misc/
		mkdir -p $(TARGET_DIR)/etc/init.d
        $(INSTALL) -D -m 0755 $(@D)/S30macrandom $(TARGET_DIR)/etc/init.d/
		mkdir -p $(TARGET_DIR)/usr/qml/AQuickPlugin
        cp -r $(@D)/AQuickPlugin/* $(TARGET_DIR)/usr/qml/AQuickPlugin 
        cp -r $(@D)/shell $(TARGET_DIR)/root
        cp -r $(@D)/firmware $(TARGET_DIR)/lib
		mkdir -p $(TARGET_DIR)/lib/modules
		sed -i "/modules/d" $(TARGET_DIR)/etc/fstab
		sed -i "/none/d" $(TARGET_DIR)/etc/fstab
		echo -e "/dev/mmcblk1p4\t\t/lib/modules\t\t\text4\t\tdefaults\t\t0\t0" >> $(TARGET_DIR)/etc/fstab
		echo -e "none\t\t/sys/kernel/debug\t\tdebugfs\t\tdefaults\t\t0\t0" >> $(TARGET_DIR)/etc/fstab
endef

ATK_DLMP135_POST_INSTALL_TARGET_HOOKS += ATK_DLMP135_INSTALL_TARGET_CMDS
$(eval $(generic-package))

