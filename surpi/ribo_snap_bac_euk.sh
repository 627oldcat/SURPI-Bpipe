#!/bin/bash
#     
#	ribo_snap_bac_euk.sh
# 
# 	Chiu Laboratory
# 	University of California, San Francisco
# 	3/15/2014
#
# Copyright (C) 2014 Samia Naccache - All Rights Reserved
# SURPI has been released under a modified BSD license.
# Please see license file for details.
# Last revised 5/19/2014

if [ $# -lt 4 ]
then
	echo " <.sorted> <BAC/EUK> <cores> <folder>"
	exit 65
fi

###
inputfile=$1
inputfile_type=$2
cores=$3
directory=$4
###
scriptname=${0##*/}

if [ $inputfile_type == "BAC" ]
then
	SNAP_index_Large="$directory/snap_index_23sRNA"
	SNAP_index_Small="$directory/snap_index_rdp_typed_iso_goodq_9210seqs"
fi

if [ $inputfile_type == "EUK" ]
then
	SNAP_index_Large="$directory/snap_index_28s_rRNA_gene_NOT_partial_18s_spacer_5.8s.fa"
	SNAP_index_Small="$directory/snap_index_18s_rRNA_gene_not_partial.fa"
fi

awk '{print ">"$1"\n"$10}' $inputfile > $inputfile.fasta # if Bacteria.annotated file has full quality, convert from Sam -> Fastq at this step
fasta_to_fastq $inputfile.fasta > $inputfile.fakq # if Bacteria.annotated file has full quality, convert from Sam -> Fastq at this step

crop_reads.csh $inputfile.fakq 10 75 > $inputfile.fakq.crop.fastq

# snap against large ribosomal subunit
cp $inputfile.fakq.crop.fastq /dev/shm/tmp.fastq
snap-aligner single $SNAP_index_Large /dev/shm/tmp.fastq -o $inputfile.noLargeS.unmatched.sam -t $cores -x -f -h 250 -d 18 -n 200 -F u
egrep -v "^@" $inputfile.noLargeS.unmatched.sam | awk '{if($3 == "*") print "@"$1"\n"$10"\n""+"$1"\n"$11}' > $(echo "$inputfile".noLargeS.unmatched.sam | sed 's/\(.*\)\..*/\1/').fastq
rm /dev/shm/tmp.fastq
echo -e "$(date)\t$scriptname\tDone: first snap alignment"

# snap against small ribosomal subunit
cp $inputfile.noLargeS.unmatched.fastq /dev/shm/tmp.fastq
snap-aligner single $SNAP_index_Small /dev/shm/tmp.fastq -o $inputfile.noSmallS_LargeS.sam -t $cores -h 250 -d 18 -n 200 -F u
rm /dev/shm/tmp.fastq
echo -e "$(date)\t$scriptname\tDone: second snap alignment"

# convert snap unmatched to ribo output to header format 
awk '{print$1}' $inputfile.noSmallS_LargeS.sam | sed '/^@/d' > $inputfile.noSmallS_LargeS.header.sam

# retrieve reads from original $inputfile 

extractSamFromSam.sh $inputfile.noSmallS_LargeS.header.sam $inputfile $inputfile.noRibo.annotated
echo -e "$(date)\t$scriptname\tCreated $inputfile.noRibo.annotated" 
table_generator.sh $inputfile.noRibo.annotated SNAP N Y N N 

dropcache

rm -f $inputfile.noLargeS.sam
rm -f $inputfile.noLargeS.matched.sam
rm -f $inputfile.noLargeS.unmatched.sam
rm -f $inputfile.noSmallS_LargeS.sam
rm -f $inputfile.noSmallS_LargeS.sam.header
rm -f $inputfile.noLargeS.unmatched.fastq 
rm -f $inputfile.fakq
rm -f $inputfile.fakq.crop.fastq
rm -f $inputfile.fasta
rm -f $inputfile.sorted
rm -f $inputfile.noSmallS_LargeS.header.sam
