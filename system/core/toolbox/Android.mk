# Only build static toolbox when building for CML
ifeq ($(TRUSTME_NATIVE),true)

LOCAL_PATH:= system/core/toolbox

common_cflags := \
    -std=gnu99 \
    -Werror -Wno-unused-parameter \
    -I$(LOCAL_PATH)/upstream-netbsd/include/ \
    -include bsd-compatibility.h \


include $(CLEAR_VARS)

BSD_TOOLS := \
    cat \
    chown \
    cp \
    dd \
    du \
    grep \
    kill \
    ln \
    mv \
    printenv \
    rm \
    rmdir \
    sleep \
    sync \

OUR_TOOLS := \
    chcon \
    chmod \
    clear \
    cmp \
    date \
    df \
    dmesg \
    getenforce \
    getevent \
    getprop \
    getsebool \
    hd \
    id \
    ifconfig \
    iftop \
    insmod \
    ioctl \
    ionice \
    load_policy \
    log \
    ls \
    lsmod \
    lsof \
    md5 \
    mkdir \
    mknod \
    mkswap \
    mount \
    nandread \
    netstat \
    newfs_msdos \
    nohup \
    notify \
    ps \
    readlink \
    renice \
    restorecon \
    prlimit \
    rmmod \
    route \
    runcon \
    schedtop \
    sendevent \
    setenforce \
    setprop \
    setsebool \
    smd \
    start \
    stop \
    swapoff \
    swapon \
    top \
    touch \
    umount \
    uptime \
    vmstat \
    watchprops \
    wipe \

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
OUR_TOOLS += r
endif

ALL_TOOLS = $(BSD_TOOLS) $(OUR_TOOLS)

LOCAL_SRC_FILES := \
    upstream-netbsd/lib/libc/gen/getbsize.c \
    upstream-netbsd/lib/libc/gen/humanize_number.c \
    upstream-netbsd/lib/libc/stdlib/strsuftoll.c \
    upstream-netbsd/lib/libc/string/swab.c \
    upstream-netbsd/lib/libutil/raise_default_signal.c \
    dynarray.c \
    pwcache.c \
    $(patsubst %,%.c,$(OUR_TOOLS)) \
    toolbox.c \

LOCAL_CFLAGS += $(common_cflags)

LOCAL_C_INCLUDES += external/openssl/include

LOCAL_STATIC_LIBRARIES := \
    libselinux \
    libusbhost \
    libmincrypt \
    libcrypto_static \
    libm \
    libcutils \
    liblog \
    libc

LOCAL_WHOLE_STATIC_LIBRARIES := $(patsubst %,libtoolbox_%,$(BSD_TOOLS)) 

LOCAL_MODULE := toolbox_static

# Including this will define $(intermediates).
#
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)
include $(BUILD_EXECUTABLE)

$(LOCAL_PATH)/toolbox.c: $(intermediates)/tools.h

TOOLS_H := $(intermediates)/tools.h
$(TOOLS_H): PRIVATE_TOOLS := $(ALL_TOOLS)
$(TOOLS_H): PRIVATE_CUSTOM_TOOL = echo "/* file generated automatically */" > $@ ; for t in $(PRIVATE_TOOLS) ; do echo "TOOL($$t)" >> $@ ; done
$(TOOLS_H): $(LOCAL_PATH)/Android.mk
$(TOOLS_H):
	$(transform-generated-source)

# Make #!/system/bin/toolbox launchers for each tool.
#
SYMLINKS := $(addprefix $(TARGET_ROOT_OUT)/system/bin/,$(ALL_TOOLS))
$(SYMLINKS): TOOLBOX_BINARY := /sbin/$(LOCAL_MODULE)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> $(TOOLBOX_BINARY)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf $(TOOLBOX_BINARY) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

# We need this so that the installed files could be picked up based on the
# local module name
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SYMLINKS)

endif
