# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 21:24:59 2017

@author: jrbrad
"""

import MySQLdb as mySQL 
#import datetime

mysql_user_name =  'root'
mysql_password = '#90_Bruiser'
mysql_ip = '127.0.0.1'
mysql_db = 'assign'

trail_cu_ft = 4000.0
num_days_year = 365.0

def db_get_data(problem_id):
    cnx = db_connect()
                        
    cursor = cnx.cursor()
    cursor.execute("CALL spGetBinpackCap(%s);" % problem_id)
    bin_cap = cursor.fetchall()[0][0]
    cursor.close()
    cursor = cnx.cursor()
    cursor.execute("CALL spGetBinpackData(%s);" % problem_id)
    items = {}
    blank = cursor.fetchall()
    for row in blank:
        items[row[0]] = row[1]
    cursor.close()
    cnx.close()
    return bin_cap, items

def getDBDataList(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = []
    for item in list(cursor):
        sub_list = []
        for ele in item:
            sub_list.append(ele)
        items.append(sub_list)
    cursor.close()
    cnx.close()
    return items
    
def getDBDataListEle(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = []
    for item in list(cursor):
        items.append(item[0])
    cursor.close()
    cnx.close()
    return items
    
def getDBDataDictEle(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = {}
    for item in list(cursor):
        items[item[0]] = item[1]
    cursor.close()
    cnx.close()
    return items
    
def getDBDataDict(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = {}
    for item in list(cursor):
        items[item[0]] = item[1:len(item)]
    cursor.close()
    cnx.close()
    return items
    
def getDBDataDictTup(commandString):
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.execute(commandString)
    items = {}
    for item in list(cursor):
        items[(item[0],item[1])] = item[2]
    cursor.close()
    cnx.close()
    return items

def db_connect():
    cnx = mySQL.connect(user=mysql_user_name, passwd=mysql_password,
                        host=mysql_ip, db=mysql_db)
    return cnx
    
def trans(dist, dcs, stores_vol):
    my_team_or_name = "akdavey"
    result = []
    """
    Logic: want to get each store supplied by the closest DC to minimize costs while adhereing to constraints for every store need to find the closest DC assign that closest DC
    """
    trail_cu_ft =  4000.0
    running_totals, st_vol = {},{}
    for key in dcs.keys():
        running_totals[key] = [0.0,0,0]
    for i in stores_vol:
        st_vol[i[0]] = i[1]
    st_copy = dict(st_vol)
    import math
    store_dc_pairs = sorted(dist.keys(), key=lambda x: (-(dcs[x[0]][1]-running_totals[x[0]][1]),round(dist[x],-1)), reverse=False)#with pure less than and not le
    j=0
    while len(st_vol.keys()) > 0 :
        i = store_dc_pairs[j]
        store, dc = i[1], i[0]
        if store in st_vol.keys():  
            store_daily_volume  = st_vol[store]
            dc_daily_capacity, dc_door_capacity, dc_driver_capacity= dcs[dc][0], dcs[dc][1], dcs[dc][2]
            new_driver_total = running_totals[dc][2] + int(math.ceil(store_daily_volume/trail_cu_ft))
            new_cubic_total = running_totals[dc][0] + store_daily_volume 
            new_door_total = running_totals[dc][1]+1
            if new_door_total<=dc_door_capacity and new_driver_total<=dc_driver_capacity and new_cubic_total<=dc_daily_capacity:#if the dc_id in question has more cubic capacity and if the dc_id in question has more door_capacity and driver_capacity                    
                result.append((store,dc)) #have to switch tuple order
                del st_vol[store]
                running_totals[dc] = (new_cubic_total, new_door_total, new_driver_total)
                store_dc_pairs = sorted(dist.keys(), key=lambda x: (-st_copy[x[1]], -(dcs[x[0]][1]-running_totals[x[0]][1]),round(dist[x],-1)), reverse=False)#with pure less than and not le
                j=0
                continue
        j+=1
        print j

    return my_team_or_name, result
    
def checkDCCap(dcs,stores_vol,result):
    checkit = {}
    store_v_tmp = {}
    err_dc_constr = False
    #num_constrs = len(dcs[dcs.keys()[0]])
    for item in stores_vol:
        store_v_tmp[item[0]] = item[1]
    for key in dcs.keys():
        checkit[key] = [0.0,0,0]
    for ele in result:
        checkit[ele[1]][0] += store_v_tmp[ele[0]]                # cu feet of volume
        checkit[ele[1]][1] += 1                                  # number of doors
        checkit[ele[1]][2] += store_v_tmp[ele[0]] / trail_cu_ft  # number of drivers per day
    for i in range(len(dcs)):
        err_dc_constr = err_dc_constr or (checkit[i][0] > dcs[i][0]) or (checkit[i][1] > dcs[i][1]) or (checkit[i][2] > dcs[i][2])
        if err_dc_constr:
            print "Violation on DC : ", i
            print "cu ft volume cap:",dcs[i][0], " - gave:",  checkit[i][0]
            print "num doors cap:",dcs[i][1], " - gave:", checkit[i][1]
            print "num drivers cap:", dcs[i][2], " - gave:", checkit[i][2]
            print
    print
        #print (checkit[i][0],checkit[i][1],checkit[i][2]),dcs[i]
    return err_dc_constr
    
def checkUniqueAssign(store_ids,dc_ids,result):
    """ Create a dictionary frequency histogram of the DC data in result and ensure that the 
    length of the dictionary matches the length of dc_ids and that each key in the dictionary is in dc_ids"""
    err_dc_key = False 
    err_store_key = False 
    err_mult_assign = False
    err_store_not_assign = False
    err_mess = ""
    checkit = {}
    for ele in result:
        checkit[ele[1]] = checkit.get(ele[1],0)+1
    for this_key in checkit.keys():
        if this_key not in dc_ids:
            err_dc_key = True
            err_mess = "Invalid DC key"
    checkit.clear()
    
    """ Create a dictionary frequency histogram of the Store data in result and ensure that the 
    length of the dictionary matches the length of store_ids and that each key in the dictionary is in store_ids
    and each key is mentioned only once """
    for ele in result:
        checkit[ele[0]] = checkit.get(ele[0],0)+1        
    for this_key in checkit.keys():
        if this_key not in store_ids:
            err_store_key = True
            err_mess += "_Invalid Store key"
        if checkit[this_key] > 1:
            err_mult_assign = True
            err_mess += "_Store assigned mult times"
    if len(store_ids) > len(checkit):
        err_store_not_assign = True
        err_mess += " _Stores(s) not assigned"
            
    return err_dc_key or err_store_key or err_mult_assign or err_store_not_assign, err_mess
    
def calcAnnualMiles(stores_vol,dist,result):    #dist key = (dc,store); result tuples (store,dc)
    tot_miles = 0.0
    stores_vol_dict = dict(stores_vol)
    for assign in result:
        tot_miles += stores_vol_dict[assign[0]] / trail_cu_ft * dist[assign[1],assign[0]] * num_days_year
    return tot_miles      
            
            
            
silent_mode = False
problems = getDBDataListEle('CALL spGetProblemIds();')
for problem_id in problems:
    dist = getDBDataDictTup('CALL spGetDist(%s);' % str(problem_id))          # Key: (DC id, Store ID),  Value: distance
    dcs = getDBDataDict('CALL spGetDcs(%s);' % str(problem_id))               # SELECT id, cap_cubic_feet, cap_doors, cap_drivers 
    stores_vol = getDBDataList('CALL spGetStores(%s);' % str(problem_id))     # SELECT id, vol_daily
    store_ids = getDBDataListEle('CALL spGetStoreIDs(%s)' % str(problem_id))  # Creates a list of store_id keys
    dc_ids = getDBDataListEle('CALL spGetDCIDs(%s)' % str(problem_id))        # creates a list if dc_id keys
    
    my_team_or_name, result = trans(dist, dcs, stores_vol)
    print result
    
    okStoresAssigned, err_mess = checkUniqueAssign(store_ids,dc_ids,result)
    okCap = checkDCCap(dcs,stores_vol,result)
    if not okCap and not okStoresAssigned:
        obj = calcAnnualMiles(stores_vol,dist,result)
    else:
        obj = 99999999999999999.0
    if silent_mode:
        if okStoresAssigned or okCap:
            print "P",problem_id," error: " 
            if okStoresAssigned:
                print '; error with keys or multiple assignment'
            if okCap:
                print '; exceeded DC capacity'
        else:
            print "P",problem_id,"OK, annual miles:", obj
    else:
        if okStoresAssigned or okCap:
            print "Problem",problem_id," error: " 
            if okStoresAssigned:
                print 'either with keys or assignment of stores to multiple DCs'
                print err_mess
            if okCap:
                print 'DC capacity exceeded'
        else:
            print "Problem",problem_id," OK, annual miles:", obj
            
            

    
    
    

            


                
        
    
     
