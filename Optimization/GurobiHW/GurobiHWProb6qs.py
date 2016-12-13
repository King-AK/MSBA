#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment
#Quicksum variant with Gurobi Quicksum version
from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("6")#problem 6
m.ModelSense = GRB.MINIMIZE # tell gurobi to maximize the objective function. We want to maximize profit here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

#rewrite this part properly similar to how it was written last night
#objective coefficients and constraint coefficients
obj_coeff=[[500.0, 350.0, 250.0, 1300.0, 0.0, 750.0],[600.0, 200.0, 500.0, 0.0, 850.0, 900.0], [250.0, 0.0, 175.0, 300.0, 500.0, 400.0],[0.0, 875.0, 1000.0, 1100.0, 900.0, 0.0],[1000.0, 450.0, 0.0, 900.0, 300.0, 800.0]]
cnstrt_coeff=[ [[1.0, 1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0, 1.0] ], [[1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0, 1.0]]  ]
cnstrt_names=[ ["DC1Capacity","DC2Capacity","DC3Capacity","DC4Capacity", "DC5Capacity"], ["S1TLNeed","S2TLNeed","S3TLNeed","S4TLNeed","S5TLNeed","S6TLNeed"] ]
cnstrt_rhs=[ [10.0,20.0,5.0,15.0,10.0],[5.0,4.0,7.0,8.0,5.0,5.0] ]
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
#misc hardcoded constraints for N/A values 
m.addConstr(dvars[0][4], GRB.EQUAL, 0.0, "1to5Limit")
m.addConstr(dvars[1][3], GRB.EQUAL, 0.0, "2to4Limit")
m.addConstr(dvars[2][1], GRB.EQUAL, 0.0, "3to2Limit")
m.addConstr(dvars[3][0], GRB.EQUAL, 0.0, "4to1Limit")
m.addConstr(dvars[3][5], GRB.EQUAL, 0.0, "4to6Limit")
m.addConstr(dvars[4][2], GRB.EQUAL, 0.0, "5to3Limit")

#set objective function
m.setObjective(quicksum( obj_coeff[i][j] * dvars[i][j] for i in range(len(dvars)) for j in range(len(dvars[i]))), GRB.MINIMIZE)

# Update the model - It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
