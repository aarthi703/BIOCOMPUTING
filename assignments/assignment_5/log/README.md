
Aarthi Bharathan 09/28/2025 Assignment_5

#Assignment 5 involves running a pipeline using a combination of individual scripts that download .fastq.gz files and take in the forward reads to produce the reverse reads and trimmed outputs of both forward and reverse reads. Two scripts were used: ./scripts/01_download_data.sh and ./scripts/02_run_fastp.sh. They were run using pipeline.sh. 


#Task 1: Setup assignment_5 directory.

#log into bora and get into the assignment 5 directory.

cd BIOCOMPUTING/assignments/assignment_5

#make directories (scripts, log, data (within which is raw and trimmed) within the parent directory using mkdir. 

mkdir -p scripts log data/{raw,trimmed}

#make README file within log subdirectory using touch.

touch log/README.md

#Task 2: Make the script to download and prepare fastq data.

#make script. 

nano scripts/01_download_data.sh

#!/bin/bash
set -ueo pipefail



#Use wget to download the .tar file and tar to unpack it.

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xf fastq_examples.tar

#move files to data/raw

mv *fastq.gz ./data/raw/

#clean

rm *fastq_examples.tar


#make it executable.

chmod +x 01_download_data.sh

#Task 3: Install and explore fastp tool.

#download latest version of fastp.

wget http://opengene.org/fastp/fastp.0.23.4

#version fastp v0.23.4.

mv fastp.0.23.4 fastp

#add it to the $PATH variable.

PATH=$PATH:/sciclone/home/abharathan01/programs

#make the file executable for everybody.

chmod a+x ./fastp

read1_input is -i or --in1

read1_output is -o or --out1

read2_input is -I or --in2

read2_output is -O or --out2

#Task 4: Script to run fastp

nano ./scripts/02_run_fastp.sh

#!/bin/bash

set -euo pipefail

#fastp in $PATH
echo "export PATH=$PATH:/sciclone/home/abharathan01/programs" >> ~/.bashrc

#take forward read as input
FWD_IN=$1

#get reverse read by replacing _R1_ with _R2_
REV_IN=${FWD_IN/_R1_/_R2_}

#get trimmed output for forward and reverse reads by replacing .fastq.gz with .trimmed.fastq.gz

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}

REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}

echo "FWD_IN: ${FWD_IN}, REV_IN: ${REV_IN}, FWD_OUT: ${FWD_OUT}, REV_OUT: ${REV_OUT}"

#run with fastp, taking both forward and reverse reads as inputs and trimming both, trimming the first 8 bases and last 20 bases (total of 28 bases removed), reads length of at least 100 with an average quality of 20
fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/trimmed} --out2 ${REV_OUT/raw/trimmed} --json /dev/null --html /dev/null --trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 --n_base_limit 0 --length_required 100 --average_qual 20

#make executable

chmod +x 02_run_fastp.sh 

#Task 5: pipeline.sh script

#check to see if the script runs this file and derives reverse reverse input and forward and reverse output file names. 
./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz

#make pipeline.sh

nano pipeline.sh

#!/bin/bash

set -euo pipefail

#set main_directory variable

MAIN_DIR=${HOME}/BIOCOMPUTING/assignments/assignment_5



#run ./scripts/01_download_data.sh


echo "downloading data"

./scripts/01_download_data.sh


#for loop that runs the new script on each forward file: for each thing containing R1 in data/raw, say the file name and run ./scripts/02_run_fastp.sh


echo "run fastp"

cd ${MAIN_DIR}

for i in ./data/raw/*_R1_*

do
echo "file ${i}"
./scripts/02_run_fastp.sh $i
sleep 1
done



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

#Task 6: Reflection

###Reflection 

>This assignment involved running scripts from another script, combining for loops and pattern expansion. I found pattern expansion hard to understand when it involved replacing patterns in multiple files, and I was unsure of whether the code was providing the desired output of trimmed files. However, I was able to refer to lesson 5 to learn how the for loop worked and how to assign variables to multiple paths to simplify the code.

>Challenges that I encountered included writing the for loop and understanding the mechanisms of the fastp program. Additionally, as the github link provided various ways to download the program, so I was initially unsure of which method to use to download it, and I struggled with saving the path. Luckily, the “./scripts/02_run_fastp.sh” ran the $PATH addition, but I was unsure of how to use the “exec ~/.bashrc” command because the terminal would always tell me “permission denied.” There were additional errors with the “source” command as well. 

>Overall, the practice that this assignment offered taught me the fundamental steps of constructing a pipeline, where separate scripts are written and called in order through a "modular approach.” The combination of scripts to get a task done allows for much more time to be saved and automates the complexity of the task with efficiency. 

>The pipeline was used to run a script that downloads the data (./scripts/01_download_data.sh) and a script that produces the reverse input files and forward and reverse output files from a forward input file. Each script performs a mini task, all of which are combined to perform one big task. In this case, it is essentially to download the .fastq.gz files and derive the output trimmed versions using the fastp program. Doing all of these one at a time can be daunting and very time-consuming. Each individual script would need revisions after it is created before the next one can be written. However, the major pro of a pipeline is that all of them can be run, and with the help of echo lines, the script causing any error can be pinpointed and revised as necessary. Cons include that this involves keeping track of file locations and paths while running for loops or manipulating files that are in specific locations. Therefore, errors are usually related to incorrect file paths that need to be rechecked and aligned with variables that may have been declared in the script(s). Moreover, it involves backstepping to pinpoint the script and ensure that script’s functionality and that of the overall pipeline. It can be a complex process.

>However, in my opinion, I think that the pros outweigh the costs. I think the complexity of running scripts one by one and jumbling them in a directory can make revisiting and reapplying them reconfusing, which can hinder the reproducibility of the code. Therefore, the automation and higher efficiency of pipelines make up for the complexity of the system.
	

