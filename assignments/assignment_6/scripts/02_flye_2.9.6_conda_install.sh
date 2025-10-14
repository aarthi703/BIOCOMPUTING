#!/bin/bash

set -euo pipefail


#load the module and initialize conda.

module load miniforge3

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

#build the environment using mamba (version 2.9.6).

mamba create -n flye-env flye=2.9.6 -y

#activate flye_env.

conda activate flye-env

#test

flye -v 

#document the environment.

conda env export --no-builds > flye-env.yml

conda deactivate

