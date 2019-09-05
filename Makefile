include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64
TARGET= iphone:clang:latest:9.0

TWEAK_NAME = storage3d

storage3d_FILES = Tweak.x
storage3d_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
