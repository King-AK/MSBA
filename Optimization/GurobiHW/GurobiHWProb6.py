#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment

from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("6")#problem 6
m.ModelSense = GRB.MINIMIZE # tell gurobi to minimize the objective function. We want to minimize costs here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

# Set up decision variables, need 30 decision variables for transportation-like problem, much bigger
v1 = m.addVar(vtype=GRB.CONTINUOUS,name='v1', lb=0.0)
v2 = m.addVar(vtype=GRB.CONTINUOUS,name='v2', lb=0.0)
v3 = m.addVar(vtype=GRB.CONTINUOUS,name='v3', lb=0.0)
v4 = m.addVar(vtype=GRB.CONTINUOUS,name='v4', lb=0.0)
v5 = m.addVar(vtype=GRB.CONTINUOUS,name='v5', lb=0.0, ub=0.0)
v6 = m.addVar(vtype=GRB.CONTINUOUS,name='v6', lb=0.0)
v7 = m.addVar(vtype=GRB.CONTINUOUS,name='v7', lb=0.0)
v8 = m.addVar(vtype=GRB.CONTINUOUS,name='v8', lb=0.0)
v9 = m.addVar(vtype=GRB.CONTINUOUS,name='v9', lb=0.0)
v10 = m.addVar(vtype=GRB.CONTINUOUS,name='v10', lb=0.0, ub=0.0)
v11 = m.addVar(vtype=GRB.CONTINUOUS,name='v11', lb=0.0)
v12 = m.addVar(vtype=GRB.CONTINUOUS,name='v12', lb=0.0)
v13 = m.addVar(vtype=GRB.CONTINUOUS,name='v13', lb=0.0)
v14 = m.addVar(vtype=GRB.CONTINUOUS,name='v14', lb=0.0, ub=0.0)
v15 = m.addVar(vtype=GRB.CONTINUOUS,name='v15', lb=0.0)
v16 = m.addVar(vtype=GRB.CONTINUOUS,name='v16', lb=0.0)
v17 = m.addVar(vtype=GRB.CONTINUOUS,name='v17', lb=0.0)
v18 = m.addVar(vtype=GRB.CONTINUOUS,name='v18', lb=0.0)
v19 = m.addVar(vtype=GRB.CONTINUOUS,name='v19', lb=0.0, ub=0.0)
v20 = m.addVar(vtype=GRB.CONTINUOUS,name='v20', lb=0.0)
v21 = m.addVar(vtype=GRB.CONTINUOUS,name='v21', lb=0.0)
v22 = m.addVar(vtype=GRB.CONTINUOUS,name='v22', lb=0.0)
v23 = m.addVar(vtype=GRB.CONTINUOUS,name='v23', lb=0.0)
v24 = m.addVar(vtype=GRB.CONTINUOUS,name='v24', lb=0.0, ub=0.0)
v25 = m.addVar(vtype=GRB.CONTINUOUS,name='v25', lb=0.0)
v26 = m.addVar(vtype=GRB.CONTINUOUS,name='v26', lb=0.0)
v27 = m.addVar(vtype=GRB.CONTINUOUS,name='v27', lb=0.0, ub= 0.0)
v28 = m.addVar(vtype=GRB.CONTINUOUS,name='v28', lb=0.0)
v29 = m.addVar(vtype=GRB.CONTINUOUS,name='v29', lb=0.0)
v30 = m.addVar(vtype=GRB.CONTINUOUS,name='v30', lb=0.0)


#Update model to include variables
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function

# set up constraints
m.addConstr(v1 + v2 + v3 + v4 + v5 + v6 , GRB.LESS_EQUAL, 10.0,"DC1Capacity")
m.addConstr(v7 + v8 + v9 + v10 + v11 + v12, GRB.LESS_EQUAL, 20.0,"DC2Capacity")
m.addConstr(v13 + v14 + v15 + v16 + v17 + v18, GRB.LESS_EQUAL, 5.0,"DC3Capacity")
m.addConstr(v19 + v20 + v21 + v22 + v23 + v24, GRB.LESS_EQUAL, 15.0,"DC4Capacity")
m.addConstr(v25 + v26 + v27 + v28 + v29 + v30, GRB.LESS_EQUAL, 10.0,"DC5Capacity")

m.addConstr(v1 + v7 + v13 + v19 + v25, GRB.EQUAL, 5.0,"Store1TruckloadNeed")
m.addConstr(v2 + v8 + v14 + v20 + v26, GRB.EQUAL, 4.0,"Store2TruckloadNeed")
m.addConstr(v3 + v9 + v15 + v21 + v27, GRB.EQUAL, 7.0,"Store3TruckloadNeed")
m.addConstr(v4 + v10 + v16 + v22 + v28, GRB.EQUAL, 8.0,"Store4TruckloadNeed")
m.addConstr(v5 + v11 + v17 + v23 + v29, GRB.EQUAL, 5.0,"Store5TruckloadNeed")
m.addConstr(v6 + v12 + v18 + v24 + v30, GRB.EQUAL, 5.0,"Store6TruckloadNeed")

#NAs where no trucking companies were found to transport from a particular origin to a particular destination
m.addConstr(v5, GRB.EQUAL, 0.0, "DC1toStore5Limit")
m.addConstr(v10, GRB.EQUAL, 0.0, "DC2toStore4Limit")
m.addConstr(v14, GRB.EQUAL, 0.0, "DC3toStore2Limit")
m.addConstr(v19, GRB.EQUAL, 0.0, "DC4toStore1Limit")
m.addConstr(v24, GRB.EQUAL, 0.0, "DC2toStore6Limit")
m.addConstr(v27, GRB.EQUAL, 0.0, "DC5toStore3Limit")
# Set objective function--big ass minmimzation function
m.setObjective(500.0 * v1 + 350.0 * v2 + 250.0 * v3 + 1300.0 * v4 + 0.0 * v5 + 750.0 * v6 + 600.0 * v7 + 200.0 * v8 + 500.0 * v9 + 0.0 * v10 + 850.0* v11 + 900.0 * v12 + 250.0 * v13 + 0.0 * v14 + 175.0 * v15 + 300.0 * v16 + 500.0 * v17 + 400.0 * v18 + 0.0 * v19 + 875.0 * v20 + 1000.0 * v21 + 1100.0 * v22 + 900.0 * v23 + 0.0 * v24 + 1000.0 * v25 + 450.0 * v26 + 0.0 * v27 + 900.0 * v28 + 300.0 * v29 + 800.0 * v30, GRB.MINIMIZE)

# Update the model
# It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
