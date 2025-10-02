#!/bin/bash
set -ueo pipefail



#Use wget to download the .tar file and tar to unpack it.

wget https://gzahn.github.io/data/fastq_examples.tar 

tar -xf fastq_examples.tar
  
#move files to data/raw

mv *fastq.gz ./data/raw/

#clean

rm *fastq_examples.tar 




