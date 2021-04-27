#!/bin/bash

source ./run/variables.sh
source ./run/functions.sh

sh ./run/utility/deleteAllBuckets.sh
sh ./run/utility/deleteAllContainerImages.sh


stacks=($(ls ./templates))

for stack in "${stacks[@]}"; do
  stackDelete "${stackPrefix}-$stack"
done;