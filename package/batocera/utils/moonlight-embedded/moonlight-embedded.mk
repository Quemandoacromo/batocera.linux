################################################################################
#
# moonlight-embedded
#
################################################################################

MOONLIGHT_EMBEDDED_VERSION = a6bf7154a743d4f74a1b377e730f188352a1b80c
MOONLIGHT_EMBEDDED_SITE = https://github.com/moonlight-stream/moonlight-embedded.git
MOONLIGHT_EMBEDDED_SITE_METHOD = git
MOONLIGHT_EMBEDDED_GIT_SUBMODULES=y
MOONLIGHT_EMBEDDED_LICENSE = GPLv3
MOONLIGHT_EMBEDDED_DEPENDENCIES = opus expat libevdev avahi alsa-lib udev \
                                  libcurl libcec ffmpeg sdl2 libenet

MOONLIGHT_EMBEDDED_CONF_OPTS = "-DCMAKE_INSTALL_SYSCONFDIR=/etc"

ifeq ($(BR2_PACKAGE_XORG7),y)
    MOONLIGHT_EMBEDDED_CONF_OPTS += -DENABLE_X11=ON
else
    MOONLIGHT_EMBEDDED_CONF_OPTS += -DENABLE_X11=OFF
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
    MOONLIGHT_EMBEDDED_DEPENDENCIES += libva-intel-driver intel-mediadriver
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
    MOONLIGHT_EMBEDDED_DEPENDENCIES += rpi-userland
endif

ifneq ($(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_4),y)
    ifeq ($(BR2_PACKAGE_ROCKCHIP_RGA)$(BR2_PACKAGE_ROCKCHIP_MPP),yy)
    MOONLIGHT_EMBEDDED_DEPENDENCIES += rockchip-mpp rockchip-rga ffmpeg-rockchip
    endif   
endif

define MOONLIGHT_EMBEDDED_INSTALL_SCRIPTS
    mkdir -p $(TARGET_DIR)/usr/share/moonlight-embedded
    cp -f $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/utils/moonlight-embedded/moonlight.conf \
        $(TARGET_DIR)/usr/share/moonlight-embedded/
    install -m 0755 \
	    $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/utils/moonlight-embedded/batocera-moonlight \
	    $(TARGET_DIR)/usr/bin/
endef

MOONLIGHT_EMBEDDED_POST_INSTALL_TARGET_HOOKS += MOONLIGHT_EMBEDDED_INSTALL_SCRIPTS

$(eval $(cmake-package))
