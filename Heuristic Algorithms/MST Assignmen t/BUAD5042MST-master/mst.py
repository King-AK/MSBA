def mst_algo(locs,dist):
    name_or_team = "akdavey"
    mst = []
    '''
    locs contains data about each location taken from the database including location id, latitude, longitude address and type of facility. In list of lists format.
    dist is a dictionary of of distances between all pairs of locations -- key is (store id, store id), value is distance
    '''
    connections = dist.keys()
    connections.sort(key=lambda x: dist[x], reverse=False) #sort connections by least distance
    touched_edges = [] #keep track of edges already connected to
    edges = 0
    nodes = len(locs)
    
    def find_connections(x,built_set,touched_edges): #recursive function to determine connection set for a node x, and its given built connection set. Returns a full set of all the other nodes node x is connectd to
        built_set.add(x) #add item x to the built set
        temp_set=built_set.copy()#make a copy of the built set
        for tup in touched_edges:
            if x in tup:
                temp_set.add(tup[0])
                temp_set.add(tup[1])
        if temp_set.issubset(built_set): #check if every element in the temp_set is in the built_set
            return built_set
        else: #get the connections for all the items connected to x and add it to x's connections
            missing_values=temp_set.difference(built_set)
            for y in missing_values:
                y_connections = find_connections(y,built_set,touched_edges)
                built_set = built_set.union(y_connections)
            return built_set

    while edges < nodes - 1:
        i = connections[0] #since list is sorted, always evaluate the first item in the list
        i0_connects = find_connections(i[0],set(),touched_edges)
        i1_connects = find_connections(i[1],set(),touched_edges)
        if bool(i0_connects.intersection(i1_connects)):
            connections.pop(0)
        else:
            mst.append(i)
            touched_edges.append(i)
            edges+=1
            connections.pop(0)

    return name_or_team, mst