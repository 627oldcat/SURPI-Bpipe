#!/usr/bin/python

import sys

usage = "sort_m8.py <header_file> <m8_file> <output_file>"

if len(sys.argv) != 4:
    print usage
    sys.exit(0)

header_file = sys.argv[1]
m8_file = sys.argv[2]
output_file = sys.argv[3]


# load list of headers
with open(header_file) as f:
    headers = [line.rstrip() for line in f]

# load m8 file from diamond blastx
with open(m8_file) as f:
    matches = [line.rstrip() for line in f]

# make a set file to speed up testing of membership
header_match = set([x.split('\t')[0] for x in matches])

# prep dict to printing the contents of a matched header
dict =  dict(zip(header_match, matches))

o = open(output_file,"w")

for i, header in enumerate(headers):
    if header in header_match:
        o.write(str(dict[header])+"\n")
    else:
        o.write(header + "\t*" * 11 + "\n")

o.close()
       
