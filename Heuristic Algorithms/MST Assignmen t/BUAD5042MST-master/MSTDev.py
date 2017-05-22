# -*- coding: utf-8 -*-
"""
Created on Thu Mar 02 17:54:49 2017

@author: jrbrad
"""

import math
import MySQLdb as mySQL

R = 6371.0 * 0.621371

""" global MySQL settings """
mysql_user_name = 'root' #
mysql_password = '#90_Bruiser'   #
mysql_ip = '127.0.0.1'
mysql_db = 'mst_dt'

def combine_trees(list1,list2):
    return list1 +list2
    
"""" initial list of lists for trees """
def init_trees(loc_list):
    trees = {}
    for i in loc_list:
        trees[i] = [i]
    return trees
    
def mst_value(values,mst):
    value = 0
    for link in mst:
        value += values[link]
    return value

def mst_feasible(values,mst):
    error = False
    locs = {}
    for link in values.keys():
        locs[link[0]] = locs.get(link[0],0) + 1
        locs[link[1]] = locs.get(link[1],0) + 1
    check = {}
    for link in mst:
        check[link[0]] = check.get(link[0],0) + 1
        check[link[1]] = check.get(link[1],0) + 1
        if not (link[0] in locs.keys()) or not (link[1] in locs.keys()):
            error = True
    
    reached = [mst[0][0]]
    reached_last = [mst[0][0]]
    exclude = []
    reached_next = []
    subtour = False
    while subtour == False and len(exclude) < len(mst):
        for start in reached_last:
            for i in range(len(mst)):
                if not (i in exclude):
                    if start == mst[i][0]:
                        exclude.append(i)
                        if mst[i][1] in reached:
                            subtour = True
                        else:
                            reached_next.append(mst[i][1])
                            reached.append(mst[i][1])
                    elif start == mst[i][1]:
                        exclude.append(i)
                        if mst[i][0] in reached:
                            subtour = True
                        else:
                            reached_next.append(mst[i][0])
                            reached.append(mst[i][0])
        reached_last = reached_next
        reached_next = []
    
    if len(check.keys()) == len(locs.keys()) and error == False and not subtour:
        return True    
    else:
        return False
        
def getDBDataList(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = []
    x = cursor.fetchall()
    for item in x:
        new_row = []
        for i in range(len(item)):
            new_row.append(item[i])
        items.append(new_row)
    cursor.close()
    cnx.close()
    return items
    
def getDBDataList1(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = []
    x = cursor.fetchall()
    for item in x:
        items.append(item[0])
    cursor.close()
    cnx.close()
    return items

def db_connect():
    cnx = mySQL.connect(user=mysql_user_name, passwd=mysql_password,
                        host=mysql_ip, db=mysql_db)
    return cnx
        
def hav_dist(lat1, lon1, lat2, lon2):
    """ latitude and longitude inputs are in degrees """
    
    """ convert latitude and longitude to radians """
    lat1 = lat1 * math.pi /180.0
    lon1 = lon1 * math.pi /180.0
    lat2 = lat2 * math.pi /180.0
    lon2 = lon2 * math.pi /180.0
    
    a = math.sin((lat2-lat1)/2)**2 + math.cos(lat1) * math.cos(lat2) * (math.sin((lon2-lon1)/2))**2
    return R * 2 * math.atan2(math.sqrt(a),math.sqrt(1-a))
    
def mst_algo(locs,dist):
    name_or_team = "akdavey"
    mst = []
    '''
    locs contains data about each location taken from the database including location id, latitude, longitude address and type of facility. In list of lists format.
    dist is a dictionary of of distances between all pairs of locations -- key is (store id, store id), value is distance
    '''
    connections = dist.keys()
    connections.sort(key=lambda x: dist[x], reverse=False) #sort connections by least distance
    touched_edges = [] #keep track of edges already connected to
    edges = 0
    nodes = len(locs)
    
    def find_connections(x,built_set,touched_edges): #recursive function to determine connection set for a node x, and its given built connection set. Returns a full set of all the other nodes node x is connectd to
        built_set.add(x) #add item x to the built set
        temp_set=built_set.copy()#make a copy of the built set
        for tup in touched_edges:
            if x in tup:
                temp_set.add(tup[0])
                temp_set.add(tup[1])
        if temp_set.issubset(built_set): #check if every element in the temp_set is in the built_set
            return built_set
        else: #get the connections for all the items connected to x and add it to x's connections
            missing_values=temp_set.difference(built_set)
            for y in missing_values:
                y_connections = find_connections(y,built_set,touched_edges)
                built_set = built_set.union(y_connections)
            return built_set

    while edges < nodes - 1:
        i = connections[0] #since list is sorted, always evaluate the first item in the list
        i0_connects = find_connections(i[0],set(),touched_edges)
        i1_connects = find_connections(i[1],set(),touched_edges)
        if bool(i0_connects.intersection(i1_connects)):
            connections.pop(0)
        else:
            mst.append(i)
            touched_edges.append(i)
            edges+=1
            connections.pop(0)

    return name_or_team, mst


""" This is the main program """
problems = getDBDataList1('CALL spGetProblemIds();')
silent_mode = False
""" Error Messages """
error_locid = """ 
A list was received from mst_algo() with tuples containing invalid location ids.   
"""
error_not_tuple = """ 
A list was received from mst_algo() whose inner data structure does not contain tuples.   
"""
error_response_not_list = """
mst_algo() returned a response whose outer data type was not a list.  Scoring will be terminated   """

for problem_id in problems:
    locs = getDBDataList('CALL spGetProbData(%s);' % (str(problem_id)))
    loc_ids = [x[0] for x in locs]
    
    """ Compute Haversine distances between all location pairs and insert results into dictionary dist """
    dist = {}
    for loc1 in range(len(locs)):
        for loc2 in range(loc1 + 1,len(locs)):
            dist[(locs[loc1][0],locs[loc2][0])] = hav_dist(locs[loc1][1],locs[loc1][2],locs[loc2][1],locs[loc2][2])
    
    errors = False
    mst = []
    name_or_team, mst = mst_algo(locs,dist)

    if isinstance(mst,list):
        for link in mst:
            if not isinstance(link,tuple):
                errors = True
                if silent_mode:
                    status = "bad_tuples_in_list"
                else:
                    print error_not_tuple
                break
            else:
                if not (link[0] in loc_ids and link[1] in loc_ids):
                    errors = True
                    if silent_mode:
                        status = "bad_loc_id_"
                    else:
                        print error_locid
                    break
    else:
        if silent_mode:
            status = "P"+str(problem_id)+"_not_list_"
        else:
            print error_response_not_list    
    
    if errors == False:
        mst_ok = mst_feasible(dist,mst)
        if mst_ok:
            mst_obj = mst_value(dist,mst)
        else:
            mst_obj = 9999999999
        
        if mst_ok:
            if silent_mode:
                status = "P"+str(problem_id)+"mst_valid_"
            else:
                print "MST Problem ", str(problem_id)," solution valid, distance =", mst_obj
        else:
            if silent_mode:
                status = "P"+str(problem_id)+"mst_invalid_"
            else:
                print "MST Problem ", str(problem_id)," solution invalid ...."

    print
    print "=========================================================="
    print "MST Problem", str(problem_id)
    print name_or_team, mst, mst_value(dist,mst)
    print "MST feasible?", mst_feasible(dist,mst)
    print