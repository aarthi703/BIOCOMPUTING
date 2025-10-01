#!/bin/bash
set -ueo pipefail

MAIN_DIR=${HOME}/BIOCOMPUTING/assignments/assignment_5

cd ~/programs

#use wget to download the .tar file, and use tar to unpack the tarball.

wget https://gzahn.github.io/data/fastq_examples.tar 

tar -xf fastq_examples.tar

mv *.fastq.gz ${MAIN_DIR}/data/raw

rm -r fastq_examples.tar 




