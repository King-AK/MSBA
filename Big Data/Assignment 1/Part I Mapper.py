#!/usr/bin/env python

import sys

results = []
# input comes from STDIN (standard input)
for line in sys.stdin:
       results.append(line.strip().split('\n'))
connections = {} 
for line in results:
        temp = line[0].split('\t')
        key = temp[0]
        try:    
            value = temp[1].split(',')
        except: 
            value = ''
        connections [key] = value

#MAPPER
mapper = {}

for k in connections.keys():
        notConnected = set(connections.keys()) - set(connections[k]) - set([k])
        mapper[k] = notConnected
#

for key in connections.keys():
    print (key, ";", connected[key], ";" notConnected[key])
