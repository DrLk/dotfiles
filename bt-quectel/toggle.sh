#!/usr/bin/env bash
# Enable/disable the Quectel USB Bluetooth adapter (2c7c:0130) via udev.
# WiFi (Qualcomm WCN785x, PCI) is not affected. The built-in ASUS BT (hci0)
# also remains untouched.

set -euo pipefail

RULE_PATH="/etc/udev/rules.d/81-disable-quectel-bt.rules"
VENDOR="2c7c"
PRODUCT="0130"
USB_PATH="/sys/bus/usb/devices/1-10"

usage() {
    cat <<EOF
Usage: $0 {disable|enable|status}

  disable  Install udev rule and unauthorize the device now (persists across reboots).
  enable   Remove udev rule and re-authorize the device now (restore default).
  status   Show current state.
EOF
    exit 1
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        exec sudo -- "$0" "$@"
    fi
}

cmd_disable() {
    require_root "$@"
    cat >"$RULE_PATH" <<EOF
# Disable Quectel USB Bluetooth adapter; keep built-in ASUS BT (hci0) and WiFi.
SUBSYSTEM=="usb", ATTRS{idVendor}=="$VENDOR", ATTRS{idProduct}=="$PRODUCT", ATTR{authorized}="0"
EOF
    udevadm control --reload
    udevadm trigger --action=change --subsystem-match=usb
    if [[ -w "$USB_PATH/authorized" ]]; then
        echo 0 >"$USB_PATH/authorized" || true
    fi
    echo "Disabled. Rule written to $RULE_PATH"
}

cmd_enable() {
    require_root "$@"
    rm -f "$RULE_PATH"
    udevadm control --reload
    if [[ -w "$USB_PATH/authorized" ]]; then
        echo 1 >"$USB_PATH/authorized" || true
    fi
    udevadm trigger --action=change --subsystem-match=usb
    echo "Enabled. Rule removed."
}

cmd_status() {
    if [[ -f "$RULE_PATH" ]]; then
        echo "udev rule: present ($RULE_PATH)"
    else
        echo "udev rule: absent"
    fi
    if [[ -r "$USB_PATH/authorized" ]]; then
        echo "current authorized: $(cat "$USB_PATH/authorized")  (1=on, 0=off)"
    else
        echo "device not present at $USB_PATH"
    fi
    echo
    echo "Bluetooth controllers visible to BlueZ:"
    bluetoothctl list 2>/dev/null || true
}

case "${1:-}" in
    disable) shift; cmd_disable "$@" ;;
    enable)  shift; cmd_enable "$@" ;;
    status)  cmd_status ;;
    *) usage ;;
esac
