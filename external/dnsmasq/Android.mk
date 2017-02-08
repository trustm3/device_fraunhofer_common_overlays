LOCAL_PATH := external/dnsmasq/src

#########################

include $(CLEAR_VARS)
LOCAL_SRC_FILES :=  bpf.c cache.c dbus.c dhcp.c dnsmasq.c forward.c helper.c lease.c log.c \
                    netlink.c network.c option.c rfc1035.c rfc2131.c tftp.c util.c

LOCAL_MODULE := dnsmasq_static
LOCAL_MODULE_STEM := dnsmasq

LOCAL_MODULE_TAGS := optional

LOCAL_C_INCLUDES := external/dnsmasq/src

LOCAL_CFLAGS := -O2 -g -W -Wall -D__ANDROID__ -DNO_IPV6 -DNO_TFTP -DNO_SCRIPT
#LOCAL_SYSTEM_SHARED_LIBRARIES := libc
#LOCAL_SHARED_LIBRARIES := libcutils liblog

LOCAL_STATIC_LIBRARIES := \
	libc \
	libcutils \
	liblog

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

include $(BUILD_EXECUTABLE)
