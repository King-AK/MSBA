#VJ Davey
#11/3/2016
#Mini Solution assignment
from gurobipy import *
import MySQLdb as mySQL
import datetime

def getDBData(commandString, connection):
    cursor = connection.cursor()
    cursor.execute(commandString)
    results = list(cursor.fetchall())
    cursor.close()
    return results
    
def putResultsData(insertList, connection):
    cursor = connection.cursor()
    cursor.executemany("CALL spPutResultsData(%s,%s,%s)", insertList)
    connection.commit()
    cursor.close()

print '\nSetting up DB connection\n'
myuser = str(raw_input("Please enter your username: "))
mypasswd = str(raw_input("Please enter your password: "))
cnx = mySQL.connect(user=myuser, passwd=mypasswd,
                    host='127.0.0.1', db='mini_solution')                              
cursor = cnx.cursor()


# create Gurobi model
m = Model("MiniSolution")
m.ModelSense = GRB.MINIMIZE

    


# Get DC Information
dcInfo = getDBData("CALL `spDCInfo`;",cnx)
storeInfo = getDBData("CALL `spStoreInfo`;",cnx)
costInfo = getDBData("CALL `spCostInfo`;",cnx)

start_time = datetime.datetime.now()
dvars = {}
#undo the math done to calculate cost in sql to get raw mileage in python then use conditional setting of variables to set the cost for the objective function
for i in range(len(costInfo)):
    dvars[(costInfo[i][0],costInfo[i][1])] = m.addVar(vtype=GRB.BINARY,obj=costInfo[i][2] if ((costInfo[i][2]-200)/.75) <=150 else costInfo[i][2]+250 ,name='x_'+str(costInfo[i][0])+"_"+str(costInfo[i][1]))
        
m.update()

for thisDC in dcInfo:
    m.addConstr(quicksum(dvars[(thisDCId,thisStoreId)]*storeInfo[thisStoreId][1] for (thisDCId,thisStoreId) in dvars.keys() if thisDCId == thisDC[0]), GRB.LESS_EQUAL, thisDC[1])
    
for thisStore in storeInfo:
    m.addConstr(quicksum(dvars[(thisDCId,thisStoreId)] for (thisDCId,thisStoreId) in dvars.keys() if thisStoreId == thisStore[0]), GRB.EQUAL, 1)


    
m.update()
m.optimize()
stop_time = datetime.datetime.now()

results = []
for thisKey in dvars:
    if dvars[thisKey].x > 0:
        results.append((thisKey[0],thisKey[1],dvars[thisKey].x))
putResultsData(results,cnx)

for thisDecVar in dvars.values():
    if thisDecVar.x > 0:
        print thisDecVar.VarName, thisDecVar.Obj, thisDecVar.x
    
print 'Optimal Objective Function Value:', m.ObjVal

print "Variable/Constraint Establishment + Optimization Run Time: ", stop_time - start_time

