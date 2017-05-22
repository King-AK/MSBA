# -*- coding: utf-8 -*-
"""
REMEMBER TO CLEAR USER INFO BEFORE TURNING IN OR UPLOADING TO GIT
"""

import MySQLdb as mySQL

""" global MySQL settings """
mysql_user_name = 'root'
mysql_password = '#90_Bruiser'
mysql_ip = '127.0.0.1'
mysql_db = 'knapsack'

def checkCapacity(contents,knapsack_cap):
    """ contents is expected as a dictionaryof the form {item_id:(volume,value), ...} """
    """ This function returns True if the knapsack is within capacity; False if the knapsack is overloaded """
    load = 0
    if isinstance(contents,dict):
        for this_key in contents.keys():
            load = load + contents[this_key][0]
        if load <= knapsack_cap:
            return True
        else:
            return False
    else:
        print "function checkCapacity() requires a dictionary"

def knapsack_value(items):
    value = 0.0
    if isinstance(items,dict):
        for this_key in items.keys():
            value = value + items[this_key][1]
        return(value)
    else:
        print "function knapsack_value() requires a dictionary"

def load_knapsack(things,knapsack_cap):
    """ You write your heuristic knapsack algorithm in this function using the argument values that are passed
             items/things: is a dictionary of the items no yet loaded into the knapsack
             knapsack_cap: the capacity of the knapsack (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             my_team_number_or_name: if this is a team assignment then set this variable equal to an integer representing your team number;
                                     if this is an indivdual assignment then set this variable to a string with you name
            items_to_pack: this is a list containing keys (integers) of the items you want to include in the knapsack
                           The integers refer to keys in the items dictionary. 
   """
        
    my_team_number_or_name = "akdavey"    # always return this variable as the first item
    items_to_pack = []    # use this list for the indices of the items you load into the knapsack
    load = 0.0            # use this variable to keep track of how much volume is already loaded into the backpack
    value = 0.0           # value in knapsack
    
    #EDIT CODE BELOW HERE
    item_keys = [k for k in things.keys()]
    #0-1 knapsack dynamic programming .. done with help from https://www.youtube.com/watch?v=EH6h7WA7sDw

    v=[]    #create v and keep array, initialize to 0
    keep=[]
    for i in range(0,len(item_keys)+1): #range is 0 to num of items because we will need a null row of zeroes to start the matrix
        v.append([])
        keep.append([])
        for j in range(0,int(knapsack_cap)+1):
            v[i].append(0)
            keep[i].append(0)
    #break the problem up by doing many smaller knapsack problems.. do a for loop which allows us to populate the v and keep arrays
    final_index = -1
    for i in range(1,len(item_keys)+1):
        for j in range(1,int(knapsack_cap)+1):
            current_wt = things[item_keys[i-1]][0]
            current_val = things[item_keys[i-1]][1]
            #if the current weight is allowable for this sub knapsack problem and the value is superior to the cell directly above this item plus whatever is the best value for the sub knapsack problem corresponding to the remainder, then select the cvalue for this item plus the remainder solution and set keep =1, else select the value from the row above, and leave keep alone.
            current_knapsack_cap = j
            leftover_optimal_vknapsack = current_knapsack_cap - int(current_wt) #the index of the optimal knapsack worth considering for item i if i weighs little enough to fit more items in
            if current_wt <= current_knapsack_cap and leftover_optimal_vknapsack >=0: #item can fit in the knapsack and we dont get a negative index
                if current_val+v[i-1][leftover_optimal_vknapsack] > v[i-1][current_knapsack_cap]:
                    v[i][j] = current_val+v[i-1][leftover_optimal_vknapsack]
                    keep[i][j]=1
                else:
                    v[i][j] = v[i-1][j]
        final_index+=1
    #print final_index
    #print knapsack_cap
    #print v
    #print keep
    #sort through the keep array, keeping all the items which maximize value in the knapsack
    leftover_room=knapsack_cap 
    while leftover_room>0 and final_index >= 0:
        if keep[final_index+1][int(leftover_room)] == 1:
            pack_item = item_keys[final_index]
            items_to_pack.append(pack_item)
            load += things[pack_item][0]
            value += things[pack_item][1]
            leftover_room -= things[pack_item][0]
            final_index-=1
        else:
            final_index-=1

    return my_team_number_or_name, items_to_pack       # use this return statement when you have items to load in the knapsack

def getDBDataList(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = []
    for item in list(cursor):
        items.append(item[0])
    cursor.close()
    cnx.close()
    return items
   
""" db_get_data connects with the database and returns a dictionary with the knapsack items """
def db_get_data(problem_id):
    cnx = db_connect()
                        
    cursor = cnx.cursor()
    cursor.execute("CALL spGetKnapsackCap(%s);" % problem_id)
    knap_cap = cursor.fetchall()[0][0]
    cursor.close()
    cursor = cnx.cursor()
    cursor.execute("CALL spGetKnapsackData(%s);" % problem_id)
    items = {}
    blank = cursor.fetchall()
    for row in blank:
        items[row[0]] = (row[1],row[2])
    cursor.close()
    cnx.close()
    return knap_cap, items
    
def db_connect():
    cnx = mySQL.connect(user=mysql_user_name, passwd=mysql_password,
                        host=mysql_ip, db=mysql_db)
    return cnx
    
""" Error Messages """
error_bad_list_key = """ 
A list was received from load_knapsack() for the item numbers to be loaded into the knapsack.  However, that list contained an element that was not a key in the dictionary of the items that were not yet loaded.   This could be either because the element was non-numeric, it was a key that was already loaded into the knapsack, or it was a numeric value that didn't match with any of the dictionary keys. Please check the list that your load_knapsack function is returning. It will be assumed that the knapsack is fully loaded with any items that may have already been loaded and a score computed accordingly. 
"""
error_response_not_list = """
load_knapsack() returned a response for items to be packed that was not a list.  Scoring will be terminated   """

""" Get solutions bassed on sbmission """
problems = getDBDataList('CALL spGetProblemIds();') 
silent_mode = False    # use this variable to turn on/off appropriate messaging depending on student or instructor use

for problem_id in problems:
    in_knapsack = {}
    knapsack_cap, items = db_get_data(problem_id)
    #finished = False
    errors = False
    response = None
    
    team_num, response = load_knapsack(items,knapsack_cap)
    if isinstance(response,list):
        for this_key in response:
            if this_key in items.keys():
                in_knapsack[this_key] = items[this_key]
                del items[this_key]
            else:
                errors = True
                if silent_mode:
                    status = "bad_list_key"
                else:
                    print "P"+str(problem_id)+"bad_key_"
                #finished = True
    else:
        if silent_mode:
            status = "P"+str(problem_id)+"_not_list_"
        else:
            print error_response_not_list
                
    if errors == False:
        if silent_mode:
            status = "P"+str(problem_id)+"knap_load_"
        else:
            print "Knapsack Loaded for Problem ", str(problem_id)," ...." 
        knapsack_ok = checkCapacity(in_knapsack,knapsack_cap)
        knapsack_result = knapsack_value(in_knapsack)
        if silent_mode:
            print status+"; knapsack within capacity: "+knapsack_ok
        else:
            print "knapcap: ", knapsack_ok
            print "knapsack value : ", knapsack_value(in_knapsack)
