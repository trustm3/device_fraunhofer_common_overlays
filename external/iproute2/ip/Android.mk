LOCAL_PATH := external/iproute2/ip

include $(CLEAR_VARS)
LOCAL_SRC_FILES := ip.c ipaddress.c ipaddrlabel.c iproute.c iprule.c ipnetns.c \
        rtm_map.c iptunnel.c ip6tunnel.c tunnel.c ipneigh.c ipntable.c iplink.c \
        ipmaddr.c ipmonitor.c ipmroute.c ipprefix.c iptuntap.c \
        ipxfrm.c xfrm_state.c xfrm_policy.c xfrm_monitor.c \
        iplink_vlan.c link_veth.c link_gre.c iplink_can.c \
        iplink_macvlan.c iplink_macvtap.c ipl2tp.c

LOCAL_MODULE := ip_static
LOCAL_MODULE_STEM := ip

LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libc libm libdl-static

LOCAL_STATIC_LIBRARIES += libiprouteutil_static libnetlink_static

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../include

LOCAL_CFLAGS := \
    -O2 -g \
    -W -Wall \
    -Wno-implicit-function-declaration \
    -Wno-missing-field-initializers \
    -Wno-pointer-arith \
    -Wno-sign-compare \
    -Werror \
    -D_GNU_SOURCE \
    -DHAVE_SETNS \

LOCAL_LDFLAGS := -Wl,-export-dynamic -Wl,--no-gc-sections

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

include $(BUILD_EXECUTABLE)

