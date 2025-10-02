#!/bin/bash

set -euo pipefail
MAIN_DIR=${HOME}/BIOCOMPUTING/assignments/assignment_5
SCRIPTS_DIR=${MAIN_DIR}/scripts

#go to data directory for assignment_5

#cd ${DATA_DIR} 

#run ./scripts/01_download_data.sh


echo "downloading data"

./scripts/01_download_data.sh

#for loop that runs the new script on each forward file

echo "run fastp"

cd ${MAIN_DIR}

for i in ./data/raw/*_R1_*

do 
echo "file ${i}"
./scripts/02_run_fastp.sh $i
sleep 1
done


