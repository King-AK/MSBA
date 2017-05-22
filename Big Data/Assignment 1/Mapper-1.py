#!/usr/bin/env python
#Team 8
import sys
'''
MAPPER 1

This program is the first mapper in a 2-part mapreduce
'''
results = []
# input comes from STDIN (standard input)
for line in sys.stdin:
    results.append(line.strip().split('\n'))
#Build Connection Dictionary
connections = {} 
for line in results:
    connections =  {}
    temp = line[0].split('\t')
    user = temp[0]
    try:    
        value = temp[1].split(',')
    except: 
        value = ''
    connections[user] = value
    for friend in connections[user]:
        print "%s,%s; %d"%(user,friend,0)
        for second_friend in set(connections[user]) - set([friend]):
            print"%s,%s;%d"%(friend,second_friend,1)