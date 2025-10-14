#!/bin/bash

set -euo pipefail

module load Flye/gcc-11.4.1/2.9.6

echo "run flye"

flye --nano-hq data/SRR33939694.fastq.gz -g 50k -t 6 --meta -o ./assemblies/assembly_module

cd ./assemblies/assembly_module

echo "rename the assembly.fasta and fly.log files to module_assembly.fasta and module_fly.log respectively"
mv assembly.fasta module_assembly.fasta

mv flye.log module_flye.log

#remove extra files.
rm -r 00-assembly 30-contigger 10-consensus 40-polishing 20-repeat *.gfa *.gv *.txt *.json

cd ../../


