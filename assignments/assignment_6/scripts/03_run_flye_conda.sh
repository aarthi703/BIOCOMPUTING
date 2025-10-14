#!/bin/bash

set -euo pipefail

#run scripts/02_flye_2.9.5_conda_install.sh which creates the environment.

./scripts/02_flye_2.9.6_conda_install.sh

echo "conda installed"

module load miniforge3

source "$(dirname $(which conda))/../etc/profile.d/conda.sh"

echo "ony this HPC, this is synonymous to /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh, as the directory where conda lives is located as a transportable way to get the directory structure."
#source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

conda activate flye-env

flye -v

echo "module loaded and conda activated; in miniforge3 "

flye --nano-hq data/SRR33939694.fastq.gz -g 50k -t 6 --meta -o ./assemblies/assembly_conda

cd assemblies/assembly_conda

mv assembly.fasta conda_assembly.fasta

mv flye.log conda_flye.log

echo "files have been renamed"

conda deactivate 


#remove extra files

rm -r 00-assembly 30-contigger 10-consensus 40-polishing 20-repeat *.gfa *.gv *.txt *.json

cd ../../

