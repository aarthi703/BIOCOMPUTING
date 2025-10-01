
Aarthi Bharathan 09/28/2025 Assignment 5

#Task 1: Setup assignment_5 directory.

#make directories.

mkdir -p scripts log data/{raw,trimmed}

#make README file within log subdirectory.

touch log/README.md

#Task 2: Script to download and prepare fastq data.

#make script. 

nano scripts/01_download_data.sh

chmod +x 01_download_data.sh

#!/bin/bash

#download and extract files.

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xf fastq_examples.tar

#move files into ./data/raw/ subdirectory.
mv *.fastq.gz ./data/raw/

#clean

rm -r fastq_examples.tar

#Task 3: Install and explore fastp tool.

#download latest version of fastp.

wget http://opengene.org/fastp/fastp.0.23.4

#version fastp v0.23.4.

mv fastp.0.23.4 fastp

PATH=$PATH:/sciclone/home/abharathan01/programs
#make the file executable for everybody.

chmod a+x ./fastp

read1_input=-i

read1_output=-o

read2_input=-I
read2_output=-O

#Task 4: Script to run fastp

nano ./scripts/02_run_fastp.sh

#!/bin/bash

set -euo pipefail

FWD_IN=$1

REV_IN=${FWD_IN/_R1_/_R2_}

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}

fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/trimmed}

#make executable

chmod +x 02_run_fastp.sh 

#Task 5: pipeline.sh script

#check to see if the script runs this file and derives reverse reverse input and forward and reverse output file names. 
./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz

#make pipeline.sh

nano pipeline.sh

#make executible (PUT IN SCRIPT)

chmod +x pipeline.sh

#run script

./pipeline.sh


#get rid of files in data to push everything to github
cd data/trimmed
rm -r *fastq.gz
ls
cd ..
cd raw
rm -r *.gz

