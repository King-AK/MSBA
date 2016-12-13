#VJ Davey
#10/3/2016
#Gurobi Optimization Assignment

from gurobipy import *

# create Gurobi model and assign it to a variable in python
m = Model("3_1_3")#problem 3.1-3
m.ModelSense = GRB.MAXIMIZE # tell gurobi to maximize the objective function. We want to maximize profit here
m.setParam('TimeLimit',7200)     #sets a time limit on execution to some number of seconds

# Set up decision variables
v1 = m.addVar(vtype=GRB.CONTINUOUS,name='v1', lb=0.0)
v2 = m.addVar(vtype=GRB.CONTINUOUS,name='v2', lb=0.0)
v3 = m.addVar(vtype=GRB.CONTINUOUS,name='v3', lb=0.0)
#Update model to include variables
m.update() #THIS must be done so Gurobi can recognize variable names when referenced in the constraints and objective function

# set up constraints
m.addConstr(9.0 * v1 + 3.0 * v2 + 5.0 * v3, GRB.LESS_EQUAL, 500.0,"MillingMachineHours")
m.addConstr(5.0 * v1 + 4.0 * v2, GRB.LESS_EQUAL, 350.0,"LatheHours")
m.addConstr(3.0 * v1 + 2.0 * v3, GRB.LESS_EQUAL, 150.0,"GrinderHours")
m.addConstr(v3, GRB.LESS_EQUAL, 20.0, "Product3Production")

# Set objective function
m.setObjective(50.0 * v1 + 20.0 * v2 + 25.0 * v3, GRB.MAXIMIZE)

# Update the model
# It won't run if you don't do this
m.update()

# Optimize the model
m.optimize()

#printout of results
for var in m.getVars():
    print "Variable Name = %s, Optimal Value = %s, Lower Bound = %s, Upper Bound = %s" % (var.varName, var.x,var.lb,var.ub)
    