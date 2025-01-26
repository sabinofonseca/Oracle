--1. Primary key definition and any other constraint or index suggestion

-- add primary key on table item
ALTER TABLE item ADD PRIMARY KEY (item);
/

--add primary key on table loc
ALTER TABLE  loc ADD PRIMARY KEY (loc);
/

--add primary key on table item_loc_soh. Column dept appears first on the composite PK because it's mentioned on the exercise to take in consideration that dept is  one of the attributes that users more use to search on this table.
--This ensures that queries filtering by dept will efficiently use the composite PK
--This is also the solution to avoid the TABLE FULL SCAN of the exercise 9
ALTER TABLE item_loc_soh
ADD CONSTRAINT pk_item_loc_soh PRIMARY KEY (dept, loc, item);
/


--add foreign key referencing item table
ALTER TABLE item_loc_soh
ADD CONSTRAINT fk_item_loc_soh_item FOREIGN KEY (item)
REFERENCES item(item);
/

--add foreign key referencing item table
ALTER TABLE item_loc_soh
ADD CONSTRAINT fk_item_loc_soh_loc FOREIGN KEY (loc)
REFERENCES loc(loc);
/

--Create unique index on table item to ensure that the combination of item,dept has unique values accross all rows in the table
CREATE UNIQUE INDEX idx_item_item_dept ON item(item, dept);
/


---Creating item_loc_soh_hist table based on item_loc_soh adding the necessary field stockvalue which is a calculation of (ilsoh.unit_cost * ilsoh.stock_on_hand) from table item_loc_soh without records
CREATE TABLE item_loc_soh_hist as
SELECT ilsoh.*,  (ilsoh.unit_cost * ilsoh.stock_on_hand) stock_value
FROM item_loc_soh ilsoh
where 1=0;
/