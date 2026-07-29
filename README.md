# EGFR_Pipeline
Developed an end-to-end NGS variant calling pipeline for EGFR using Linux, FastQC, fastp, BWA, SAMtools, Picard, GATK, and Ensembl VEP, from raw paired-end sequencing reads to functionally annotated genetic variants.

## Data Collection

This project focuses on the **Epidermal Growth Factor Receptor (EGFR)** gene, a receptor tyrosine kinase encoded on **human chromosome 7 (7p11.2)**. EGFR plays a crucial role in regulating cell growth, proliferation, and survival. Mutations in this gene are frequently associated with several cancers, particularly **non-small cell lung cancer (NSCLC)**, making it an important target for genomic analysis and precision medicine.

Paired-end Illumina sequencing data for the EGFR region (**SRA Accession: SRR27182345**) were downloaded from the **European Nucleotide Archive (ENA)** using the **Sequence Read Archive (SRA)**. Paired-end sequencing generates reads from both ends of DNA fragments, providing improved alignment accuracy and more reliable variant detection.

The **GRCh38 human chromosome 7** reference sequence was downloaded from the **UCSC Genome Browser**, as it contains the EGFR gene and serves as the reference for read alignment and variant calling.

The analysis was performed in **Windows Subsystem for Linux (WSL)**. After confirming the downloaded files using the `ls` command, all compressed FASTQ and reference genome files were extracted using `gunzip`. The required bioinformatics tools were then installed before initiating the NGS analysis pipeline.

## Workflow

1. **Quality Assessment (FastQC)**
   - Performed initial quality assessment of the raw paired-end FASTQ files using **FastQC**.
   - The generated HTML reports were examined to evaluate sequencing quality, GC content, sequence duplication, and adapter contamination.

2. **Read Trimming (fastp)**
   - Based on the FastQC reports, low-quality bases and adapter sequences were removed using **fastp**.
   - Adapter trimming was performed using **Illumina Universal Adapter**, **PolyA**, and **PolyG** sequences to improve read quality.

3. **Post-trimming Quality Assessment (FastQC)**
   - FastQC was performed again on the trimmed reads to verify improvements in sequence quality and confirm successful adapter removal.

4. **Reference Genome Indexing and Read Alignment (BWA)**
   - The reference **Chromosome 7 (GRCh38)** was indexed using **BWA**.
   - Trimmed paired-end reads were aligned to the reference genome using the **BWA-MEM** algorithm.

5. **Alignment Processing (SAMtools)**
   - Alignment files were sorted and inspected using **SAMtools** to prepare them for downstream analysis.
   - PCR duplicate reads were removed to minimize bias during variant calling.

6. **Read Group Assignment (Picard)**
   - **Picard** was used to create the reference sequence dictionary and assign read groups, ensuring compatibility with GATK.

7. **Variant Calling (GATK)**
   - **GATK HaplotypeCaller** was used to identify genetic variants from the processed alignment files, producing a VCF file.

8. **Variant Annotation (Ensembl VEP)**
   - The variants identified by GATK were annotated using the **Ensembl Variant Effect Predictor (VEP)** to determine their functional consequences, clinical significance, and predicted effects on protein function.

9. **Result Interpretation**
   - The annotated VEP output was analyzed to identify biologically and clinically relevant **EGFR** variants, including pathogenic and drug-response-associated mutations.
  
## Industry Relevance

This project demonstrates a standard **secondary NGS analysis pipeline** widely used in genomics research, clinical bioinformatics, and pharmaceutical industries. The workflow covers essential bioinformatics steps, including quality control, read preprocessing, reference alignment, variant calling, and functional annotation.

The tools used in this pipeline (FastQC, fastp, BWA, SAMtools, Picard, GATK, and Ensembl VEP) are commonly employed in research laboratories, hospitals, diagnostic laboratories, and biotechnology companies for genetic variant analysis and precision medicine applications.
