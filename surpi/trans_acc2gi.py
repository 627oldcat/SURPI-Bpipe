#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys

filename = sys.argv[1]
database = sys.argv[2]
output = sys.argv[3]

fread=open(filename,"r")
fread2=open(database,"r")
fwrite=open(output,"wb")

gi_acc_dict={}
lines=fread2.readlines()
for line in lines:
	line=line.strip().split("\t")
	gi_acc_dict[str(line[0])]=str(line[3])
fread2.close()

lines=fread.readlines()
for line in lines:
	line1=line.strip().split("\t")
	acc=line1[2].split(".")[0]
	if gi_acc_dict.has_key(str(acc)):
		gi="gi|"+str(gi_acc_dict[acc])+"|"
		new_line=line.replace(line1[2],gi)
		fwrite.write(new_line)

fread.close()
fwrite.close()
