# SURPI-Bpipe
SURPI™ is a computational pipeline for pathogen identification from complex metagenomic next-generation sequencing (NGS) data generated from clinical samples. This pipeline was built on 2014, and it has not been updated since 2015. Now in 2018, beause of changing of reference data format, this pipeline cannot work normally. Also, as the size of reference database increases a lot compared with in 2014, the running time of this pipeline becomes too long for clinical use.

Here, we show a case study on how to use HPC strategies to accelerate an old but still needed bioinformatics tool and make it scalable.

1. Introduction to methods
We firstly did some debugging works. We revised some codes in SURPI’s scripts. And we updated some softwares which are needed in SURPI. Then we adopt several strageties and applied on HPC to accelerate SURPI. These strategies include

Scatter and Gather
•	Task Separation
•	Select-and-merge
 
Shared Memory Usage
•	Using large RAM systems for accelerating I/O
 
Replacement of rate limiting software with better algorithms
•	Protein aligner
•	Nucleotide aligner
 
Pipeline Parallelization
•	Using Bpipe to parallelize the pipeline 
 
These strategies in total resulted in ~5X improvement in speed and make the pipeline scalable.

2. Installation of optimized SURPI
The steps to build optimize SURPI on a local server or HPC(recommmended) are as follows:

(1) Installation of  SURPI
SURPI’s github link is https://github.com/chiulab/surpi, their home page link is http://chiulab.ucsf.edu/surpi/. Please install SURPI first before we optimize this pipeline.

You can install SURPI by following the instructions listed in SURPI github  (https://github.com/chiulab/surpi). You may encounter some difficuties in this step. Here we give you some tips to help you:

i. You can install SURPI by copying files we provided rather than downloading from SURPI github. Our files are different with original SURPI files. This is because we did a lot of debugging works and had revised SURPI’s codes in many scripts.

ii. The first step in the instruction: SNAP
SNAP in old version cannot deal with current genomics data as they are too large. Please use the updated version of SNAP ------SNAP-aligner (http://snap.cs.berkeley.edu/downloads/snap-beta.18-linux.tar.gz );

Rapsearch is no longer the fastest software for protein alignment today. Please use AC-DIAMOND(http://ac-diamond.sourceforge.net/) to replace Rapsearch.

iii. The third step in the instruction: Create Database
You can find a script called “creat_SURPI_data.sh” in bin folder of SURPI. Run this script to build indexing and taxonomy databases. This script may take a long time to run.

When building indexing database for SNAP-aligner, we splitted nt for parellelization work. Nt was splitted into 30 pieces because of the memory limit of our machine. So the defalut splitted number in our code is 30. You can adjust this number according to your computing resources by editting the value of “SNAP_nt_chunks” in the 48th line of “create_SURPI_data” script in bin folder. 

(2) Optimization of SURPI
To optimize SURPI, we use a bioinforamtics tool called “Bpipe” (https://github.com/ssadedin/bpipe) to parellelize this pipeline. So please install Bpipe before we use it.

There are 2 config files in the folder, “bpipe.config” and “surpi.config”. Please fill in the correct path of your software in “surpi.config”. If you want to use a supercomputer which uses PBSpro system, you should set executor equal to “pbspro” in “bpipe.config” file. For other cluster resource management systems, please check Bpipe webpage (http://docs.bpipe.org/Guides/ResourceManagers/ ).




Once you followed these steps, you can use optimized SURPI by typing the command as follow:

bpipe run -r -n (number of cores) surpi.bpipe /path/inputfile

If you want to run this pipeline on HPC which uses PBSpro system, you need to create a qsub file for requesting computing resources and queues. The script “qsub-bpipe.sh” is an example. Type the command “qsub qsub-bpipe.sh” to run this pipeline.
