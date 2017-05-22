#!/usr/bin/env python
#Team 8
from operator import itemgetter
import sys
'''
REDUCER 2

This program is the second mapper in a 2-part mapreduce
'''

# input comes from STDIN
templist=[]
tempperson=None
for line in sys.stdin:
	line = line.strip()
    personA,personB, mutuals = line.split(',')
    personB,mutuals = int(personB), int(mutuals) 
    if tempperson == personA or tempperson == None:
    	if len(templist) < 10:
    		templist.append((personB,mutuals))
    		templist.sort(key = lambda x: (-x[1],x[0]) )
    	else:
    		if mutuals > templist[9][1]:
    			templist[9] = (personB,mutuals)
    			templist.sort(key = lambda x:(-x[1],x[0]))
    else:
    	friends = ",".join(str(x[0]) for x in templist)
    	print "%s\t%s"%(tempperson, friends)
    	templist = [(personB,mutuals)]
    tempperson = personA