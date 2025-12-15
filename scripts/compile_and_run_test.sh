#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
else
    if (($1 >= 0 && $1 <= 3)); then
        CODE="build/deepsouth_interface"
        make
        ./scripts/ds_test_env_transfer.sh $CODE
        ./scripts/ds_test_env_run.sh $CODE $1
        scp -oProxyJump=damien.rice@137.154.50.2 damien.rice@xcs-node-23:memory.log logs/
    else
        echo "Argument 2 must be a node between 0 and 3"
    fi
fi
