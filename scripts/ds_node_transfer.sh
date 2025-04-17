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
            echo "-oProxyJump=damien.rice@137.154.50.2 $1 damien.rice@xcs-node-$node:deepsouth_testing/$base_name" 
        
            scp -oProxyJump=damien.rice@137.154.50.2 $1 damien.rice@xcs-node-$node:deepsouth_testing/$base_name
        else
            echo "Argument 2 must be a node between 1 and 23"
        fi
    else
        echo "File Doesn't Exist"
    fi
fi