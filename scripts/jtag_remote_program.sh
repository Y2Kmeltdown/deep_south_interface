#!/bin/bash

#100.91.187.6
#intelFPGA_pro/20.3/qprogrammer/quartus/bin/quartus_pgm -m jtag -c usb-blaster -o "p;SOF_FILE"

# Check if at least one argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Store the first argument in a variable for clarity
filename="$1"

if [ -n "$2" ]; then
  usb_ID="$2"
else
  usb_ID="0"
fi

# Check if the file exists and is a regular file
if [ -f "$filename" ]; then
  base_name=$(basename $1)
  scp $filename damie@100.91.187.6:deepsouth_testing/$base_name
  ssh damie@100.91.187.6 intelFPGA_pro/20.3/qprogrammer/quartus/bin/quartus_pgm -m jtag -o "\"p;deepsouth_testing/$base_name\""
else
  echo "'$filename' does not exist or is not a regular file."
fi

