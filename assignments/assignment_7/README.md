Aarthi Bharathan 10/20/2025 Assignment_7

Assignment 7 involved taking advantage of the full power of a High Performance Cluster (HPC) by running a slurm job with a pipeline that downloads, cleans, and maps paired-end reads to a reference genome. The programs/special commands used included the ncbi datasets download feature, sra-toolkit (fasterq-dump), bbmap (mapping), and samtools (analyze mapped and matched reads). They were all installed in different ways, including creating/activating a conda environment and loading a module (e.g. for samtools). The status and output of these scripts were stored in err and output files (*.err and *.out).  

#Task 1: Setup assignment_7 directory

#make subdirectoreis within the parent directory via "mkdir -p" and touch a README file. The "mkdir" line below was written in 01_download_data.sh to set the directory structure via script.

mkdir -p data/{clean,dog_reference,raw} output scripts

touch README.md

#Task 2: Download Sequence Data

#search details:
("gut metagenome"[Organism] OR gut microbiome[All Fields]) AND ("biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "strategy wgs"[Properties] OR "strategy wga"[Properties] OR "strategy wcs"[Properties] OR "strategy clone"[Properties] OR "strategy finishing"[Properties] OR "strategy validation"[Properties] AND "filetype fastq"[Properties])

#information about data

Rumen fluid metagenome sample collected from a Holstein dairy cow (Bos taurus) kept at (Ningxia Zhongken Tianning Livestock Co., Ltd., Ningxia, China)

#go to data directory

cd data

#Use FileZilla to drop the csv file to the HPC data directory inside assignment_7.

nano scripts/01_download_data.sh

#!/bin/bash


set -euo pipefail


echo "set up directory structure"

mkdir -p data/{clean,dog_reference,raw} output scripts

#set up another directory structure in scr10 so that big files can stay there before being pushed to github.


mkdir -p ~/scr10/data/{raw,clean,dog_reference}

mkdir -p ${HOME}/scr10/output

#export path

export PATH=$PATH:/sciclone/home/abharathan01/programs/sratoolkit.3.2.1-ubuntu64/bin

echo "download raw data from accessions"

#This conditional outputs the contents of the csv file (it came out as paragraphs), delimits on the comma so that the accession numbers are available, and starts on the second line.
#If the forward and reverse reads do not exist in the data/raw directory inside scr10, use fasterq-dump to download the genome data associated with the accession numbers.
for i in $(cat data/SraRunTable.csv | cut -d "," -f1 | tail -n +2); do
    if [ ! -f "${HOME}/scr10/data/raw/${i}_1.fastq" ] && [ ! -f "${HOME}/scr10/data/raw/${i}_2.fastq" ]; then
        echo "Downloading $i..."
        fasterq-dump --threads 8 $i -O ${HOME}/scr10/data/raw/

    fi
done

#Use the curl command to make the datasets command accessible

curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets'

chmod +x datasets

#This conditional downloads the reference genome into the scr10 space, into a dog.zip file inside the dog_reference directory within the data directory if the zip file
#does not already exist. The -o flag specifies the directory where dog.zip will be unzipped. 
if [ ! -f "$HOME/scr10/data/dog_reference/dog.zip" ]; then
    ./datasets download genome taxon "Canis familiaris" --reference --filename ${HOME}/scr10/data/dog_reference/dog.zip
    unzip -o ${HOME}/scr10/data/dog_reference/dog.zip -d ${HOME}/scr10/data/dog_reference
else
    echo "Dog reference was downloaded."
fi



#Task 3: Clean Up Raw Reads

nano 02_clean_reads.sh

#!/bin/bash


set -euo pipefail

#for loop where every dorward read (ends with _1.fastq) in the data/raw directory within the scr10 space is accessed

for FWD in ${HOME}/scr10/data/raw/*_1.fastq

do

echo "parameter expansion to get forward and reverse output from forward and reverse input"

#Use basename to get the accession number from the forward read file name and removes the _1.fastq suffix. This is stored in a variable so its accessible for 
#storing the reverse reads, which is the accession number and the _2.fastq suffix. The output files for the forward and reverse reads are also renamed and placed in
#the data/clean directory within the scr10 space.
BASE=$(basename "${FWD}" _1.fastq)

REV="${HOME}/scr10/data/raw/${BASE}_2.fastq"

FWD_OUT="${HOME}/scr10/data/clean/${BASE}_1_cleaned_trimmed.fastq.gz"

REV_OUT="${HOME}/scr10/data/clean/${BASE}_2_cleaned_trimmed.fastq.gz"


echo "fastp command that trims the first 20 bases and last 30 bases from FWD and REV"

#the conditional checks if the output files already exist and skip the fastp cleaning process if so.

if [[ -f "${FWD_OUT}" && -f "${REV_OUT}" ]]; then
    echo "Skipping ${BASE} because it was already processed."
    continue
fi

#Take the forward and reverse reads as inpuut, and make FWD_OUT and REV_OUT the output. Trim the first 20 bases and last 30 bases from the input. Make the average quality 20 with a required length of at least 100.

fastp --in1 "${FWD}" --out1 "${FWD_OUT}" --in2 "${REV}" --out2 "${REV_OUT}" --json /dev/null --html /dev/null --trim_front1 20 --trim_front2 20 --trim_tail1 30 --trim_tail2 30 --n_base_limit 0 --length_required 100 --average_qual 20



done


#this was a strategy used to test out the script on just the first 10 reads to make sure the script worked properly and the data was cleaned.
#This was done by setting up another directory (TMP) to store the practice run data with the first 10 reads.
#!/bin/bash

set -euo pipefail


for FWD in ./data/raw/*_1.fastq

do

echo "parameter expansion to get forward and reverse output from forward and reverse input"

BASE=$(basename "${FWD}" _1.fastq)

REV="./data/raw/${BASE}_2.fastq"

FWD_OUT="./data/clean/${BASE}_1_cleaned_trimmed.fastq.gz"

REV_OUT="./data/clean/${BASE}_2_cleaned_trimmed.fastq.gz"

mkdir -p tmp

TMP="./data/tmp"
FWD_TMP="${TMP}/${BASE}_1.tmp.fastq
REV_TMP="${TMP}/${BASE}_2.tmp.fastq
head -n 40 "${FWD}" > "${FWD_TEMP}"

head -n 40 "${REV}" > "${REV_TEMP}"
echo "fastp command that trims the first 20 bases and last 30 bases from FWD and REV"

echo "conditional"

if [[ -f "${FWD_OUT}" && -f "${REV_OUT}" ]]; then
    echo "Skipping ${BASE} because it was already processed."
    continue
fi


fastp --in1 ${FWD_TMP} --out1 ${FWD_OUT} --in2 ${REV_TMP} --out2 ${REV_OUT} --json /dev/null --html /dev/null --trim_front1 20 --trim_front2 20 --trim_tail1 30 --trim_tail2 30 --n_base_limit 0 --length_require>



done


#Task 4 and 5: Map clean reads to dog genome and extract the files.

nano scripts/03_map_reads.sh

#!/bin/bash

set -euo pipefail

echo "initialize and activate conda environment"


module load miniforge3

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

#If you need to create the environment: conda create -y -n bbmap-env bbmap -c bioconda
conda activate bbmap-env

conda env export --no-builds > bbmap-env.yml


#preset the reference variable, as the reference data lives in the ncbi_dataset data directory within the scratch space in the data/dog_reference directory. 
 
REF="${HOME}/scr10/data/dog_reference/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna"

#samtools

#module load the samtools software to install it.

module load samtools/gcc-11.4.1/

#check the version to make sure the right one is being used.
samtools --version


#for loop to iterate through the cleaned forward reads.
for i in ${HOME}/scr10/data/clean/*_1_*

do

#access just the accession numbers again with basename for the cleaned forward files and get rid of the suffix to make it usable for renaming the reverse cleaned reads and the output sam files.
BASE=$(basename "$i" _1_cleaned_trimmed.fastq.gz)

REV="${HOME}/scr10/data/clean/${BASE}_2_cleaned_trimmed.fastq.gz"

SAM_OUTPUT="${HOME}/scr10/output/${BASE}.sam"

#This conditional ensures that if the .sam file for an accession number already exists, there is no need to map again. 
if [[ -f ${HOME}/scr10/output/${BASE}_dog-matches.sam ]]; then
    echo "Skipping ${BASE} — already mapped (./output/${BASE}_dog-matches.sam exists)."
    continue
fi

#bbmap to map the reads to the dog reference genome. -Xmx20g was to set the maximum memory to 20G.
#This will take the set variables as input nad make the minimum alignment identity 95%. 
#Samtools will view the mapped output and make a new file with the matches (*.dog_matches.sam).
bbmap.sh -Xmx20g ref=${REF} in1=${i} in2=${REV} out=${SAM_OUTPUT} nodisk=t ambiguous=best minid=0.95

samtools view -F 4 -h ${SAM_OUTPUT} > ${HOME}/scr10/output/${BASE}_dog-matches.sam

done


conda deactivate



#Task 6: Slurm
nano assignment_7.slurm

#!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu               # change this!
#SBATCH -o ./output/assignment_7_%j.out # change this!
#SBATCH -e ./output/assignment_7_%j.err # change this!

export PATH=$PATH:~/programs


module load miniforge3

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

echo "pipeline scripts"
bash ./scripts/01_download_data.sh
bash ./scripts/02_clean_reads.sh
bash ./scripts/03_map_reads.sh

#The PATH will be exported to make all commands of the different programs available when the scripts are run. 
#The job name is assignment_7, this is one task that uses one node, but 20 cpus were used to make the job faster, such that the different cores split the work. A time limit of one day was given to be safe 
#and 120G of memory was set to be safe as well. My email was given to get updates about when my job began, failed, ended. 
#The output and error files contain the information about the job's status, (*.out and *.err respectively).

#run the pipeline!

sbatch assignment_7.slurm

#Task #7: Check output files

#cleaning to remove any extra files
#I removed the md5sum, zip, jsonl, and json files.
rm ${HOME}/scr10/data/dog_reference/*.zip ${HOME}/scr10/data/dog_reference/*.sum

rm ${HOME}/scr10/data/dog_reference/ncbi_dataset/data/*.jsonl ${HOME}/scr10/data/dog_reference/ncbi_dataset/data/*.json

#I did not expect this, but the error file had all the information about the mapped reads, while the output file had more information on the behind the scenes during the downloading, cleaning, extracting, etc.

cat assignment_7_228930.err

cat assignment_7_228930.out 

#Task #8: Table
#Manually implemented by reading through the .err file in a separate terminal.

cat output/assignment_7_228930.err

nano output/table.sh

chmod +x output/table.sh

|--Sample ID--| Total Reads|-----Dog-Mapped Reads----|
|-------------|------------|-------------------------|
| SRR35817850 | 44,822,254 | Read 1: 27, Read 2: 173 |
| SRR35817851 | 37,855,056 | Read 1: 38, Read 2: 180 |
| SRR35817852 | 42,216,280 | Read 1: 31, Read 2: 168 |
| SRR35817853 | 42,364,684 | Read 1: 29, Read 2: 290 |
| SRR35817854 | 44,110,702 | Read 1: 70, Read 2: 233 |
| SRR35817855 | 47,261,754 | Read 1: 26, Read 2: 283 |
| SRR35817856 | 45,969,128 | Read 1: 13, Read 2: 190 |
| SRR35817857 | 45,585,004 | Read 1: 16, Read 2: 313 |
| SRR35817858 | 37,885,428 | Read 1: 23, Read 2: 322 |
| SRR35817859 | 45,371,516 | Read 1: 34, Read 2: 412 |
| SRR35817860 | 45,618,702 | Read 1: 48, Read 2: 503 |


#Task 9

#Reflection

>>This assignment was a hefty one, and it definitely took the most patience and learning in comparison to the other assignments. Before even starting the assignment, I was apprehensive of failed jobs, big files living in spaces where they should not be, and time limits not being met by the deadline. I was grateful that a part of last class was spent learning about conditionals via ChatGPT. I had many failed jobs, but they would cut off midway somewhere, so it was a relief knowing that I did not have to start over, when part of the task was already completed. 

>>The most challenging part of this assignment was ensuring that file paths were not bungled and causing traffic. I still struggle with maintaining the correct file paths, and it often took me a long time to address the error because I was constantly switching between the scr10 space and my BIOCOMPUTING/assignments/assignment_7 directory. Additionally, waking up to an email about a failed job was also disappointing, but it was part of the learning process of this skill.

>>Also, I have only ever submitted small jobs that would take a maximum of 30 minutes to run outside of this class, so the practice with large files was a way for me to learn how to address errors in my scripts quicker. Moreover, patience was a key skill to have in this assignment. Not only did the jobs take a while to complete, but writing the scripts was also difficult for me because of the different file paths and forgotten parameters. I had to make sure I was hopping between assignments and lessons to recheck parameters and confirm new ones I have never seen with ChatGPT. In fact, this assignment also drove more interactions with the agent to maximize efficiency. 

>>Overall, I learned about the effectiveness and mass task completion that can be achieved via an HPC pipeline. This taught me how real, large data can be manipulated if the full power of the HPC is taken advantage of. While this assignment was a scary big step forward, where it was away from the familiar with manageable files and shorter tasks, it was also a good first exposure to the reality of a bioinformatician’s day and the main purpose of the HPC.










