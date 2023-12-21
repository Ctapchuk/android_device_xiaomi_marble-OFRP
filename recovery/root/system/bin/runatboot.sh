#!/system/bin/sh

# This script is needed to automatically set props for unified devices.

load_global()
{
    echo "POCO F5" > /config/usb_gadget/g1/strings/0x409/product;
    resetprop "ro.product.brand" "POCO";
    echo "I:unified-script: setting POCO F5 props" >> $LOGF;
}

load_CN()
{
    echo "Redmi Note 12 Turbo" > /config/usb_gadget/g1/strings/0x409/product;
    resetprop "ro.product.brand" "Redmi";
    echo "I:unified-script: setting Redmi Note 12 Turbo props" >> $LOGF;
}

local LOGF=/tmp/recovery.log;
region=`getprop ro.boot.hwc`;

echo "I:unified-script: detected region:" $region >> $LOGF;

case $region in
    "CN") # China
        load_CN
        ;;
     *) # Global
     	load_global
        ;;
esac

exit 0
