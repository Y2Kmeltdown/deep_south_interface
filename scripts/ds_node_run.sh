#!/bin/bash

pad_number() {
    printf "%02d" "$1"
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
else
    if test -f $1; then
        base_name=$(basename $1)
        if (($2 >= 1 && $2 <= 23)); then
            node=$(pad_number $2)
            echo "ssh -J damien.rice@137.154.50.2 damien.rice@xcs-node-23 "./deepsouth_testing/$base_name"" 
        
            ssh -J damien.rice@137.154.50.2 damien.rice@xcs-node-23 "./deepsouth_testing/$base_name"
        else
            echo "Argument 2 must be a node between 1 and 23"
        fi
    else
        echo "File Doesn't Exist"
    fi
fi