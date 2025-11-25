Aarthi Bharathan 11/25/2025

This assignment involved running an entire pipeline of a metagenomic pipeline involving downloading data, cleaning it up, assembling contigs, annotating, and finding coverages. I worked with Sarah Lozina, Namit Nallapaneni, and Vera Pande. I changed the kmer lengths to be 21, 33, 49, 69 in the spade.py parameter during the assembly stage. 
The importance of this assignment was to understand how a metagenomic pipeline works and how small changes, whether it be parameters additions, deletions, or alterations, have the potential to make big changes to annotation results and how they are interpreted. The next step after this submission is to be able to answer the questions about community presence, particular genes (e.g. cellulase gene), their quantity, and what they mean for biological interpretations about an individual, species, or ecosystem.

#1: setup and download

set up scr10 directories and mkdir data to store the accessions in this directory

mkdir scripts

mkdir data


nano data/accessions.txt 


#Parkinsons
ERR1912976
ERR1913073
ERR1913059
ERR1912964
ERR1913119

#Controls
ERR1913016
ERR1913108
ERR1913060
ERR1913044
ERR1913110


nano scripts/00_setup.sh

#!/bin/bash

set -ueo pipefail

# build out data and output structure in scratch directory

## set scratch space for data IO
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC

## set project directory in scratch space
PROJECT_DIR="${SCR_DIR}/mg_assembly_project"

## set database directory
DB_DIR="${SCR_DIR}/db"

## make directories for this project
mkdir -p "${PROJECT_DIR}/data/raw"
mkdir -p "${PROJECT_DIR}/data/clean"
mkdir -p "${PROJECT_DIR}/output"
mkdir -p "${DB_DIR}/metaphlan"
mkdir -p "${DB_DIR}/prokka"

nano scripts/01_download.sh

#!/bin/bash

#SBATCH --job-name=project
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu
#SBATCH -o /sciclone/home/abharathan01/BIOCOMPUTING/assignments/assignment_8/logs/project_%j.out
#SBATCH -e /sciclone/home/abharathan01/BIOCOMPUTING/assignments/assignment_8/logs/project_%j.err

export PATH=$PATH:/sciclone/home/abharathan01/programs/sratoolkit.3.2.1-ubuntu64/bin

# get conda
N_CORES=6
module load miniforge3
eval "$(conda shell.bash hook)"

# DOWNLOAD RAW READS #############################################################

# set filepath vars
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/mg_assembly_project"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"

# if SRA_DIR doens't exist, create it
[ -d "$SRA_DIR" ] || mkdir -p "$SRA_DIR"


# download the accession(s) listed in `./data/accessions.txt`
# only if they don't exist
for ACC in $(cat ./data/accessions.txt)
do

if [ ! -f "${SRA_DIR}/${ACC}/${ACC}.sra" ]; then
prefetch --output-directory "${SRA_DIR}" "$ACC"
fasterq-dump "${SRA_DIR}/${ACC}/${ACC}.sra" --outdir "$DL_DIR" --skip-technical --force --temp "${SCR_DIR}/tmp"
fi

done


# compress all downloaded fastq files (if they haven't been already)
if ls ${DL_DIR}/*.fastq >/dev/null 2>&1; then
gzip ${DL_DIR}/*.fastq
fi

# DOWNLOAD DATABASES #############################################################

# metaphlan is easiest to use via conda
# and metaphlan can install its own database to use
conda env list | grep -q '^metaphlan4-env' || mamba create -n metaphlan4-env metaphlan=4 -c conda-forge -c bioconda


# look for the metaphlan database, only download if it does not exist already
if [ ! -f "${DB_DIR}/metaphlan/mpa_latest" ]; then
conda activate metaphlan4-env
# install the metaphlan database using N_CORES
# N_CORES is set in the pipeline.slurm script
metaphlan --install --db_dir "${DB_DIR}/metaphlan" --nproc $N_CORES
conda deactivate
fi


# prokka (also using conda, also installs its own database)
conda env list | grep -q '^prokka-env' || mamba create -y -n prokka-env -c conda-forge -c bioconda prokka
conda activate prokka-env
export PROKKA_DB=${DB_DIR}/prokka
prokka --setupdb --dbdir $PROKKA_DB
conda deactivate

sbatch scripts/01_download.sh


#Quality Control

nano scripts/02_qc.sh


#!/bin/bash

#SBATCH --job-name=project
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00
#SBATCH --mem=120G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu
#SBATCH -o /sciclone/home/abharathan01/BIOCOMPUTING/assignments/assignment_8/logs/project_%j.out
#SBATCH -e /sciclone/home/abharathan01/BIOCOMPUTING/assignments/assignment_8/logs/project_%j.err


SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/mg_assembly_project"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/clean"
SRA_DIR="${SCR_DIR}/SRA"

for fwd in ${DL_DIR}/*_1.fastq.gz;do rev=${fwd/_1.fastq.gz/_2.fastq.gz};outfwd=${fwd/.fastq.gz/_qc.fastq.gz};outrev=${rev/.fastq.gz/_qc.fastq.gz};fastp -i $fwd -o $outfwd -I $rev -O $outrev -j /dev/null -h /dev/null -n 0 -l 100 -e 20;done

# all QC files will be in $DL_DIR and have *_qc.fastq.gz naming pattern

sbatch scripts/02_qc.sh

#Assembly

nano scripts/03_assembly.sh

#!/bin/bash
#SBATCH --job-name=REPLACEME_Assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu               # change this!
#SBATCH -o /sciclone/home/abharathan01/logs/REPLACEME_assembletest_%j.out # change this!
#SBATCH -e /sciclone/home/abharathan01/logs/REPLACEME_assembletest_%j.err # change this!
# set filepath vars
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/mg_assembly_project"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"
mkdir $CONTIG_DIR
for fwd in ${DL_DIR}/*REPLACEME*1_qc.fastq.gz
do
# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
outdir=$(echo ${CONTIG_DIR}/${samplename})
# run spades with mostly default options. but kmer lengths of 21, 33, 49, 69 (what was changed). Shorter k-mers generally avoid coverage gaps, while longer kmers (such as 69) handle repetitive regions better.
spades.py -1 $fwd -2 $rev -o $outdir -t 20 --meta -k 21,33,49,69
done

# while loop to read through each accession number in accessions.txt and replace the *REPLACEME* in the assembly template script with each accession and make a new assembly script for each sample. 
while read i; do cat ./scripts/03_assemble.sh | sed "s/REPLACEME/$i/g" > ./scripts/${i}_assemble.slurm; done < ./data/accessions.txt

#run the assembly script for each sample.

sbatch scripts/ERR1912964_assemble.slurm
sbatch scripts/ERR1912976_assemble.slurm
sbatch scripts/ERR1913016_assemble.slurm
sbatch scripts/ERR1913044_assemble.slurm
sbatch scripts/ERR1913059_assemble.slurm
sbatch scripts/ERR1913060_assemble.slurm
sbatch scripts/ERR1913073_assemble.slurm
sbatch scripts/ERR1913108_assemble.slurm
sbatch scripts/ERR1913110_assemble.slurm
sbatch scripts/ERR1913119_assemble.slurm


#check that you have your assemblies

cd

cd scr10/mg_assembly_project
#Annotate

nano scripts/04_annotate.sh


#!/bin/bash
#SBATCH --job-name=MG_Annotate
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00 # asking for ten hours since each should only take ~30-60 minutes
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu               # change this!
#SBATCH -o /sciclone/home/abharathan01/scr10/mg_assembly_project/logs/annotate_%j.out # change this!
#SBATCH -e /sciclone/home/abharathan01/scr10/mg_assembly_project/logs/annotate_%j.err # change this!


# set filepath vars
SCR_DIR="${HOME}/scr10" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/mg_assembly_project"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"
ANNOT_DIR="${PROJECT_DIR}/annotations"

# load prokka
module load miniforge3
eval "$(conda shell.bash hook)"
conda activate prokka-env


for fwd in ${DL_DIR}/*1_qc.fastq.gz
do

# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
contigs=$(echo ${CONTIG_DIR}/${samplename}/contigs.fasta)
outdir=$(echo ${ANNOT_DIR}/${samplename})
contigs_safe=${contigs/.fasta/.safe.fasta}

# rename fasta headers to account for potentially too-long names (or spaces)
seqtk rename <(cat $contigs | sed 's/ //g') contig_ > $contigs_safe

# run prokka to predict and annotate genes
prokka $contigs_safe --outdir $outdir --prefix $samplename --cpus 20 --kingdom Bacteria --metagenome --locustag $samplename --force

done

conda deactivate && conda deactivate


sbatch scripts/04_annotate.sh

#Coverage

nano scripts/05_coverage.sh


#!/bin/bash
#SBATCH --job-name=MG_Coverage
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=abharathan01@wm.edu               # change this!
#SBATCH -o /sciclone/home/abharathan01/scr10/mg_assembly_project/logs/annotate_%j.out # change this!
#SBATCH -e /sciclone/home/abharathan01/scr10/mg_assembly_project/logs/annotate_%j.err # change this!
# filepath vars
SCR_DIR="${HOME}/scr10"
PROJECT_DIR="${SCR_DIR}/mg_assembly_project"
DL_DIR="${PROJECT_DIR}/data/raw"
CONTIG_DIR="${PROJECT_DIR}/contigs"
ANNOT_DIR="${PROJECT_DIR}/annotations"
MAP_DIR="${PROJECT_DIR}/mappings"
COV_DIR="${PROJECT_DIR}/coverm"

mkdir -p "${MAP_DIR}" "${COV_DIR}"

# load conda
module load miniforge3
eval "$(conda shell.bash hook)"

# check if coverm-env exists, if not, create it
if ! conda env list | awk '{print $1}' | grep -qx "subread-env"; then     echo "[setup] creating subread-env with mamba";     mamba create -y -n subread-env -c bioconda -c conda-forge subread bowtie2 samtools; fi

# activate env
conda activate subread-env

# main loop
for fwd in ${DL_DIR}/*1_qc.fastq.gz
do
    rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
    filename=$(basename "$fwd")
    samplename=$(echo "${filename%%_*}")
    contigs="${CONTIG_DIR}/${samplename}/contigs.fasta"
    contigs_safe=${contigs/.fasta/.safe.fasta}
    gff="${ANNOT_DIR}/${samplename}/${samplename}.gff"
    bam="${MAP_DIR}/${samplename}.bam"
    cov_out="${COV_DIR}/${samplename}_gene_tpm.tsv"

    echo "[sample] ${samplename}"

    # index contigs if needed
        echo "  [index] bowtie2-build ${contigs_safe}"
        bowtie2-build "${contigs_safe}" "${contigs_safe}"

    # map reads to contigs
        echo "  [map] mapping reads"
        bowtie2 -x "${contigs_safe}" -1 "$fwd" -2 "$rev" -p 8 \
          2> "${MAP_DIR}/${samplename}.bowtie2.log" \
        | samtools view -b - \
        | samtools sort -@ 8 -o "${bam}"
        samtools index "${bam}"

 # run featureCounts per gene (CDS), then compute TPM
    counts="${COV_DIR}/${samplename}_gene_counts.txt"
    tpm_out="${COV_DIR}/${samplename}_gene_tpm.tsv"

    echo "  [featureCounts] counting reads per CDS (locus_tag)"
    featureCounts \
      -a "${gff}" \
      -t CDS \
      -g locus_tag \
      -p -B -C \
      -T 20 \
      -o "${counts}" \
      "${bam}"

    echo "  [TPM] calculating TPM"
    awk 'BEGIN{OFS="\t"}
         NR<=2 {next}                           # skip header lines
         {
           id=$1; len=$6; cnt=$(NF);           # Geneid, Length, sample count is last column
           if (len>0) {
             rpk = cnt/(len/1000);
             RPK[id]=rpk; LEN[id]=len; CNT[id]=cnt; ORDER[++n]=id; SUM+=rpk;
           }
         }
         END{
           print "gene_id","length","counts","TPM";
           for (i=1;i<=n;i++){
             id=ORDER[i];
             tpm = (SUM>0 ? (RPK[id]/SUM)*1e6 : 0);
             printf "%s\t%d\t%d\t%.6f\n", id, LEN[id], CNT[id], tpm;
           }
         }' "${counts}" > "${tpm_out}"

    echo "  [done] ${tpm_out}"

    echo "  [done] ${cov_out}"

# join the coverage estimation info back to the annotation file

ann="${ANNOT_DIR}/${samplename}/${samplename}.tsv"
joined="${ANNOT_DIR}/${samplename}/${samplename}.with_cov.tsv"

echo "  [join] adding coverage columns to annotation TSV"
awk -v FS='\t' -v OFS='\t' -v keycol='locus_tag' '
  # Read TPM table: gene_id  length  counts  TPM
  NR==FNR {
    if (FNR==1) next
    id=$1; LEN[id]=$2; CNT[id]=$3; TPM[id]=$4
    next
  }
  # On the annotation header, find which column is locus_tag
  FNR==1 {
    for (i=1;i<=NF;i++) if ($i==keycol) K=i
    if (!K) { print "ERROR: no \"" keycol "\" column in annotation header" > "/dev/stderr"; exit 1 }
    print $0, "cov_length_bp", "cov_counts", "cov_TPM"
    next
  }
  # Append coverage fields if we have them
  {
    id=$K
    print $0, (id in LEN? LEN[id]:"NA"), (id in CNT? CNT[id]:"0"), (id in TPM? TPM[id]:"0")
  }
' "${tpm_out}" "${ann}" > "${joined}"

echo "  [done] ${joined}"

done


#run the coverage script.

sbatch /scripts/05_coverage.sh

#rename annotation .with_cov.tsv files


cd 

cd scr10/mg_assembly_project/annotations/

mkdir cov_files

##do this for all accession directories, making suring to mark parkinsons/control

mv ERR1912964 ERR1912964_parksinsons_kmer_49_69_Aarthi


##now rename the with_cov.tsv files with what was changed, and move each file into the cov_files directory

cd ERR1912964_parksinsons_kmer_49_69_Aarthi 

mv ERR1912964.with_cov.tsv ../cov_files/ERR1912964_parksinsons_kmer_49_69_Aarthi.with_cov.tsv


Use FileZilla to move the cov_files directory into the BIOCOMPUTING/assignments/assignment directory
