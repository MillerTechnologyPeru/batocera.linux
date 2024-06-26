################################################################################
#
# lemonade
#
################################################################################

LEMONADE_VERSION = Alpha-2
LEMONADE_SITE = https://github.com/Lemonade-emu/Lemonade.git
LEMONADE_SITE_METHOD=git
LEMONADE_GIT_SUBMODULES=YES
LEMONADE_LICENSE = GPLv2
LEMONADE_DEPENDENCIES += fmt boost ffmpeg sdl2 fdk-aac
LEMONADE_SUPPORTS_IN_SOURCE_BUILD = NO

LEMONADE_GIT_SUBMODULES = YES

LEMONADE_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
LEMONADE_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
LEMONADE_CONF_OPTS += -DENABLE_SDL2=ON
LEMONADE_CONF_OPTS += -DENABLE_TESTS=OFF
LEMONADE_CONF_OPTS += -DENABLE_DEDICATED_ROOM=OFF
LEMONADE_CONF_OPTS += -DENABLE_WEB_SERVICE=OFF
LEMONADE_CONF_OPTS += -DENABLE_OPENAL=OFF
LEMONADE_CONF_OPTS += -DUSE_DISCORD_PRESENCE=OFF
LEMONADE_CONF_OPTS += -DLEMONADE_WARNINGS_AS_ERRORS=OFF
LEMONADE_CONF_OPTS += -DLEMONADE_ENABLE_COMPATIBILITY_REPORTING=ON
LEMONADE_CONF_OPTS += -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON
LEMONADE_CONF_OPTS += -DUSE_SYSTEM_BOOST=ON
LEMONADE_CONF_OPTS += -DUSE_SYSTEM_SDL2=ON    # important to avoid HIDAPI
LEMONADE_CONF_OPTS += -DLEMONADE_ENABLE_BUNDLE_TARGET=ON
LEMONADE_CONF_OPTS += -DENABLE_LTO=OFF

# future support for arm using SDL2 gui?
ifeq ($(BR2_PACKAGE_QT6),y)
    LEMONADE_DEPENDENCIES += qt6base qt6tools qt6multimedia
    LEMONADE_CONF_OPTS += -DENABLE_QT=ON
    LEMONADE_CONF_OPTS += -DENABLE_QT_TRANSLATION=ON
    LEMONADE_CONF_OPTS += -DENABLE_QT_UPDATER=OFF
    LEMONADE_BIN = lemonade-qt
else
    LEMONADE_CONF_OPTS += -DENABLE_QT=OFF
    LEMONADE_CONF_OPTS += -DENABLE_SDL2_FRONTEND=ON
    LEMONADE_BIN = lemonade
endif

LEMONADE_CONF_ENV += LDFLAGS=-lpthread

define LEMONADE_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/bin
    mkdir -p $(TARGET_DIR)/usr/lib
	$(INSTALL) -D $(@D)/buildroot-build/bin/Release/$(LEMONADE_BIN) \
		$(TARGET_DIR)/usr/bin/
endef

define LEMONADE_EVMAP
	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	cp -prn $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/emulators/lemonade/3ds.lemonade.keys \
		$(TARGET_DIR)/usr/share/evmapy
endef

LEMONADE_POST_INSTALL_TARGET_HOOKS = LEMONADE_EVMAP

$(eval $(cmake-package))
