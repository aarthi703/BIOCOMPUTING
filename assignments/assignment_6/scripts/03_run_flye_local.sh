#!/bin/bash

set -euo pipefail

#add Flye to the PATH 

export PATH=$PATH:$HOME/programs/Flye/bin

echo "run the manual build script"

./scripts/02_flye_2.9.6_manual_build.sh

flye --nano-hq data/SRR33939694.fastq.gz -g 50k -t 6 --meta -o ./assemblies/assembly_local  

#rename .log and .fasta files to local_assembly.fasta and local_flye.log

cd assemblies/assembly_local


echo "rename the files"

mv assembly.fasta local_assembly.fasta

mv flye.log local_flye.log

#remove the extra files
rm -r 00-assembly 30-contigger 10-consensus 40-polishing 20-repeat *.gfa *.gv *.txt *.json

cd ../../
