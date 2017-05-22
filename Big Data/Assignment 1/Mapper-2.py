#!/usr/bin/env python
#Team 8
import sys
'''
MAPPER 2

This program is the second mapper in a 2-part mapreduce
'''
# input comes from STDIN (standard input)
for line in sys.stdin:
    personA, personB, mutuals = line.split(',')
    if int(mutuals) != 0:
    	print "%d,%d,%d"%(int(personA), int(personB), int(mutuals))