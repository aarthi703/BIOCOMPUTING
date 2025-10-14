#!/bin/bash

set -euo pipefail

#programs directory.

cd ~/programs

#use Flye package locally wihtout installation. Compile the latest version.

git clone https://github.com/fenderglass/Flye
cd Flye
make


#export PATH
export PATH="$PATH:/sciclone/home/abharathan01/programs/Flye/bin"

