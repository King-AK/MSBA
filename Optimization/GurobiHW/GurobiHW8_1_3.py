#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment

from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("8_1_3")#problem 8.1-3
m.ModelSense = GRB.MINIMIZE # tell gurobi to minimize the objective function. We want to minimize costs here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

# Set up decision variables, need 15 decision variables for transportation-like problem, much bigger
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
v12 = m.addVar(vtype=GRB.CONTINUOUS,name='v12', lb=0.0, ub=0.0)
v13 = m.addVar(vtype=GRB.CONTINUOUS,name='v13', lb=0.0)
v14 = m.addVar(vtype=GRB.CONTINUOUS,name='v14', lb=0.0)
v15 = m.addVar(vtype=GRB.CONTINUOUS,name='v15', lb=0.0, ub=0.0)
#Update model to include variables
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function

# set up constraints
m.addConstr(v1 + v2 + v3 , GRB.LESS_EQUAL, 400.0,"Plant1Production")
m.addConstr(v4 + v5 + v6, GRB.LESS_EQUAL, 600.0,"Plant2Production")
m.addConstr(v7 + v8 + v9, GRB.LESS_EQUAL, 400.0,"Plant3Production")
m.addConstr(v10 + v11 + v12, GRB.LESS_EQUAL, 600.0,"Plant4Production")
m.addConstr(v13 + v14 + v15, GRB.LESS_EQUAL, 1000.0,"Plant5Production")

m.addConstr(v1 + v4 + v7 + v10 + v13, GRB.EQUAL, 600.0,"Product1Production")
m.addConstr(v2 + v5 + v8 + v11 + v14, GRB.EQUAL, 1000.0,"Product2Production")
m.addConstr(v3 + v6 + v9 + v12 + v15, GRB.EQUAL, 800.0,"Product3Production")

#12 and 15 cannot be produced, as plant3 is incapable of producing product 3
m.addConstr(v12, GRB.EQUAL, 0.0, "Plant4Product3Limit")
m.addConstr(v15, GRB.EQUAL, 0.0, "Plant5Product3Limit")

# Set objective function--big ass minmimzation function
m.setObjective(31.0 * v1 + 45.0 * v2 + 38.0 * v3 + 29.0 * v4 + 41.0 * v5 + 35.0 * v6 + 32.0 * v7 + 46.0 * v8 + 40.0 * v9 + 28.0 * v10 + 42.0* v11 + 0.0 * v12 + 29.0 * v13 + 43.0 * v14 + 0.0 * v15, GRB.MINIMIZE)

# Update the model
# It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
