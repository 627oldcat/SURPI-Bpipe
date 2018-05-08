#!/usr/bin/python
#	compare_multiple_sam.py
#
#	This program compares multiple SAM files to find the best SNAP alignment hit
#	Chiu Laboratory
#	University of California, San Francisco
#	January, 2014
#
# Copyright (C) 2014 Charles Y Chiu - All Rights Reserved
# Permission to copy and modify is granted under the BSD license
# Last revised 3/21/2014  

import sys
from itertools import izip

usage = "compare_multiple_sam.py <annotated SAM file1> <annotated SAM file2> <annotated SAM filen> <output file>"

if len(sys.argv) < 3:
	print usage
	sys.exit(0)

outputFileName= sys.argv[len(sys.argv)-1]

fileNameList = []
for n in range(0, len(sys.argv)-2):
	fileName = sys.argv[n+1]
	fileNameList.append(fileName)

outputFile = open(outputFileName, "w")

files = [open(i, "r") for i in fileNameList]
for rows in izip(*files):
    edit_list = []
    for line in rows:
        edit_dist = int(line.split("\t")[12].split(":")[2])
        if edit_dist == -1:
            edit_dist = 999
        edit_list.append(edit_dist)
    i = edit_list.index(min(edit_list))
    outputFile.write(rows[i])
		
for file in files:
    file.close()
outputFile.close()
