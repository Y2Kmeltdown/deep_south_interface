#!/bin/bash

pad_number() {
    printf "%02d" "$1"
}

if [ "$#" -ge 3 ]; then
  echo "Starting Flashing Process"
else
  echo "Error: Please supply at least 3 arguments."
  echo "Usage: $0 <filename.pof> <node ID 1-23> <fpga ID 0-3>"
  exit 1 # Exit with an error code
fi


filename="$1"
node_ID="$2"
fpga_ID="$3"

if [ -f "$filename" ]; then
    base_name=$(basename $filename)
    if (($node_ID >= 1 && $node_ID <= 23)); then
        if (($fpga_ID >= 0 && $fpga_ID <= 3)); then
            node=$(pad_number $node_ID)

            echo "ssh -J damien.rice@137.154.50.2 damien.rice@xcs-node-$node "qspi_flashprog -c $fpga_ID -p deepsouth_testing/$base_name"" 
            
            ssh -J damien.rice@137.154.50.2 damien.rice@xcs-node-$node "qspi_flashprog -c $fpga_ID -p deepsouth_testing/$base_name"
            if [ $? -eq 0 ]; then
                echo "520n-mx Flash successful!"
                echo "Please power cycle node for new flash image to take affect."
            else
                echo "520n-mx Flash failed. Exit code: $?"
                exit 1 # Exit the script with a failure code
            fi

        else
            echo "Error: FPGA ID must be in range of 0-3"
        fi
    else
        echo "Error: Node ID must be in range of 1-23"
    fi
else
    echo "'$filename' does not exist or is not a regular file."
fi