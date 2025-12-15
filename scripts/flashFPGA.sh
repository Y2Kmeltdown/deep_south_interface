#!/bin/bash

pad_number() {
    printf "%02d" "$1"
}

if [ "$#" -ge 3 ]; then
  echo "Starting Process"
else
  echo "Error: Please supply at least 3 arguments."
  echo "Usage: $0 <filename.sof> <node ID 1-23> <fpga ID 0-3>"
  exit 1 # Exit with an error code
fi


filename="$1"
echo "Filename:$filename"
node_ID="$2"
echo "node_ID:$node_ID"
fpga_ID="$3"
echo "fpga_ID:$fpga_ID"

if [ -f "$filename" ]; then
    if (($node_ID >= 1 && $node_ID <= 23)); then
        if (($fpga_ID >= 0 && $fpga_ID <= 3)); then
            ./scripts/genFPGAFlashIm.sh $filename
            ./scripts/ds_node_transfer.sh build/deepsouth.pof $node_ID
            ./scripts/qspi_remote_flash.sh build/deepsouth.pof $node_ID $fpga_ID
        else
            echo "Error: FPGA ID must be in range of 0-3"
        fi
    else
        echo "Error: Node ID must be in range of 1-23"
    fi
else
    echo "'$filename' does not exist or is not a regular file."
fi

# Get FPGA ID (0-3) and node ID (1-23)
# Generate Flash POF from SOF file
# Transfer POF file to node ID
# Initiate QSPI_Flash_prog on node ID to FPGA ID
# Prompt user to cold restart node ID