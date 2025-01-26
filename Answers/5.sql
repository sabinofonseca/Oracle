--5. Create a new table that associates user to existing dept(s)
CREATE TABLE DEPT_USER (
    dept NUMBER(4,0) NOT NULL,
    userid VARCHAR2(200) NOT NULL,
    --PK to avoid duplicates
    CONSTRAINT PK_DEPT PRIMARY KEY (dept, userid)
);
/