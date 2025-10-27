#!/bin/bash

module load miniforge3

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh 

conda activate bbmap-env


conda env export --no-builds > bbmap-env.yml

conda deactivate

