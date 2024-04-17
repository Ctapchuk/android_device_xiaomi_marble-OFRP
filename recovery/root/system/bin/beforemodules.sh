#!/system/bin/sh

# Detect current firmware and use proper kernel modules.

LOGF=/tmp/recovery.log;
slot=`getprop ro.boot.slot_suffix`;
[[ -z $slot ]] && slot=`bootctl get-current-slot | xargs bootctl get-suffix`;
modules=/vendor/lib/modules;

mkdir -p $modules/1.1;
if strings /dev/block/bootdevice/by-name/xbl_config${slot} | grep -q 'led_blink'; then
	echo "I:modules_fix: Use kernel modules for HyperOS firmware!" >> $LOGF;
	mount $modules/hos1 $modules/1.1 --bind;
else
	echo "I:modules_fix: Use kernel modules for MIUI14 firmware!" >> $LOGF;
	mount $modules/miui14 $modules/1.1 --bind;
fi

# Workaround for goodix_core touch module
cat /proc/modules | grep goodix_core > /dev/null;
status=$?;
if [ $status -eq 0 -a ! -d "/sys/devices/platform/goodix_ts.0" ]; then
	rmmod goodix_core;
	if [ $? -eq 0 ]; then
		echo "I:modules_fix: goodix_core unloaded successfully!" >> $LOGF;
	else
		echo "E:modules_fix: Cannot unload goodix_core!" >> $LOGF;
	fi
fi

exit 0
