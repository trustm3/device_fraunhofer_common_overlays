#LOCAL_PATH:= $(call my-dir)
LOCAL_PATH:= system/extras/ext4_utils

include $(CLEAR_VARS)
LOCAL_SRC_FILES := make_ext4fs_main.c canned_fs_config.c
LOCAL_MODULE := make_ext4fs_static
LOCAL_MODULE_STEM := make_ext4fs
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

LOCAL_STATIC_LIBRARIES += \
    libext4_utils_static \
    libsparse_static \
    libz \
    libselinux \
    libmincrypt \
    libcutils \
    libc

include $(BUILD_EXECUTABLE)


