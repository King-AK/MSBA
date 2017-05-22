#!/usr/bin/env python

from operator import itemgetter
import sys

current_word = None
current_count = 0
word = None

# input comes from STDIN

everyone = {}
mutualConnections = {}


for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    key, connected_string, notConnected_string = line.split(';')

    connected = connected_string.split(",")
    notConnected = notConnected_string.split(",")

    everyone[key] = (connected, notConnected)


for key in everyone:
    sizeIntersection = len(set(everyone[key][1]))


count_connection = set(connected).intersection(set(notConnected))

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