#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment

from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("3_1_7")#problem 3.1-7
m.ModelSense = GRB.MAXIMIZE # tell gurobi to maximize the objective function. We want to maximize profit here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

# Set up decision variables
v1 = m.addVar(vtype=GRB.CONTINUOUS,name='v1', lb=0.0)
v2 = m.addVar(vtype=GRB.CONTINUOUS,name='v2', lb=0.0)
v3 = m.addVar(vtype=GRB.CONTINUOUS,name='v3', lb=0.0)
#Update model to include variables
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function

# set up constraints
m.addConstr(0.02 * v1 + 0.03 * v2 + 0.05*v3, GRB.LESS_EQUAL, 40.0,"Machine1Hours")
m.addConstr(0.05 * v1 + 0.02 * v2 + 0.04, GRB.LESS_EQUAL, 40.0,"Machine2Hours")

# Set objective function
m.setObjective(50.0 * v1 + 40.0 * v2 + 30 * v3, GRB.MAXIMIZE)

# Update the model
# It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
