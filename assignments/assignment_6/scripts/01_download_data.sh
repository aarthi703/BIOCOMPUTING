#!/bin/bash

set -euo pipefail

#make directories
mkdir -p assemblies/{assembly_conda,assembly_local,assembly_module} data scripts


set -ueo pipefail

#download data into the data directory
wget -P ./data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
