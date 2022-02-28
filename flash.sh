#!/bin/bash

# read the parameters, check the -p parameter so the user can set a custom port
while getopts ":p:" opt; do
  case "$opt" in
    p) port="$OPTARG"
    ;;
    *)
    ;;
  esac
done

# create temporary environment variable
if [[ ! -z "$port" ]]; then
  export ESPTOOL_PORT="$port"
fi

# run the command to flash the board
# 0x1000  is required for the bootloader
# 0x8000  is required for the partitions table
# 0x10000 start of the software
esptool.py --chip esp32 --baud 921600 --before default_reset --after hard_reset write_flash -u -e --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 ./bootloader.bin 0x8000 ./partitions_singleapp.bin 0x10000 ./zephyr.bin
