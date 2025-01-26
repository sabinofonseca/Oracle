--10. Run the previous method that was created on 6. for all the stores from item_loc_soh to the history table. The entire migration should not take more than 10s to run (don't use parallel hint to solve it :))
--The process is ready to receive both ALL and all values to copy all the data for all locations to the item_loc_soh_hist table. case the user calls the procedure with a value for one location (example insert_item_loc_soh_hist.i_item_loc_soh_hist('101');), 
--it will copy only the data for the given location. case the input value is not ALL, neither all, neither a number, the process returns an error

BEGIN
    insert_item_loc_soh_hist.i_item_loc_soh_hist('ALL');
END;
