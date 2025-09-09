#make directory structure
mkdir practice_01
 mkdir -p data/{clean,raw} output scripts
#make files
touch data/metadata.csv scripts/{01_QC.sh,02_assemble.sh,03_bin.sh,04_refine.sh,05_annotate.sh} README.md workflow.sh

#README
“# My new project”
“"
“Raw data are in ./data/raw”
“”
“All scripts are in ./scripts”
“”
“./workflow.sh contains ordered instructions for running scripts”
