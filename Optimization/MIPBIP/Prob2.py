# -*- coding: utf-8 -*-
"""
Created on Tue Oct 18 10:28:58 2016

@author: Eric
"""
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 27 16:04:32 2016

@author: liuba
"""

from gurobipy import *

m = Model("Two-dimensional Generator Expressions")
m.ModelSense = GRB.MINIMIZE
obj_coeff = [[24.92,30.36,34.9,39.3,31.78,28.89,44.49,34.99,30.4,30.79,33.31,29.42,34.62,36.18,41.88],[35.57,21.7,36.79,43.38,31.42,40.79,30.96,29.92,29.62,25.74,41.77,32.04,40.69,43.05,30.46],[44.57,22.94,23.97,40.35,26.31,27.98,35,38.77,29.88,25.47,38.02,33.53,41.75,27.88,37.74],[36.38,36.78,38.07,26.37,29.46,32.75,26.71,30.67,30.15,30.96,39.77,37.08,30.97,37.2,29.04],[43.06,39.52,28.24,39.64,21.02,32.27,39.11,26.87,39.3,36.78,34.29,27.8,40.69,39.36,26.62],[40,40.78,30.37,29.06,36.83,23.3,27.66,34.1,25.21,35.97,33.24,43.08,34.48,25.04,27.67],[42.78,40.26,30.13,30.07,38.74,25.42,26.52,22.9,30.33,31.91,31.21,41.51,30.11,27.16,42.24],[28.51,37.04,33.64,40.15,31.57,31.21,38.05,20.55,40.37,37.04,39.44,40.03,41.89,40.68,28.46],[32.68,41.09,31.26,31.12,36.6,42.88,28.38,33.22,25.05,29.22,33.83,36,38.53,34.74,37.84],[32.83,31.23,39.85,29.23,21.06,35.46,44.64,37.5,31.33,21.34,42.79,41.56,37.13,42,31.39],[39.44,22.16,39.22,34.29,37.82,33.98,43.78,26.06,44.11,26.37,26.82,40.44,34.71,42.37,42.86],[34.41,39.82,27.01,33.52,28.79,29.19,42.17,28.96,39.16,39.48,39.45,26.71,24.97,35.39,41.33],[27.51,35.59,26.86,45.97,32.64,34.21,45.88,36.42,32.76,28.71,36.66,36.66,23.18,26.14,26.42],[29.01,40.13,28.84,43.7,32.75,29.23,33.11,32.37,25.1,22.92,34.16,27.38,26.28,24.67,39.63],[26.07,28.96,33.83,36.53,32.95,28.25,32.21,36.24,29.18,22.37,30.78,26.84,36.74,30.18,26.33]]

mines = range(0,14)
product_names=["Mine 0", "Mine 1","Mine 2","Product 3", "Mine 4", "Mine 5", "Mine 6", "Mine 7", "Mine 8", "Mine 9", "Mine 10", "Mine 11", "Mine 12", "Mine 13", "Mine 14"]
plants = range(0,14)
plant_names = ["Plant 0", "Plant 1","Plant 2","Plant 3","Plant 4","Plant 5", "Plant 6", "Plant 7", "Plant 8", "Plant 9", "Plant 10", "Plant 11", "Plant 12", "Plant 13", "Plant 14"]
plant_demand =  [153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300, 153300]
mine_purchase_price = [9355730,4652163,9908390,8379730,6946479,4760629,4880341,9804748,6100783,7224557,7756098,4015446,10580870,8088620,10866700]
matrix_c =[] #enw matrix holding demand*objective matrix
dvars = [] # if mine i serves plant j
qvars = [] # if mine i is purchased
for i in range(len(obj_coeff)):
    matrix_c.append([])
    new_dvar = []
    qvars.append(m.addVar(vtype=GRB.BINARY,name='y_'+str(i), lb=0.0))
    for j in range(len(obj_coeff[i])):
        new_dvar.append(m.addVar(vtype=GRB.BINARY,name='q_'+str(i)+"_"+str(j),lb=0.0))
    	matrix_c[i].append(obj_coeff[i][j]*plant_demand[i])
    dvars.append(new_dvar)
m.update()

# set up constraints 
for i in range(len(obj_coeff)):
	for j in range(len(dvars[i])):
		m.addConstr(dvars[i][j], GRB.LESS_EQUAL, qvars[i], "mine_building_constraint"+str(i))
	m.addConstr(quicksum((dvars[i][j] for j in range(len(dvars[i])))), GRB.EQUAL, 1, product_names[i])#plant_demand[i],product_names[i])

m.update()
# Set objective function
#m.setObjective(quicksum(obj_coeff[i][j] * dvars[i][j] for i in range(len(obj_coeff)) for j in range(len(obj_coeff[i]))))
m.setObjective(quicksum( (matrix_c[i][j] * dvars[i][j]) for i in range(len(matrix_c)) for j in range(len(matrix_c[i]))) + quicksum((mine_purchase_price[i] *qvars[i]) for i in range(len(mine_purchase_price))))
m.optimize()
total_cost=0
for i in range(len(dvars)):
    for j in range(len(dvars[i])):
    	#if dvars[i][j].x == 1.0:
        print dvars[i][j].VarName, dvars[i][j].Obj, dvars[i][j].x
        total_cost+=float(dvars[i][j].Obj)*float(dvars[i][j].x)
#for i in range(len(qvars)):
#	print qvars[i].VarName, qvars[i].Obj,  qvars[i].x
#	total_cost+=float(qvars[i].Obj) *float(qvars[i].x) 
print "the total cost of purchase is: $" + str(total_cost)