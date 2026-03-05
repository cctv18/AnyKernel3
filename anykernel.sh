### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers & GitHub @ Xiaomichael&cctv18

### AnyKernel setup
# global properties
properties() { '
kernel.string=KernelSU by KernelSU Developers | Build by cctv18
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot shell variables
BLOCK=boot
IS_SLOT_DEVICE=auto
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=auto
NO_MAGISK_CHECK=1

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

ui_print "内核构建者: Coolapk@cctv18"

# boot install
split_boot
if [ -f "split_img/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi
## end boot install
# 优先选择模块路径
if [ -f "$AKHOME/zram.zip" ]; then
    MODULE_PATH="$AKHOME/zram.zip"
    KSUD_PATH="/data/adb/ksud"
    if [ -f "$KSUD_PATH" ]; then
        ui_print "Installing zram Module..."
        /data/adb/ksud module install "$MODULE_PATH"
        ui_print "Installation Complete!"
    else
        ui_print "KSUD Not Found, skipping installation..."
    fi
else
    ui_print "ZRAM module Not Found, skipping ZRAM module installation..."
fi
if [ -f "$AKHOME/kpn.zip" ]; then
    MODULE_PATH="$AKHOME/kpn.zip"
    KSUD_PATH="/data/adb/ksud"
    if [ -f "$KSUD_PATH" ]; then
        ui_print "Installing KP-N Module..."
        /data/adb/ksud module install "$MODULE_PATH"
        ui_print "Installation Complete!"
    else
        ui_print "KSUD Not Found, skipping installation..."
    fi
else
    ui_print "KP-N module Not Found, skipping KP-N module installation..."
fi
