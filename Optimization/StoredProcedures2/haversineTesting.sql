select lat, lon INTO @dclat, @dclon from wm_dcs limit 1;
select lat, lon INTO @storelat, @storelon from wm_stores limit 1;
CALL `sp2`.`spHaversine`(@storelat, @storelon, @dclat, @dclon);
select lat*@storelat from wm_stores limit 1;
select store_id from wm_Stores limit 1;
CALL `sp2`.`spHaversineDCs`(21);
/*run a for loop and call spHaversineDCs for each store in the database*/
/*for stores that dont get returned back in the for loop... loop has to be in a SP!!!*/