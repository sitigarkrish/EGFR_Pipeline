#Writing, modifying, or fixing shell scripts directly from the terminal.
nano pipeline.sh

# list directory contents
ls

# Decompress FASTQ files and reference genome
gunzip SRR27182345_1.fastq.gz  SRR27182345_2.fastq.gz  chr7.fa.gz

# Perform initial quality control
fastqc SRR27182345_1.fastq  SRR27182345_2.fastq

# Trim adapters and low-quality bases
fastp -i SRR27182345_1.fastq -o trim_SRR27182345_1.fastq -I SRR27182345_2.fastq -O trim_SRR27182345_2.fastq -5 -3 -q 30 --adapter_fasta adapter.fasta.txt

# Perform quality control after trimming
fastqc trim_SRR27182345_1.fastq trim_SRR27182345_2.fastq

# Build BWA index for the reference genome
bwa index -a bwtsw chr7.fa

# Align trimmed reads to chromosome 7
bwa mem -t 9 chr7.fa trim_SRR27182345_1.fastq trim_SRR27182345_2.fastq > bwa_SRR27182345.sam

# Sort alignment
samtools sort bwa_SRR27182345.sam > sorted_SRR27182345.sam

# Convert and inspect SAM file
samtools view -h sorted_SRR27182345.sam > SRR27182345.sam

# Display first ten alignment records
head -10 SRR27182345.sam

# Remove PCR duplicates
samtools rmdup -sS SRR27182345.sam rmdup_SRR27182345.sam

# Creates a sequence dictionary for a reference sequence.
picard-tools CreateSequenceDictionary R=chr7.fa O=chr7.dict

# Assigns all the reads in a file ta single new read-group.
picard-tools AddOrReplaceReadGroups I=rmdup_SRR27182345.sam O=picard_SRR27182345.bam RGLB=lib1 RGPL=illumina RGPU=run RGSM=SRR27182345 SORT_ORDER=coordinate CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT

#Enabling SAMtools and GATK to quickly access specific regions of the reference genome without scanning the entire FASTA file.
samtools faidx chr7.fa

# Call variants using GATK HaplotypeCaller
java -jar ./gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar HaplotypeCaller -R chr7.fa -I picard_SRR27182345.bam -O GATK_output.vcf

