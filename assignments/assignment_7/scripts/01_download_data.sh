#!/bin/bash

set -euo pipefail


echo "set up directory structure"

mkdir -p data/{clean,dog_reference,raw} output scripts

mkdir -p ~/scr10/data

mkdir -p ~/scr10/data/{raw,clean,dog_reference}

export PATH=$PATH:/sciclone/home/abharathan01/programs/sratoolkit.3.2.1-ubuntu64/bin

echo "download raw data from accessions"

for i in $(cat data/SraRunTable.csv | cut -d "," -f1 | tail -n +2); do
    if [ ! -f "${HOME}/scr10/data/raw/${i}_1.fastq" ] && [ ! -f "${HOME}/scr10/data/raw/${i}_2.fastq" ]; then
        echo "Downloading $i..."
        fasterq-dump --threads 8 $i -O ~/scr10/data/raw/

    fi
done

curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets'

chmod +x datasets

if [ ! -f "$HOME/scr10/data/dog_reference/dog.zip" ]; then
    ./datasets download genome taxon "Canis familiaris" --reference --filename ~/scr10/data/dog_reference/dog.zip
    unzip -o ~/scr10/data/dog_reference/dog.zip -d ~/scr10/data/dog_reference
else
    echo "Dog reference was downloaded."
fi


