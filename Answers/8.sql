--8. Create a pipeline function to be used in the location list of values (drop down)

-- creating oracle type loc_obj (record)
CREATE TYPE loc_obj AS OBJECT (
    loc           NUMBER(10,0),
    loc_desc      VARCHAR2(25)
);
/

-- create table of loc_obj records
CREATE TYPE loc_tbl IS TABLE OF loc_obj;
/

--creating function to get loc id and loc desc to be shown on the app dropdown
CREATE OR REPLACE FUNCTION get_locations
  RETURN loc_tbl PIPELINED
IS
BEGIN
    FOR l IN (SELECT loc,
                     loc_desc
              FROM loc
              ORDER BY loc) 
              LOOP
                PIPE ROW(loc_obj(l.loc, l.loc_desc));
              END LOOP;
    RETURN;
END get_locations;
/