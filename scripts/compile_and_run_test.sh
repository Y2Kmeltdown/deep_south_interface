#!/bin/bash

CODE="build/deepsouth_interface"
make
./scripts/ds_test_env_transfer.sh $CODE
./scripts/ds_test_env_run.sh $CODE
scp -oProxyJump=damien.rice@137.154.50.2 damien.rice@xcs-node-23:Memory.log logs/



