Aarthi Bharathan 09/23/2025 Assignment_4
#Assignment 4 involves using bash scripts and creating paths to save programs, such as gh and seqtk, and make bash scripts that run the instructions/commands that assign these to the $PATH. Moreover, this assignment involves practice with variable assignment with positional arguments and writing for loops to receive desired input from different .fasta files. 
#Task 1: Make a special directory in $HOME called "programs" 

cd 

mkdir programs


#Task 2: Download and unpack the gh "tarballl" file

#download gh file

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

#look around to make sure that the file was actually downloaded in the $HOME directory

ls

#move the gh file into the programs directory 

mv gh_2.74.2_linux_amd64.tar.gz ~/programs/

#unpack the gzipped tarball

cd programs

tar -xzvf gh_2.74.2_linux_amd64.tar.gz

#Task 3: Build a bash script from task 2

nano install_gh.sh

#copy/paste task 2 (except for the ls) into install_gh.sh script; include rm gh_2.74.2_linux_amd64.tar.gz for cleanup

#Task 4: Run your install_gh.sh script

#make file executable

chmod +x install_gh.sh

ls -l

./install_gh.sh

#Task 5: Add the location of the gh binary to your $Path.

cd gh_2.74.2_linux_amd64
 
pwd

cd

export PATH=$PATH:/sciclone/home/abharathan01/programs/gh_2.74.2_linux_amd64/bin

which $PATH 

#Task 6: Run gh login to setup GitHub username and password.

cd

gh auth login

#click enter and copy first-time code to enter into verification process of web browser 

#Task 7: Create another installation script for seqtk


cd programs

wget https://github.com/lh3/seqtk

nano install_seqtk.sh

#add commands into the script and echo instruction to add the directory that has seqtk to $PATH

#This echos the instructions to the end of the ~/.bashrc file:

echo "export PATH=$PATH:/sciclone/home/abharathan01/programs" >> ~/.bashrc

chmod +x install_seqtk.sh

#test out script

./install_seqtk.sh

#Task 8: Figure out seqkt

#seqkt commands on github

#example tries with assignment_3 data

cd ../BIOCOMPUTING/assignments/assignment_3/data

#FASTQ to FASTA (although this is already a FASTA file)

seqtk seq -a GCF_000001735.4_TAIR10.1_genomic.fna > out.fa

#Folds long FASTA/Q lines and removes comments
seqtk seq -Cl60 GCF_000001735.4_TAIR10.1_genomic.fna > out.fa

#Task 9: Write summarize_fasta.sh script of bash tools and functionality of seqtk

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
echo "var1 counts the number of lines that does not start with >, which is the lines that contain the >
echo "var2 gives the number of total sequences and total number of nucleotides via seqtk size; but the>
echo "var3 makes a file with just the headers and another file with the sequences and pasts them toget>

#Task 10: Run 'summarize_fasta.sh' in a loop on multiple files. 


for i in *.fasta *.fna; do ./summarize_fasta.sh $i; sleep 1; done

#All data files within the data directory were deleted because they were too large for github. Table of sequence names and lengths from example fasta files live in data directory.

#Task 11: Reflection

This assignment involved practice with writing scripts and adding file/program locations to the $PATH. Personally, I struggled most with the latter and adding the path to ~/.bashrc. I had trouble confirming that my program was actually added. There was a point in time where the gh command was not working, so I kept getting error messages. It took me a while to realize that I did not add the gh binary properly to the $PATH variable. Moreover, the “gh auth login” prompt did not direct me to a web browser to complete the authentication process in GitHub. I had to manually complete it by pasting the github link from the terminal to my web browser. However, when I later tried to push my assignment, it asked for my login information and notified me that password authentication is not supported. 

However, I later learned that the authentication code token is an alternative to going to the website through the browser. These technical issues recurrently pop up across assignments, but they are also opportunities that prepare me for the likely event that these problems arise again. I also learned more about assigning variables in a script and referring to positional arguments. This was a good opportunity for me to practice using the associated notation to produce desired output from arguments that would pass through these scripts. Moreover, I learned more about the “seqtk” program and its function when working with fasta files. They facilitate the manipulation of genetic sequence information, as it simplifies the process of counting the number of nucleotides, sequence names, etc. via commands like “seqtk comp” and “seqtk size” in combination with unix tools that I already knew.

Additionally, I was able to practice with the for loop and asterisk to be able to analyze multiple fasta files. This is important when several files of different genetic sequences must be considered, and it simplifies the process by a huge factor. Overall, this assignment exposed how much I was unfamiliar with the procedures involved with scripting and setting up a PATH variable, but it consequently made me more confident in this syntax. I now know that $PATH is a variable that contains the absolute paths of programs and/or directories. Exporting paths of different directories to this variable allows for the contents to be referenced anywhere in the terminal. The directories listed under PATH can be found when it is echoed, and executable files can be referenced to actually accept commands like “seqtk” and “gh.”


