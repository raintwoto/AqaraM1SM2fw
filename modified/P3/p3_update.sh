#!/bin/sh

if [ "$(getprop ro.sys.model)" != "lumi.aircondition.acn05" ]; then
    echo "This is not supported P3 and exit!"
    exit 1
fi

cd /tmp

echo "Updating Coor"
/tmp/curl -s -k -L -o /tmp/ControlBridge.bin https://raw.githubusercontent.com/niceboygithub/AqaraM1SM2fw/main/original/P3/3.2.8_0007.0526/ControlBridge.bin
[ "$(md5sum /tmp/ControlBridge.bin)" == "799ecb705ce22049566a0d772c93c2b2  /tmp/ControlBridge.bin" ] && zigbee_msnger zgb_ota /tmp/ControlBridge.bin
[ "$(zigbee_msnger get_zgb_ver | grep coor)" != "coor ver =0526" ] && zigbee_msnger zgb_ota /tmp/ControlBridge.
[ "x$(zigbee_msnger get_zgb_ver | grep Error)" != "x" ] && zigbee_msnger zgb_ota /tmp/ControlBridge.bin

echo "Updating IR Controller"
/tmp/curl -s -k -L -o /tmp/IRController.bin https://raw.githubusercontent.com/niceboygithub/AqaraM1SM2fw/main/original/P3/3.2.8_0007.0526/IRController.bin
[ "$(md5sum /tmp/IRController.bin)" = "4c8209564354944f2f7fdb12efd09db8  /tmp/IRController.bin" ] && ir_ota ttyS2 115200 /tmp/IRController.bin

echo "Updating linux kernel"
/tmp/curl -s -k -L -o /tmp/linux.bin https://raw.githubusercontent.com/niceboygithub/AqaraM1SM2fw/main/original/P3/3.2.8_0007.0526/linux_3.2.8_0007.0526.bin
fw_update /tmp/linux.bin
echo 3 >/proc/sys/vm/drop_caches; sleep 1; sync

echo "Update root file system"
/tmp/curl -s -k -L -o /tmp/rootfs.bin https://raw.githubusercontent.com/niceboygithub/AqaraM1SM2fw/main/modified/P3/3.2.8_0007.0526/rootfs_3.2.8_0007.0526_modified.bin
killall homekitserver; fw_update /tmp/rootfs.bin
sync; sync