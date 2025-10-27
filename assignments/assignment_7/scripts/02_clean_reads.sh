#!/bin/bash


set -euo pipefail


for FWD in ${HOME}/scr10/data/raw/*_1.fastq

do

echo "parameter expansion to get forward and reverse output from forward and reverse input"

BASE=$(basename "${FWD}" _1.fastq)

REV="${HOME}/scr10/data/raw/${BASE}_2.fastq"

FWD_OUT="${HOME}/scr10/data/clean/${BASE}_1_cleaned_trimmed.fastq.gz"

REV_OUT="${HOME}/scr10/data/clean/${BASE}_2_cleaned_trimmed.fastq.gz"


echo "fastp command that trims the first 20 bases and last 30 bases from FWD and REV"


if [[ -f "${FWD_OUT}" && -f "${REV_OUT}" ]]; then
    echo "Skipping ${BASE} because it was already processed."
    continue
fi


fastp --in1 "${FWD}" --out1 "${FWD_OUT}" --in2 "${REV}" --out2 "${REV_OUT}" --json /dev/null --html /dev/null --trim_front1 20 --trim_front2 20 --trim_tail1 30 --trim_tail2 30 --n_base_limit 0 --length_required 100 --average_qual 20



done
