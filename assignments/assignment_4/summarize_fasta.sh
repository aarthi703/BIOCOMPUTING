#!/bin/bash

#accept name of fasta file as positional argument.

filename=$1

#Total number of sequences

var1=$(cat ${filename} | grep -v ^[">"] | wc -l)

#Total number of nucleotides

var2=$(cat ${filename} | seqtk size | cut -f2)

#Table of sequence names
cat ${filename} | grep ^[">"] > names.txt
cat ${filename} | seqtk comp | cut -f2 > sequences.txt
paste names.txt sequences.txt > table.txt
var3=$(cat table.txt) 

#Report to standard output
echo $var1 $var2 $var3
echo "var1 counts the number of lines that does not start with >, which is the lines that contain the sequences."
echo "var2 gives the number of total sequences and total number of nucleotides via seqtk size; but the the column with the total number of nucleotides is cut"
echo "var3 makes a file with just the headers and another file with the sequences and pasts them together." 

