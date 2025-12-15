#!/bin/bash

pad_number() {
    printf "%02d" "$1"
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
else
    if test -f $1; then
        if (($2 >= 0 && $2 <= 3)); then
            base_name=$(basename $1)
            if (($3 >= 1 && $3 <= 23)); then
                node=$(pad_number $3)
                echo "ssh -J damien.rice@137.154.50.2 damien.rice@xcs-node-$node "./deepsouth_testing/$base_name $2"" 
            
                ssh -J damien.rice@137.154.50.2 damien.rice@xcs-node-$node "./deepsouth_testing/$base_name $2"
            else
                echo "Argument 3 must be a node between 1 and 23"
            fi
        else
            echo "Argument 2 must be a node between 0 and 3"
        fi
    else
        echo "File Doesn't Exist"
    fi
fi