--11 (should be 12?). Create a program (plsql and/or java, or any other language) that can extract to a flat file (csv), 1 file per location: the item, department unit cost, stock on hand quantity and stock value.
--Creating the 1000 files should take less than 30s.
--NOTE was not able to test the code due to on oracle cloud i cannot create neither access an Oralce Directory to create the output

DECLARE
   --cursor to fetch distinct locations
   CURSOR loc_cursor IS
      SELECT DISTINCT loc FROM item_loc_soh_hist;
   
   --variables to hold directory and file handle
   file_handle UTL_FILE.FILE_TYPE;
   v_directory CONSTANT VARCHAR2(30) := 'ORACLE_DIRECTORY';
   v_filename VARCHAR2(50);
   
   -- table of item_loc_hist row  type to use with FOR ALL
   TYPE item_loc_soh_hist_tab IS TABLE OF item_loc_soh_hist%ROWTYPE;
   v_data item_loc_soh_hist_tab;
BEGIN
   --loop through each location
   FOR loc_rec IN loc_cursor LOOP
      --set file name dynamically for each location
      v_filename := 'LOC_' || loc_rec.loc || '.csv';

      --open the file for writing
      file_handle := UTL_FILE.FOPEN(v_directory, v_filename, 'W');

      --bulk collect data for the current location
      SELECT item, loc, dept, unit_cost, stock_on_hand, stock_value
      BULK COLLECT INTO v_data
      FROM item_loc_soh_hist
      WHERE loc = loc_rec.loc;

      --write CSV header to file
      UTL_FILE.PUT_LINE(file_handle, 'ITEM,LOC,DEPT,UNIT_COST,STOCK_ON_HAND,STOCK_VALUE');

      --use FOR ALL for better performance to loop through the data
      FOR i IN v_data.FIRST .. v_data.LAST LOOP
         UTL_FILE.PUT_LINE(file_handle, 
            v_data(i).item || ',' || 
            v_data(i).loc || ',' || 
            v_data(i).dept || ',' || 
            v_data(i).unit_cost || ',' || 
            v_data(i).stock_on_hand || ',' || 
            v_data(i).stock_value);
      END LOOP;

      --close the file
      UTL_FILE.FCLOSE(file_handle);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      IF UTL_FILE.IS_OPEN(file_handle) THEN
         UTL_FILE.FCLOSE(file_handle);
      END IF;
      RAISE;
END;
/