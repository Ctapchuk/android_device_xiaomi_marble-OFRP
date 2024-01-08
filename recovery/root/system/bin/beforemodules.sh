#!/system/bin/sh

# Detect current firmware and use proper kernel modules.

LOGF=/tmp/recovery.log;
slot=`getprop ro.boot.slot_suffix`;
[[ -z $slot ]] && slot=`bootctl get-current-slot | xargs bootctl get-suffix`;
modules=/vendor/lib/modules;

mkdir -p $modules/1.1;
if strings /dev/block/bootdevice/by-name/xbl_config${slot} | grep -q 'led_blink'; then
	echo "I:modules_fix: Use kernel modules for HyperOS firmware!" >> $LOGF;
	mount $modules/hos1 $modules/1.1 --bind
else
	echo "I:modules_fix: Use kernel modules for MIUI14 firmware!" >> $LOGF;
	mount $modules/miui14 $modules/1.1 --bind
fi

exit 0
