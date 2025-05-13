### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers & GitHub @ Xiaomichael

### AnyKernel setup
# global properties
properties() { '
kernel.string=KernelSU by KernelSU Developers | Build by Suxiaoqingx
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
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

kernel_version=$(cat /proc/version | awk -F '-' '{print $1}' | awk '{print $3}')
case $kernel_version in
    5.1*) ksu_supported=true ;;
    6.1*) ksu_supported=true ;;
    *) ksu_supported=false ;;
esac

ui_print "内核构建者: Coolapk@Suxiaoqing"
ui_print " " "  -> ksu_supported: $ksu_supported"
$ksu_supported || abort "  -> Non-GKI device, abort."

# boot install
if [ -L "/dev/block/bootdevice/by-name/init_boot_a" -o -L "/dev/block/by-name/init_boot_a" ]; then
    split_boot # for devices with init_boot ramdisk
    flash_boot # for devices with init_boot ramdisk
else
    dump_boot # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk
    write_boot # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
fi
## end boot install
# 优先选择模块路径
if [ -f "$AKHOME/zram.zip" ]; then
    MODULE_PATH="$AKHOME/zram.zip"
else
    ui_print "  -> No ZRAM module found!"
    exit 1
fi

KSUD_PATH="/data/adb/ksud"
ui_print "安装 zram压缩算法附加 模块？音量上跳过安装；音量下安装模块"
ui_print "Install zram module?Volume up: NO；Volume down: YES"

key_click=""
while [ "$key_click" = "" ]; do
    key_click=$(getevent -qlc 1 | awk '{ print $3 }' | grep 'KEY_VOLUME')
    sleep 0.2
done
case "$key_click" in
    "KEY_VOLUMEDOWN")
        if [ -f "$KSUD_PATH" ]; then
            ui_print "Installing zram Module..."
            /data/adb/ksud module install "$MODULE_PATH"
            ui_print "Installation Complete"
        else
            ui_print "KSUD Not Found, skipping installation"
        fi
        ;;
    "KEY_VOLUMEUP")
        ui_print "Skipping zram module installation"
        ;;
    *)
        ui_print "Unknown key input, skipping installation"
        ;;
esac
