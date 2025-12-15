#!/bin/bash

# Check if at least one argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Store the first argument in a variable for clarity
filename="$1"

# Check if the file exists and is a regular file
if [ -f "$filename" ]; then
    sed -i "s|SOF_FILE|$filename|g" scripts/deepsouth.pfg

    quartus_pfg -c scripts/deepsouth.pfg
    if [ $? -eq 0 ]; then
      echo "Quartus File Generation successful!"
    else
      echo "Quartus File Generation failed. Exit code: $?"
      exit 1 # Exit the script with a failure code
    fi

    sed -i "s|$filename|SOF_FILE|g" scripts/deepsouth.pfg
    echo "Generated build/deepsouth.pof"
else
  echo "'$filename' does not exist or is not a regular file."
  exit 1
fi
exit 0
