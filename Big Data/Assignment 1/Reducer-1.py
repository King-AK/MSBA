#!/usr/bin/env python
#Team 8
from operator import itemgetter
import sys
'''
REDUCER 1

This program is the first reducer in a 2-part mapreduce
'''

# input comes from STDIN
suggestions={}
tempSum=0
tempProduct=1
currentTuple = None
for line in sys.stdin:
    line = line.strip()
    friendTuple, score = line.split(';') 
    if currentTuple == friendTuple:
        tempSum += int(score)
        tempProduct *= int(score)
    elif currentTuple != friendTuple and currentTuple != None:
        if tempSum*tempProduct !=0:	
            print "%s,%s"%(currentTuple,tempSum*tempProduct)
        tempProduct = int(score)
        tempSum = int(score)
    currentTuple = friendTuple