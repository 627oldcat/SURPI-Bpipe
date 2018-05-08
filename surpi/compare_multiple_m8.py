#!/usr/bin/python

import sys
from itertools import izip

usage = "compare_multiple_m8.py <m8 file 1> <m8 file 2> ... <output file>"

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
print files

for rows in izip(*files):
    edit_list = []
    for line in rows:
        edit_dist = line.split("\t")[10]
        if edit_dist == "*":
            edit_dist = float(1.0)
        edit_list.append(float(edit_dist))
    i = edit_list.index(min(edit_list))
    print edit_list
    print i
    outputFile.write(rows[i])
		
for file in files:
    file.close()
outputFile.close()
