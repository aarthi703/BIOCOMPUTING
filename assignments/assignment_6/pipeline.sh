#!/bin/bash

set -euo pipefail

echo "run scripts"

./scripts/01_download_data.sh 


./scripts/03_run_flye_conda.sh 

./scripts/03_run_flye_module.sh

./scripts/03_run_flye_local.sh
echo "print results to STDOUT"

find ./assemblies -name "*flye.log"

tail -n 10 ./assemblies/assembly_conda/conda_flye.log

tail -n 10 ./assemblies/assembly_module/module_flye.log

tail -n 10 ./assemblies/assembly_local/local_flye.log



