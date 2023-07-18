#!/system-bin/sh

# No env -i please...
DEVICE="${DEVICE}" DEVICE_CODENAME="${DEVICE_CODENAME}" QT_FONT_DPI=${QT_FONT_DPI} PATH="/app-bin:/system-bin" LD_LIBRARY_PATH="/system-lib/lib:/system-lib/qt/lib:/app-lib" QT_QPA_PLATFORM="kobo" LC_ALL="en_US" QT_PLUGIN_PATH="/system-lib/qt/plugins/" XDG_CONFIG_HOME="/system-onboard/" XDG_RUNTIME_DIR="/system-onboard/" HOME="/system-onboard/" /app-bin/syncthing.bin --gui-address 0.0.0.0:8384 --config /app-data --data /app-data
