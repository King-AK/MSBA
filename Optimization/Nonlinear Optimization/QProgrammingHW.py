#VJ Davey
#11/17/2016

from gurobipy import *
import MySQLdb as mySQL
import matplotlib.pyplot as plt

def getDBData(commandString, connection):
    cursor = connection.cursor()
    cursor.execute(commandString)
    results = list(cursor.fetchall())
    cursor.close()
    return results

port_size = 100.0
max_risk = 5.0
max_risk_inc = 5.0
numRiskLevels = 20
numStocks = 15

vc = {}
#point to locaiton of portDataVar on machine
f = open('C:\\Users\\VJ\\Documents\\MSBA\\Optimization\\Nonlinear Optimization\\PortDataVarCovar(1).csv', 'r')
for line in f:
       line = line.strip()
       line = line.strip("\n")
       pieces = line.split(",")
       stock1,stock2,covar = pieces
       stock1 = int(stock1)
       stock2 = int(stock2)
       covar = float(covar)
       vc[(stock1,stock2)] = covar
f.close()

avg_return= {}
#point to location of avg returns on machine
f = open('C:\\Users\\VJ\\Documents\\MSBA\\Optimization\\Nonlinear Optimization\\avgReturns(1).csv', 'r')
for line in f:
       line = line.strip()
       line = line.strip("\n")
       pieces = line.split(",")
       id_stock,avgReturn = pieces
       id_stock = int(id_stock)
       avgReturn = float(avgReturn)
       avg_return[id_stock] = avgReturn
f.close()

m = Model("QP-Proto")
m.ModelSense = GRB.MAXIMIZE

x = {}
for i in avg_return.keys():
    x[i] = m.addVar(vtype=GRB.CONTINUOUS,lb=0.0,name="a"+str(i))

m.update()

m.addConstr(quicksum(x[i] for i in x.keys()),GRB.EQUAL,port_size,name="Fixed Portfolio Size")

l=0
#should create a  list of numRiskLevels+1 sublists of the form [risk_level, avg_return]
result=[]
for i in range(numRiskLevels+1): 
    #start with an incrememnt, first model infeasible otherwise
    max_risk=max_risk+max_risk_inc
    m.addConstr(quicksum(x[i] * vc[(i,j)] * x[j]  for i in range(numStocks) for j in range(numStocks)),GRB.LESS_EQUAL,max_risk,name="Risk Constraint (Quadratic)")
    m.setObjective(quicksum(avg_return[i] * x[i] / port_size for i in range(numStocks)),GRB.MAXIMIZE)
    m.update()
    m.optimize()
    row = []
    if m.status == 2:
        for constr in m.getQConstrs():
            row.append(constr.QCRHS)
            m.remove(constr)
        row.append(m.ObjVal)
        result.append(row)
#print the sublists, list by list
for i in result:
    print i

#loop through the results and pull out the risk levels and returns into seperate lists 
risk_level=[]
average_return=[]    
for i in range(len(result)):
    risk_level.append(result[i][0])
    average_return.append(result[i][1])
    
#plot risk vs return lists
plt.plot(risk_level, average_return, marker='x', color='r')
plt.title("Portfolio Risk vs Avg. Return")
plt.xlabel("Risk")
plt.ylabel("Avg. Return")
plt.show()


        
