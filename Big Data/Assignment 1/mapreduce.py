#!/usr/bin/env python
from operator import itemgetter
# input comes from STDIN (standard input)

results = []
with open('toyData.txt') as inputfile:
    for line in inputfile:
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
print       
print("Done making connections dictionary")        
print
#print connections 


#MAPPER
mapper = {}

for k in connections.keys():
        notConnected = set(connections.keys()) - set(connections[k]) - set([k])
        mapper[k] = notConnected
#print
#print("Now printing notConnected")
#print  
#print mapper




#REDUCER

reducer={}
for key in mapper:
    top_ten = []
    count=0
    for item in mapper[key]:
        size_intersection = len(set(connections[key]).intersection(set(connections[item])))
        if count <= 10 :
            top_ten.append((item,size_intersection))
            print "key is:", key,"\t initial top ten:", top_ten
        elif size_intersection > min(x[1] for x in top_ten):
            print("key is: ", key,"\t",item,size_intersection)
        count = count+1


'''
# input comes from STDIN
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    word, count = line.split('\t', 1)

    # convert count (currently a string) to int
    try:
        count = int(count)
    except ValueError:
        # count was not a number, so silently
        # ignore/discard this line
        continue

    # this IF-switch only works because Hadoop sorts map output
    # by key (here: word) before it is passed to the reducer
    if current_word == word:
        current_count += count
    else:
        if current_word:
            # write result to STDOUT
            print '%s\t%s' % (current_word, current_count)
        current_count = count
        current_word = word

# do not forget to output the last word if needed!
if current_word == word:
    print '%s\t%s' % (current_word, current_count)
'''