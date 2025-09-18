Aarthi Bharathan 09/17/2025 Assignment_3

Assignment_3 required the use of unix command line tools to explore a DNA sequence file. Using different commands such as cat, grep, wc, head, tr, pipes, paste, etc. This was important to understand how to analyze genomic data through unix tools that can be combined to perform complex tasks, including counting, filtering, and summarizing. 

#Task 1: Navigate to the assignment_3 directory and create the data subdirectory and README.md file.

log into astra server via ssh.

cd BIOCOMPUTING/assignments/assignment_3

mkdir data

touch README.md

#Task 2: Download the fasta sequence file using wget and unzip the file inside the data subdirectory.

#wget command downloads the file through a url

cd data

wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz

#gunzip unzips the file.

gunzip GCF_000001735.4_TAIR10.1_genomic.fna

#Task 3

#1: Count sequences in FASTA file (cat displays the contents of the file top to bottom; count the lines that do not start with ">" using grep command).

cat  GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | wc -l

#2: Count total number of nucleotides (excluding new lines by deleting it and exclude header lines via grep -v).

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | tr -d "\n" | wc -m

#3: How many total lines are in the file (wc -l counts the number of lines)?

cat GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

#4: Count how many headerlines contain "mitochondrion".

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep ^[">"]| grep "mitochondrion" | wc -l

#5: Count how many header lines contain the word "chromosome".

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep ^[">"]| grep "chromosome" | wc -l

#6: How many nucleotides are in each of the first 3 chromosome sequences (tr excludes new lines and head counts the number of characters in the first n sequence, with tail considering the count of characters in the last n sequences specified from the first n)?

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | tr -d "/n" | head -n 1 | wc -m

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | tr -d "/n" | head -n 2 | tail -n 1 | wc -m
 
cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | tr -d "/n" | head -n 3 | tail -n 1 | wc -m

#7: How many nucleotides are in the sequence for 'chromosome 5'?

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | tr -d "/n" | head -n 5 | tail -n 1 | wc -m

#8: How many sequences contain "AAAAAAAAAAAAAAAA" (grep -v ^[">"] was used to exclude headers, but this would have worked without that because this sequence of As is not in the header)?

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] | grep "AAAAAAAAAAAAAAAA" | wc -l

#9: First sequence header in list after sorting alphabetically.

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep ^[">"] | sort | head -n 1

#10: Tab-separated version of file: first column is headers and the second column is the associated sequences.

#save headers into a file called header.txt.

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep ^[">"] > header.txt

#save sequences into a file called sequences.txt.

cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v ^[">"] > sequences.txt

#combine contents of header.txt and sequences.txt into a tab-separated file called tab_separated.txt (paste combines the two files into one with both columns of headers and sequences; nano allows for visualization of tab-separated file).

paste header.txt sequences.txt > tab_separated.txt 

nano tab_separated.txt



#Task 5: Reflection

This assignment involved practicing unix tools and/or commands to manipulate file contents. In theory, this seems simple enough, but remembering when to use what commands and identifying various associated flags was difficult. It really does take practice to forge the muscle-memory necessary to quickly respond to different prompts and perform different tasks that are required in the vast genomics world.

As a beginner in using these unix tools, what frustrated me the most was when I could not figure out what puzzle pieces fit together via piping to different programs and/or redirecting to different files. The syntax was sometimes confusing, so I had to really break down the prompt and consider commands that are known for performing the verbs. For example, in step 2 of task 3, I did not know how to exclude new lines in counting the total number of nucleotides in the fasta file, and I kept seeking refuge with grep -v to exclude “\n”. However, I did not consider the additional flags of the translate (tr) command. There is a -d flag that deletes the character of interest entirely, so I could count the characters without counting that specific character, and grep -v worked with excluding the headers (grep -v “>”). Steps that required combining multiple commands were challenging. 

I was once again stumped at step 10 of task 3. At first, I kept considering changing the original fasta file, but I did not know how to make the headers and sequences different columns in one line. I then remembered the first task of 03_PRACTICE, where we were asked to combine two files–one with a column of letters and the other with a column of numbers–into a separate file. I was using cut -d “\n” -f2 to delimit the new lines, but that did not create tabs, and translating them into tabs was also not successful because I did not know how to compile every other row into one column. Therefore, making the headers one column, the associated sequences another column, and combining them into a file with the paste command allowed for the two columns to be tab-separated in the new file. 

Moreover, I was surprised at how I did not need to use some unix commands (e.g. cut). This made me worry that I was missing a concept, but I also learned about new flags for different commands in the process of exploring other commands. All of these surprising tools are necessary for computational biology because they facilitate genomic analysis when given a file with large data. Understanding data organization/handling is important in order to consider important biological factors (e.g. number of nucleotides, number of sequences, number of a certain base, etc.) and make biological conclusions from that data observations. These skills train the mind to merge data science and biology skills to make computational biology possible. 

The documentation of these solutions help with its reproducibility and eventual automation. Documentation is synonymous to evidence of things that worked (and did not) in solving these different problems, and its existence can help build pipelines to decrease the load of human intervention. However, it must be done in a manner that does not limit the necessary human critical thinking to make meaningful biological conclusions and analyses. Automation should merely be a partner and not a dictator of future projects.
