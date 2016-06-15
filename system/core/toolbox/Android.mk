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
    dd \
    du \

OUR_TOOLS := \
    df \
    getevent \
    iftop \
    ioctl \
    ionice \
    log \
    ls \
    lsof \
    mount \
    nandread \
    newfs_msdos \
    ps \
    prlimit \
    renice \
    sendevent \
    start \
    stop \
    top \
    uptime \
    watchprops \

ALL_TOOLS = $(BSD_TOOLS) $(OUR_TOOLS)

LOCAL_SRC_FILES := \
    toolbox.c \
    $(patsubst %,%.c,$(OUR_TOOLS)) \

LOCAL_CFLAGS += $(common_cflags)

LOCAL_STATIC_LIBRARIES := \
    libcutils \
    libselinux \
    liblog \
    libc

LOCAL_WHOLE_STATIC_LIBRARIES := $(patsubst %,libtoolbox_%,$(BSD_TOOLS))

LOCAL_MODULE := toolbox_static

# Install the symlinks.
LOCAL_POST_INSTALL_CMD := $(hide) $(foreach t,$(ALL_TOOLS),ln -sf toolbox $(TARGET_OUT)/bin/$(t);)

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

$(LOCAL_PATH)/getevent.c: $(intermediates)/input.h-labels.h

INPUT_H_LABELS_H := $(intermediates)/input.h-labels.h
$(INPUT_H_LABELS_H): PRIVATE_LOCAL_PATH := $(LOCAL_PATH)
$(INPUT_H_LABELS_H): PRIVATE_CUSTOM_TOOL = $(PRIVATE_LOCAL_PATH)/generate-input.h-labels.py > $@
$(INPUT_H_LABELS_H): $(LOCAL_PATH)/Android.mk $(LOCAL_PATH)/generate-input.h-labels.py
$(INPUT_H_LABELS_H):
	$(transform-generated-source)


# We build BSD grep separately, so it can provide egrep and fgrep too.
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
    upstream-netbsd/usr.bin/grep/fastgrep.c \
    upstream-netbsd/usr.bin/grep/file.c \
    upstream-netbsd/usr.bin/grep/grep.c \
    upstream-netbsd/usr.bin/grep/queue.c \
    upstream-netbsd/usr.bin/grep/util.c
LOCAL_CFLAGS += $(common_cflags)
LOCAL_MODULE := grep_static
LOCAL_POST_INSTALL_CMD := $(hide) $(foreach t,egrep fgrep grep,ln -sf grep_static $(TARGET_OUT)/bin/$(t);)

LOCAL_STATIC_LIBRARIES := \
    liblog \
    libc

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)
include $(BUILD_EXECUTABLE)

endif
