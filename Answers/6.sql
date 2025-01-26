--6. Create a package with procedure or function that can be invoked by store or all stores to save the item_loc_soh to a new table that will contain the same information plus the stock value per item/loc (unit_cost*stock_on_hand)
--NOTE: I was not able to test the inser append without logging because, although I've created a service request to ask for more database space, i was able to do the tests with 1M records but not with 10M.

--Creating package 
CREATE OR REPLACE PACKAGE insert_item_loc_soh_hist IS
    PROCEDURE i_item_loc_soh_hist(i_loc IN VARCHAR2);
END insert_item_loc_soh_hist;
/

--creating package body
CREATE OR REPLACE PACKAGE BODY insert_item_loc_soh_hist IS
    PROCEDURE i_item_loc_soh_hist(i_loc IN VARCHAR2) IS
    e_invalid_number EXCEPTION;
    BEGIN
        --not able to test due to lack of space
        --execute immediate('drop table item_loc_soh_hist');
        --execute immediate(' CREATE TABLE item_loc_soh_hist as SELECT ilsoh.*,  (ilsoh.unit_cost * ilsoh.stock_on_hand) stockvalue FROM item_loc_soh ilsoh where 1=0 ');
        --execute immediate('ALTER TABLE item_loc_soh_hist NOLOGGING');
        --using Upper to compare the input value to allow both values 'all' and 'ALL' locations
        IF UPPER(i_loc) = 'ALL' THEN
            --copying data from all locations from item_loc_soh into item_loc_soh_hist including (ilsoh.unit_cost * ilsoh.stock_on_hand) as stockvalue
            --not able to test due to lack of space
            --INSERT INTO /*+ APPEND */  item_loc_soh_hist 
            INSERT INTO  item_loc_soh_hist
            SELECT ilsoh.*,  (ilsoh.unit_cost * ilsoh.stock_on_hand) stock_value
            FROM item_loc_soh ilsoh;
            --print how many rows were inserted
            DBMS_OUTPUT.PUT_LINE('No. of rows inserted are ...: ' || sql%rowcount);
            --COMMIT;
        --since the input value is not ALL neither all, check if it is a number, loc id has to be a number
        ELSIF REGEXP_LIKE(i_loc, '^[[:digit:]]+$') THEN
            --copying data from item_loc_soh into item_loc_soh_hist including (ilsoh.unit_cost * ilsoh.stock_on_hand) as stockvalue for a given loc id 
            INSERT INTO item_loc_soh_hist
            SELECT ilsoh.*, (ilsoh.unit_cost * ilsoh.stock_on_hand) stock_value 
            FROM item_loc_soh ilsoh
            WHERE LOC = i_loc;
            --print how many rows were inserted
            DBMS_OUTPUT.PUT_LINE('No. of rows inserted are ...: ' || sql%rowcount);
            --COMMIT;
        --raise an error to explain the user how to run the code    
        ELSE
              RAISE e_invalid_number;
        END IF;
        EXCEPTION
            WHEN e_invalid_number THEN
            --print error explanation to user
            DBMS_OUTPUT.PUT_LINE ('ERROR: You need to send as parameter value either ALL or all to run the copy for all locations or send as parameter value a loc id to copy data for a specific location only (this need to ne a number)');    
            WHEN OTHERS THEN  
            --printing any exception to inform user
            DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.format_error_stack);
    END i_item_loc_soh_hist;
END insert_item_loc_soh_hist;
/