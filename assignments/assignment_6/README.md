Aarthi Bharathan 10/09/2025 Assignment_6 
Assignment 6 involved installing the Flye program with three different methods: manual local build, using the conda environment, and using the module environment. The log file outputs allowed for an analysis of the outputs of each method.

#Task #1: Setup Directory

#add this to scripts/01_download_data.sh to help the pipeline.

#Task #2: Donwload raw ONT data


nano ./scripts/01_download_data.sh

#!/bin/bash

set -euo pipefail

#make directories
mkdir -p assemblies/{assembly_conda,assembly_local,assembly_module} data scripts


set -ueo pipefail

#download data into the data directory
wget -P ./data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

#chmod +x to make the script executable
chmod +x ./scripts/01_download_data.sh

#run the script
./scripts/01_download_data.sh

#Task 3: Get Flye v2.9.6

nano scripts/02_flye_2.9.6_manual_build.sh

#in flye_2.9.6_manual_build.sh

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

#check that it is actually in programs.

cd ~/programs/Flye/bin

#copy path
pwd


#go back to assignment_6

cd ../../../BIOCOMPUTING/assignments/assignment_6

#add program to $PATH

#this path is what was inside the script.



#Task #4: Get Flye v2.9.6 (conda build)
#!/bin/bash

set -euo pipefail


#load the module and initialize conda.

module load miniforge3

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

#build the environment using mamba (version 2.9.6).

mamba create -n flye-env flye=2.9.6 -y

#activate flye_env.

conda activate flye-env

#test

flye -v

#document the environment.

conda env export --no-builds > flye-env.yml

#deactivate
conda deactivate


#make script executable
chmod +x ./scripts/02_flye_2.9.6_conda_install.sh

#run the script
./scripts/02_flye_2.9.6_conda_install.sh


#Task 5: Decipher how to use Flye.

nano scripts/03_run_flye_local.sh


--nano-hq is for high-quality data (<3% error), -g size allows for the specification of the genome size (49.5Mb, so this was rounded to 50Mb), -t 6 is to use up to 6 threads on the login node, and --meta is to cover more than one genome in this dataset as there may be more than one phage. -o is for the output directory: ./assemblies/(any of the subdirectories)


flye --nano-hq path -g size 50Mb -t 6 --meta -o #here goes the output directory

#Task 6A: Run Flye using conda

nano ./scripts/03_run_flye_conda.sh

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

#make the script executable.

chmod +x ./scripts/03_run_flye_conda.sh
 
#run it

./scripts/03_run_flye_conda.sh

#check that the .fasta and .log files were renamed and files were cleared.

cd assemblies/assembly_conda

ls

cd ../../

#Task 6B: Use the module environment.


nano scripts/03_run_flye_module.sh

#!/bin/bash

set -euo pipefail

module load Flye/gcc-11.4.1/2.9.6

echo "run flye"

flye --nano-hq data/SRR33939694.fastq.gz -g 50k -t 6 --meta -o ./assemblies/assembly_module

cd ./assemblies/assembly_module

echo "rename the assembly.fasta and fly.log files to module_assembly.fasta and module_fly.log respectively"
mv assembly.fasta module_assembly.fasta

mv flye.log module_flye.log

#remove extra files.
rm -r 00-assembly 30-contigger 10-consensus 40-polishing 20-repeat *.gfa *.gv *.txt *.json

cd ../../

#make it executable

chmod +x ./scripts/03_run_flye_module.sh

#run

./scripts/03_run_flye_module.sh

#double check the .fasta and .log files.

cd assemblies/assembly_module

ls

cd ../../

#Task 6C: Use the local build

nano scripts/03_run_flye_local.sh

#!/bin/bash

set -euo pipefail

#add Flye to the PATH

export PATH=$PATH:$HOME/programs/Flye/bin

echo "run the manual build script"

./scripts/02_flye_2.9.6_manual_build.sh

flye --nano-hq data/SRR33939694.fastq.gz -g 50k -t 6 --meta -o ./assemblies/assembly_local

#rename .log and .fasta files to local_assembly.fasta and local_flye.log

cd assemblies/assembly_local


echo "rename the files"

mv assembly.fasta local_assembly.fasta

mv flye.log local_flye.log

#remove the extra files
rm -r 00-assembly 30-contigger 10-consensus 40-polishing 20-repeat *.gfa *.gv *.txt *.json

cd ../../

#make it executable 

chmod +x scripts/03_run_flye_local.sh

#get rid of the existing program.

rm -rf ~/programs/Flye

#run the script.

./scripts/03_run_flye_local.sh

#check that the files were cleared and renamed.

cd assemblies/assembly_local

ls 

cd ../../
#Task 7: Compare the results in the log files.

find ./assemblies -type f -name "*flye.log"

tail -n 10 ./assemblies/assembly_conda/conda_flye.log

tail -n 10 ./assemblies/assembly_module/module_flye.log

tail -n 10 ./assemblies/assembly_local/local_flye.log

#there is no difference between the last 10 lines of the three methods. They are doing the same thing in different ways.

#Task 8: Build pipeline.sh script

#!/bin/bash

set -euo pipefail

echo "run scripts"

./scripts/01_download_data.sh


./scripts/03_run_flye_conda.sh

./scripts/03_run_flye_module.sh

./scripts/03_run_flye_local.sh
echo "print results to STDOUT"

find ./assemblies -name "*flye.log"

tail -n 10 ./assemblies/assembly_conda/conda_flye.log

tail -n 10 ./assemblies/assembly_module/module_flye.log

tail -n 10 ./assemblies/assembly_local/local_flye.log



#make it executable.

chmod +x pipeline.sh

#Task 9: Delete everything.
#remove everything except the scripts.

rm -r assemblies data flye-env.yml

#remove the Flye program.

rm -rf ~/programs/Flye

#run the pipeline.
#this pipeline will assemble the reads, building the genome using flye that was installed in three different ways
./pipeline

#remove data to push to github

rm -r data

#copy into backup

cp -r assignment_6 ../../backup/BIOCOMPUTING/assignments/


#Task 10

#Reflection

>>>This assignment involved applying the different installation methods (manual software build, conda, and module load) to use the assembly program, Flye. I had trouble differentiating conda and module load because I forgot that conda had its own module load, which causes it to require a couple more steps than the module method. Additionally, making the pipeline was a lengthy process because my 02_flye_2.9.6_manual_build.sh script adds the flye program to the path. This means that every time I tried to troubleshoot the pipeline and rerun it, there would be a fatal error because the Flye program already existed, and it could not be reinstalled. I later learned that I had to rm -rf ~/programs/Flye to retest the pipeline. 
>>>Moreover, I had a challenging time learning about the different flags of the Flye program and renaming the .fasta and .log files. The latter was because I was first using the wildcard symbol (*), which made the move command interpret it as having to move multiple files into some kind of directory, so I kept getting an error saying that conda_assembly.fasta was not a directory to move the files into. 
>>>I also kept trying to run the script that installs conda inside the one that runs it without loading the miniforge module, so the output kept warning that it could not recognize the flye command. I later learned that flye only works inside the script, so I would have to module load miniforge once again inside the script that runs conda, in order for the environment to be activated.
>>>I learned to be more aware when activating and deactivating environments within scripts, and I learned how much time and efficiency changes with each method. For example, personally, the module load method seems much faster and efficient to me only because it felt like it ran faster in comparison to methods like the manual build. This was the longest run time out of any assignment as well, so having to be patient with each error was key to pinpoint the cause of it. 
>>>In the next assignment, I may go for the module load method because it feels faster and less writing heavy, which saves time that could be spent in trying to crack the code for tasks. However, as a student in a data science class as well, I felt a bit familiar with the conda environment method. However, the source command to initialize it is something that I would have to keep practicing because I am used to conda init, so I would still prefer module load.
>>>Overall, this assignment taught me how the three methods can achieve the same goal with different efficiency rates, and it seems that the chosen method depends on the task at hand. 

