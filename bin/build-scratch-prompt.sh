#!/bin/bash

#Import methods
. ./lib/sfdx.sh

echo "Enter new name for scratch org."
SCRATCH_NAME=$(prompt_string)

bash ./bin/build-scratch.sh $SCRATCH_NAME