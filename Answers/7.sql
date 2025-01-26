--7. Create a data filter mechanism that can be used at screen level to filter out the data that user can see accordingly to dept association (created previously)


-- this function returns the APP User that is quering the data
CREATE OR REPLACE FUNCTION get_current_user
RETURN VARCHAR2 IS
BEGIN
    RETURN  V('APP_USER');
END;
/

--based on the APP User quering the data the below view returns all the deps associated with the user
CREATE OR REPLACE VIEW "V_USER_DEPT_FILTER" ("DEPT") AS 
SELECT d.dept
FROM dept_user d
WHERE d.userid = get_current_user();
