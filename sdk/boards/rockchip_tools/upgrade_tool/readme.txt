
cp 88-rockusb.rules /etc/udev/rules.d/

restart udev:
udevadm control --reload-rules

