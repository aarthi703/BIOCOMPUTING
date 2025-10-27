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














































  GNU nano 5.6.1                                            assignment_7.slurm                                             Modified
#!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu               # change this!
#SBATCH -o /sciclone/home/abharathan01/logs/firstjob_%j.out # change this!
#SBATCH -e /sciclone/home/abharathan01/logs/firstjob_%j.err # change this!


bash ./scripts/01_download_data.sh
bash ./scripts/02_clean_reads.sh
bash ./scripts/03_map_reads.sh


















































^G Help         ^O Write Out    ^W Where Is     ^K Cut          ^T Execute      ^C Location     M-U Undo        M-A Set Mark
^X Exit         ^R Read File    ^\ Replace      ^U Paste        ^J Justify      ^_ Go To Line   M-E Redo        M-6 Copy

bash ./scripts/01_download_data.sh
bash ./scripts/02_clean_reads.sh
bash ./scripts/03_map_reads.sh
