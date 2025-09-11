Aarthi Bharathan 09/10/2025 Assignment_2
#Task 1: Set up workspace on HPC after logging into bora.
#First line makes assignments, notes, projects, practice directories within the BIOCOMPUTING directory
#Second line makes assignment_2 subdirectory within assignments and data subdirectory within assignment_2
#Third line makes the README.md file
mkdir -p ~/BIOCOMPUTING/{assignments,notes,projects,practice}
mkdir -p ~/BIOCOMPUTING/assignments/assignment_2/data
touch ~/BIOCOMPUTING/assignments/assignment_2/README.md

#Task 2: Download NCBI Files, but through curl -o (downloads full URL into local machine)
curl -O ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845
curl -O ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845
#If ftp command worked, it would have been like so.
#gets files from the NCBI FTP server
ftp ftp.ncbi.nlm.nih.gov
	#login with username: "anonymous" and password: email
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/
ls 
get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
bye

#Task 3: File Transfer and Permissions
	#Go to filezilla and make Host: bora.sciclone.wm.edu, Username: W&M username, Password: W&M password,
	 Port: 22, Protocol: SFTP.
	#drag the .gz files from ~/BIOCOMPUTING/assignments/assignment_2/data/ to the HPC
	#move files into repository:
mv GCF_000005845.2_ASM584v2_genomic.fna.gz BIOCOMPUTING/assignments/assignment_2/data
mv GCF_000005845.2_ASM584v2_genomic.gff.gz BIOCOMPUTING/assignments/assignment_2/data
#3.2: Make readable to everyone if not already.
ls -l
chmod go+r GCF_000005845.2_ASM584v2_genomic.fna.gz
chmod go+r GCF_000005845.2_ASM584v2_genomic.gff.gz
	#chmod make sure that it is readable to everybody
ls -l 
#Task 4: Verify File Integrity in local machine and HPC via the following md5sum commands
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
	#Hash of .fna.gz file (local machine): c13d459b5caa702ff7e1f26fe44b8ad7
	#Hash of .gff.gz file (local machine): 2238238dd39e11329547d26ab138be41
	
	#log into bora
	#Hash of .fna.gz file (HPC): c13d459b5caa702ff7e1f26fe44b8ad7
	#Hash of .gff.gz file (HPC): 2238238dd39e11329547d26ab138be41
	#They match!
#Task 5: Bash aliases on local machine 
alias u='cd ..;clear;pwd;ls -alFh --group-directories-first' 
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
alias ll='ls -alFh --group-directories-first'
#alias u moves up one directory, clears the screen, displayes the location of the current
#working directory, lists everything inside human readable and groups directories first
#alias d moves down one directory, clears the screen, lists everything human readable and groups directories first
#alias ll lists everything human readable and groups directories first.
	#enable aliases
source ~/.bashrc


#Reflection
The ftp command was very frustrating as a windows user. I spent hours trying to dodge around it until AI helped me discover the curl -O command. I was also confused about jumping from the HPC to the local machine. Something that I might change next time is that I would see if I can assign a variable to those file names (if possible) and be more regular in updating the README.md.

