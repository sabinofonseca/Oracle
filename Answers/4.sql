--4. Created a view on top of item_loc_soh without showing unit cost, its not need to be shown at screen level      
CREATE OR REPLACE VIEW ITEM_LOC_STOCK AS
SELECT  item, 
        loc, 
        dept, 
        stock_on_hand
FROM ITEM_LOC_SOH;
/
