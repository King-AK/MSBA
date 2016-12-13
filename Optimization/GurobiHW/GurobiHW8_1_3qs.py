#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment
#Quicksum variant with Gurobi
from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("8_1_3")#problem 8.1-3
m.ModelSense = GRB.MINIMIZE # tell gurobi to maximize the objective function. We want to maximize profit here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

#rewrite this part properly similar to how it was written last night
#objective coefficients and constraint coefficients
obj_coeff=[[31.0, 45.0, 38.0],[29.0, 41.0, 35.0], [32.0, 46.0, 40.0],[28.0, 42.0, 0.0], [29.0, 43.0, 0.0] ]
cnstrt_coeff=[ [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0], [1.0, 1.0, 1.0] , [1.0, 1.0, 1.0] , [1.0, 1.0, 1.0]], [[1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0]]  ]
cnstrt_names=[ ["Plant1Production","Plant2Production","Plant3Production","Plant4Production", "Plant5Production"], ["Product1Production","Product2Production","Product3Production"] ]
cnstrt_rhs=[ [400.0,600.0,400.0,600.0,1000.0],[600.0,1000.0,800.0] ]
# Set up decision variables
dvars=[]
for i in range(len(obj_coeff)):
		new_dvar = []
		for j in range(len(obj_coeff[i])):
			new_dvar.append(m.addVar(vtype=GRB.CONTINUOUS,name='v'+str(i)+'_'+str(j),lb=0.0))
		dvars.append(new_dvar)
#set constraints
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function
for i in range(len(cnstrt_coeff)):
	for j in range(len(cnstrt_coeff[i])):
		if i==0: #horizontal constraints
			m.addConstr(quicksum((cnstrt_coeff[i][j][k] * dvars[j][k] for k in range(len(dvars[j])))), GRB.LESS_EQUAL, cnstrt_rhs[i][j],cnstrt_names[i][j])
		if i==1: #vertical constraints
			m.addConstr(quicksum((cnstrt_coeff[i][j][k] * dvars[k][j] for k in range(len(dvars)))), GRB.EQUAL, cnstrt_rhs[i][j], cnstrt_names[i][j])		
#misc hardcoded constraints 
m.addConstr(dvars[3][2], GRB.EQUAL, 0.0, "Plant4Product3Limit")
m.addConstr(dvars[4][2], GRB.EQUAL, 0.0, "Plant5Product3Limit")
#set objective function
m.setObjective(quicksum( obj_coeff[i][j] * dvars[i][j] for i in range(len(dvars)) for j in range(len(dvars[i]))), GRB.MINIMIZE)

# Update the model - It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
