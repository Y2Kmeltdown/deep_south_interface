#!/bin/bash

CODE="build/deepsouth_interface"
make
./scripts/ds_test_env_transfer.sh $CODE
./scripts/ds_test_env_run.sh $CODE



