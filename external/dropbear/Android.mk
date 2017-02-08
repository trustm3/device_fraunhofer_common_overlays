LOCAL_PATH:= external/dropbear
include $(CLEAR_VARS)

LOCAL_SRC_FILES:=\
	dbutil.c buffer.c \
	dss.c bignum.c \
	signkey.c rsa.c random.c \
	queue.c \
	atomicio.c compat.c  fake-rfc2553.c
LOCAL_SRC_FILES+=\
	common-session.c packet.c common-algo.c common-kex.c \
	common-channel.c common-chansession.c termcodes.c \
	tcp-accept.c listener.c process-packet.c \
	common-runopts.c circbuffer.c
# loginrec.c 
LOCAL_SRC_FILES+=\
	cli-algo.c cli-main.c cli-auth.c cli-authpasswd.c cli-kex.c \
	cli-session.c cli-service.c cli-runopts.c cli-chansession.c \
	cli-authpubkey.c cli-tcpfwd.c cli-channel.c cli-authinteract.c
LOCAL_SRC_FILES+=netbsd_getpass.c

LOCAL_STATIC_LIBRARIES := libc libtommath libtomcrypt

LOCAL_MODULE_TAGS := optional

LOCAL_MODULE := ssh_dropbear_static
LOCAL_MODULE_STEM := ssh_static
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtommath 
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_CFLAGS += -DDROPBEAR_CLIENT

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:=\
	dbutil.c buffer.c \
	dss.c bignum.c \
	signkey.c rsa.c random.c \
	queue.c \
	atomicio.c compat.c  fake-rfc2553.c

LOCAL_SRC_FILES+=\
	dropbearkey.c gendss.c genrsa.c

LOCAL_STATIC_LIBRARIES := libc libtommath libtomcrypt

LOCAL_MODULE_TAGS := optional

LOCAL_MODULE := key_dropbear_static
LOCAL_MODULE_STEM := dropbearkey
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtommath 
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_CFLAGS += -DDROPBEAR_CLIENT

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

include $(BUILD_EXECUTABLE)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:=\
	dbutil.c buffer.c \
	dss.c bignum.c \
	signkey.c rsa.c random.c \
	queue.c \
	atomicio.c compat.c  fake-rfc2553.c

LOCAL_SRC_FILES+=\
	dropbearconvert.c keyimport.c

LOCAL_STATIC_LIBRARIES := libc libtommath libtomcrypt

LOCAL_MODULE_TAGS := optional

LOCAL_MODULE := convert_dropbear_static
LOCAL_MODULE_STEM := dropbearconvert
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtommath 
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_CFLAGS += -DDROPBEAR_CLIENT

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

include $(BUILD_EXECUTABLE)


include $(CLEAR_VARS)

LOCAL_SRC_FILES:=\
	scp.c progressmeter.c atomicio.c scpmisc.c

LOCAL_STATIC_LIBRARIES := libc libtommath libtomcrypt

LOCAL_MODULE_TAGS := optional

LOCAL_MODULE := scp_dropbear_static
LOCAL_MODULE_STEM := scp
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtommath 
LOCAL_C_INCLUDES += $(LOCAL_PATH)/libtomcrypt/src/headers
LOCAL_CFLAGS += -DDROPBEAR_CLIENT -DPROGRESS_METER

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

include $(BUILD_EXECUTABLE)
