def trans(dist, dcs, stores_vol):
    my_team_or_name = "akdavey"
    result = []
    """
    Logic: want to get each store supplied by the closest DC to minimize costs while adhereing to constraints for every store need to find the closest DC assign that closest DC
    """
    running_totals, st_vol = {},{}
    for key in dcs.keys():
        running_totals[key] = [0.0,0,0]
    for i in stores_vol:
        st_vol[i[0]] = i[1]
    import math
    store_dc_pairs = sorted(dist.keys(), key=lambda x: (round(dist[x],-1), -(dcs[x[0]][1]-running_totals[x[0]][1])), reverse=False)#with pure less than and not le
    j=0
    while len(st_vol.keys()) > 0 :
        i = store_dc_pairs[j]
        store, dc = i[1], i[0]
        if store in st_vol.keys():  
            store_daily_volume  = st_vol[store]
            dc_daily_capacity, dc_door_capacity, dc_driver_capacity= dcs[dc][0], dcs[dc][1], dcs[dc][2]
            new_driver_total = running_totals[dc][2] + int(math.ceil(store_daily_volume/trail_cu_ft))
            new_cubic_total = running_totals[dc][0] + store_daily_volume 
            new_door_total = running_totals[dc][1]+1
            if new_door_total<=dc_door_capacity and new_driver_total<=dc_driver_capacity and new_cubic_total<=dc_daily_capacity:#if the dc_id in question has more cubic capacity and if the dc_id in question has more door_capacity and driver_capacity                    
                result.append((store,dc)) #have to switch tuple order
                del st_vol[store]
                running_totals[dc] = (new_cubic_total, new_door_total, new_driver_total)
                store_dc_pairs = sorted(dist.keys(), key=lambda x: (round(dist[x],-1), -(dcs[x[0]][1]-running_totals[x[0]][1])), reverse=False)#with pure less than and not le
                j=0
        j+=1

    return my_team_or_name, result