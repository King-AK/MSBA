#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment
#Quicksum variant with Gurobi
from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("8_1_1")#problem 8.1-1
m.ModelSense = GRB.MINIMIZE # tell gurobi to maximize the objective function. We want to maximize profit here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

#objective coefficients and constraint coefficients
obj_coeff=[[800.0, 1300.0, 400.0, 700.0], [1100.0, 1400.0, 600.0, 1000.0], [600.0, 1200.0, 800.0, 900.0]]
cnstrt_coeff=[ [[1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0]], [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0], [1.0, 1.0, 1.0], [1.0, 1.0, 1.0]]  ]
cnstrt_names=[ ["Plant1Production","Plant2Production","Plant3Production"], ["Dist1Allocation","Dist2Allocation","Dist3Allocation","Dist4Allocation"] ]
cnstrt_rhs=[ [12.0,17.0,11.0],[10.0,10.0,10.0,10.0] ]
# Set up decision variables
dvars=[]
for i in range(len(obj_coeff)):
		new_dvar = []
		for j in range(len(obj_coeff[i])):
			new_dvar.append(m.addVar(vtype=GRB.CONTINUOUS,name='v'+str(i)+'_'+str(j),lb=0.0))
		dvars.append(new_dvar)
#for i in dvars:
#	print i
#Update model to include variables
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function
for i in range(len(cnstrt_coeff)):
	for j in range(len(cnstrt_coeff[i])):
		if i==0: #horizontal constraints
			m.addConstr(quicksum((cnstrt_coeff[i][j][k] * dvars[j][k] for k in range(len(dvars[j])))), GRB.EQUAL, cnstrt_rhs[i][j],cnstrt_names[i][j])
			#for k in range(len(dvars[j])):
			#	print dvars[j][k].varName + '*' + str(cnstrt_coeff[i][j][k]) + '=' + str(cnstrt_rhs[i][j])
		if i==1: #vertical constraints
			m.addConstr(quicksum((cnstrt_coeff[i][j][k] * dvars[k][j] for k in range(len(dvars)))), GRB.EQUAL, cnstrt_rhs[i][j], cnstrt_names[i][j])
			#for k in range(len(dvars)):
			#	print dvars[k][j].varName + '*' + str(cnstrt_coeff[i][j][k]) + '=' + str(cnstrt_rhs[i][j])
	#print '\n\n'		
# set up constraints 
#for i in range(len(dvars)):
#	for j in range(len(dvars[i])):
#		print '(100+0.5*'+str(obj_coeff[i][j]) + ')*'+ dvars[i][j].varName 
m.setObjective(quicksum( (100+0.5*obj_coeff[i][j]) * dvars[i][j] for i in range(len(dvars)) for j in range(len(dvars[i]))), GRB.MINIMIZE)

# Update the model - It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
