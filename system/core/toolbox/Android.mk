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

OUR_TOOLS := \
    getevent \
    iftop \
    ioctl \
    log \
    nandread \
    newfs_msdos \
    ps \
    prlimit \
    sendevent \
    start \
    stop \
    top \

ALL_TOOLS = $(BSD_TOOLS) $(OUR_TOOLS)

LOCAL_SRC_FILES := \
    start_stop.cpp \
    toolbox.c \
    $(patsubst %,%.c,$(OUR_TOOLS)) \

LOCAL_CFLAGS += $(common_cflags)
LOCAL_CONLYFLAGS += -std=gnu99

LOCAL_STATIC_LIBRARIES := \
    libcutils \
    libselinux \
    liblog \
    libc

LOCAL_WHOLE_STATIC_LIBRARIES := $(patsubst %,libtoolbox_%,$(BSD_TOOLS))

LOCAL_MODULE := toolbox_static

# Install the symlinks.
LOCAL_POST_INSTALL_CMD := $(hide) $(foreach t,$(ALL_TOOLS),ln -sf toolbox_static $(TARGET_ROOT_OUT_SBIN)/$(t);)

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

UAPI_INPUT_EVENT_CODES_H := bionic/libc/kernel/uapi/linux/input-event-codes.h
INPUT_H_LABELS_H := $(intermediates)/input.h-labels.h
$(INPUT_H_LABELS_H): PRIVATE_LOCAL_PATH := $(LOCAL_PATH)
# The PRIVATE_CUSTOM_TOOL line uses = to evaluate the output path late.
# We copy the input path so it can't be accidentally modified later.
$(INPUT_H_LABELS_H): PRIVATE_UAPI_INPUT_EVENT_CODES_H := $(UAPI_INPUT_EVENT_CODES_H)
$(INPUT_H_LABELS_H): PRIVATE_CUSTOM_TOOL = $(PRIVATE_LOCAL_PATH)/generate-input.h-labels.py $(PRIVATE_UAPI_INPUT_EVENT_CODES_H) > $@
# The dependency line though gets evaluated now, so the PRIVATE_ copy doesn't exist yet,
# and the original can't yet have been modified, so this is both sufficient and necessary.
$(INPUT_H_LABELS_H): $(LOCAL_PATH)/Android.mk $(LOCAL_PATH)/generate-input.h-labels.py $(UAPI_INPUT_EVENT_CODES_H)
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
LOCAL_POST_INSTALL_CMD := $(hide) $(foreach t,grep, egrep fgrep,ln -sf grep_static $(TARGET_ROOT_OUT_SBIN)/$(t);)

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)
include $(BUILD_EXECUTABLE)

endif
