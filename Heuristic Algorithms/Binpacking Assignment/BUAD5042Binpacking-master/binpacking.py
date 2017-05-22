def binpack(articles,bin_cap):
    """ You write your heuristic bin packing algorithm in this function using the argument values that are passed
             articles: a dictionary of the items to be loaded into the bins: the key is the article id and the value is the article volume
             bin_cap: the capacity of each (identical) bin (volume)
    
        Your algorithm must return two values as indicated in the return statement:
             my_team_number_or_name: if this is a team assignment then set this variable equal to an integer representing your team numb0er;
                                     if this is an indivdual assignment then set this variable to a string with you name
             bin_contents: this is a list containing keys (integers) of the items you want to include in the knapsack
                           The integers refer to keys in the items dictionary. 
   """
        
    my_team_number_or_name = "akdavey"    # always return this variable as the first item
    bin_contents = []    # use this list document the article ids for the contents of 
                         # each bin, the contents of each is to be listed in a sub-list
    intermediate_bins=[]#listing of bins in the intermediate stage, will be a lsit of list
    keys = articles.keys() 
    while len(keys)!=0:
        for i in keys:
            #for every item in the key list, we are going to put it 
            #into the bin which would minimize leftover space in that bin
            #or create a new bin if no bins exist that can fit that item
            best_bin = None
            min_leftover_space = bin_cap #placeholder for min leftover space
            for j in intermediate_bins:
                check = bin_cap - (j[0]+articles[i])
                if check < bin_cap and check >= 0:
                    min_leftover_space = check
                    best_bin = j

            if best_bin == None:
                new_bin = [articles[i]]
                new_bin.append([i])
                intermediate_bins.append(new_bin)
                keys.remove(i)
            else:
                best_bin[0]+=articles[i]
                best_bin[1].append(i)
                keys.remove(i)
    for i in intermediate_bins:
        bin_contents.append(i[1])


    return my_team_number_or_name, bin_contents       # use this return statement when you have items to load in the knapsack
