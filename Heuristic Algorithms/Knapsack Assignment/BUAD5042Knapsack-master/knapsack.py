def load_knapsack(things,knapsack_cap):
    """ You write your heuristic knapsack algorithm in this function using the argument values that are passed
             items/things: is a dictionary of the items no yet loaded into the knapsack
             knapsack_cap: the capacity of the knapsack (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             my_team_number_or_name: if this is a team assignment then set this variable equal to an integer representing your team number;
                                     if this is an indivdual assignment then set this variable to a string with you name
            items_to_pack: this is a list containing keys (integers) of the items you want to include in the knapsack
                           The integers refer to keys in the items dictionary. 
   """
        
    my_team_number_or_name = "akdavey"    # always return this variable as the first item
    items_to_pack = []    # use this list for the indices of the items you load into the knapsack
    load = 0.0            # use this variable to keep track of how much volume is already loaded into the backpack
    value = 0.0           # value in knapsack
    

    #EDIT THE CODE BELOW HERE -- DEVELOP CODE WHICH HITS THE OPTIMAL_SOLN IN THE SQL DATABASE FOR EACH PROBLEM -- leaning toward value/weight sort and then pack in greedy fashion until you cant fit anymore in
    item_keys = [k for k in things.keys()]
    #0-1 knapsack dynamic programming .. done with help from https://www.youtube.com/watch?v=EH6h7WA7sDw
    #create v and keep array, initialize to 0
    v=[]
    keep=[]
    for i in range(0,len(item_keys)+1): #range is 0 to num of items because we will need a null row of zeroes to start the matrix
        v.append([])
        keep.append([])
        for j in range(0,int(knapsack_cap)+1): #make subknapsacks plus an empty row
            v[i].append(0)
            keep[i].append(0)
    #break the problem up by doing many smaller knapsack problems.. do a for loop which allows us to populate the v and keep arrays
    final_index = -1
    for i in range(1,len(item_keys)+1):
        for j in range(1,int(knapsack_cap)+1):
            current_wt = things[item_keys[i-1]][0]
            current_val = things[item_keys[i-1]][1]
            #if the current weight is allowable for this sub knapsack problem and the value is superior to the cell directly above this item plus whatever is the best value for the sub knapsack problem corresponding to the remainder, then select the cvalue for this item plus the remainder solution and set keep =1, else select the value from the row above, and leave keep alone.
            current_knapsack_cap = j
            leftover_optimal_vknapsack = current_knapsack_cap - int(current_wt) #the index of the optimal knapsack worth considering for item i if i weighs little enough to fit more items in
            if current_wt <= current_knapsack_cap and leftover_optimal_vknapsack >=0: #item can fit in the knapsack and we dont get a negative index
                if current_val+v[i-1][leftover_optimal_vknapsack] > v[i-1][current_knapsack_cap]:
                    v[i][j] = current_val+v[i-1][leftover_optimal_vknapsack]
                    keep[i][j]=1
                else:
                    v[i][j] = v[i-1][j]
        final_index+=1
    #print final_index
    #print knapsack_cap
    #print v
    #print keep
    #sort through the keep array, keeping all the items which maximize value in the knapsack
    leftover_room=knapsack_cap 
    while leftover_room>0 and final_index >= 0:
        if keep[final_index+1][int(leftover_room)] == 1:
            pack_item = item_keys[final_index]
            items_to_pack.append(pack_item)
            load += things[pack_item][0]
            value += things[pack_item][1]
            leftover_room -= things[pack_item][0]
            final_index-=1
        else:
            final_index-=1

    return my_team_number_or_name, items_to_pack       # use this return statement when you have items to load in the knapsack
