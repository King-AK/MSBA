#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment

from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("8_1_1")#problem 8.1-1
m.ModelSense = GRB.MINIMIZE # tell gurobi to minimize the objective function. We want to minimize costs here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

# Set up decision variables, need 12 decision variables for transportation problem, much bigger
v1 = m.addVar(vtype=GRB.CONTINUOUS,name='v1', lb=0.0)
v2 = m.addVar(vtype=GRB.CONTINUOUS,name='v2', lb=0.0)
v3 = m.addVar(vtype=GRB.CONTINUOUS,name='v3', lb=0.0)
v4 = m.addVar(vtype=GRB.CONTINUOUS,name='v4', lb=0.0)
v5 = m.addVar(vtype=GRB.CONTINUOUS,name='v5', lb=0.0)
v6 = m.addVar(vtype=GRB.CONTINUOUS,name='v6', lb=0.0)
v7 = m.addVar(vtype=GRB.CONTINUOUS,name='v7', lb=0.0)
v8 = m.addVar(vtype=GRB.CONTINUOUS,name='v8', lb=0.0)
v9 = m.addVar(vtype=GRB.CONTINUOUS,name='v9', lb=0.0)
v10 = m.addVar(vtype=GRB.CONTINUOUS,name='v10', lb=0.0)
v11 = m.addVar(vtype=GRB.CONTINUOUS,name='v11', lb=0.0)
v12 = m.addVar(vtype=GRB.CONTINUOUS,name='v12', lb=0.0)

#Update model to include variables
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function

# set up constraints
m.addConstr(v1 + v2 + v3 + v4, GRB.EQUAL, 12.0,"Plant1Production")
m.addConstr(v5 + v6 + v7 + v8, GRB.EQUAL, 17.0,"Plant2Production")
m.addConstr(v9 + v10 + v11 + v12, GRB.EQUAL, 11.0,"Plant3Production")

m.addConstr(v1 + v5 + v9, GRB.EQUAL, 10.0,"Dist1Allocation")
m.addConstr(v2 + v6 + v10, GRB.EQUAL, 10.0,"Dist2Allocation")
m.addConstr(v3 + v7 + v11, GRB.EQUAL, 10.0,"Dist3Allocation")
m.addConstr(v4 + v8 + v12, GRB.EQUAL, 10.0,"Dist4Allocation")

# Set objective function--big ass minmimzation function
m.setObjective(500.0 * v1 + (100.0+0.5*(1300)) * v2 + (100.0+0.5*(400)) * v3 + (100.0+0.5*(700)) * v4 + (100.0+0.5*(1100)) * v5 + (100.0+0.5*(1400)) * v6 + (100.0+0.5*(600)) * v7 + (100.0+0.5*(1000)) * v8 + (100.0+0.5*(600)) * v9 + (100.0+0.5*(1200)) * v10 + (100.0+0.5*(800)) * v11 + (100.0+0.5*(900)) * v12, GRB.MINIMIZE)

# Update the model
# It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
