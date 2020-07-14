# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Sony XZ1 Dual Kernel by Amy07i @ xda-developers
do.devicecheck=1
do.modules=1
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=poplar_dsds
device.name2=polar
device.name3=G8342
device.name4=G8341
supported.versions=9.0.0
supported.patchlevels=
'; } # end properties

# shell variables
block=${KERNEL_IMAGE_FILE:-/dev/block/bootdevice/by-name/boot};
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# a hack for sony ric daemon - we need to hide magisk from it to avoid bootloop
# this is supported since magisk-19.3, for more details see
# https://github.com/topjohnwu/Magisk/pull/1454
if [ -e $ramdisk/sbin/ric ] && grep -q magisk $ramdisk/init; then
  append_file init.rc "/sbin/magiskhide --exec /sbin/ric" init.ric.rc;
  repack_ramdisk;
fi

# end ramdisk changes

write_boot;
## end install

