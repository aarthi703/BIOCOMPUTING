#This assignment involved the creation of a mock project folder.

Within assignment_01, a mock project folder structure was created to practice making 
directories, subdirectories, and placeholder files. This was important to understand the 
significance of data organization and reproducibility. 


The following code makes the following subdirectories: data (with directories named raw and clean inside data), 
scripts, results, docs, config, logs:

mkdir -p data/{raw,clean} scripts results docs config logs 

This creates the files assignment_01_essay.md and README.md within assignment_01:

touch assignment_01_essay.md README.md 

To make placeholder files within each subdirectory, the following was written:
cd was used to go into each subdirectory, the touch command was to make the files, and cd ..
allowed for exit from that specific subdirectory:

cd scripts

touch script.sh

cd .. 

cd logs

touch logfile.log

cd ..

cd docs

touch example.txt

cd ..

cd config

touch another_text.txt

cd ..

cd results 

touch results.xlsx

