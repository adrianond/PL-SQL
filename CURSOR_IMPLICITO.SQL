--SELECT *FROM DEPARTMENTS;
    
--CURSOR IMPLICITO
SET SERVEROUTPUT ON
DECLARE
      
BEGIN
    
    FOR I IN (SELECT DEPARTMENT_ID, DEPARTMENT_NAME
            FROM DEPARTMENTS 
            WHERE DEPARTMENT_NAME = 'Executive') LOOP
           
        if (I.DEPARTMENT_ID = 10) THEN
                DBMS_OUTPUT.PUT_LINE('Administration');
        elsif (I.DEPARTMENT_ID = 90) THEN 
                DBMS_OUTPUT.PUT_LINE('Executive');
        else
                DBMS_OUTPUT.PUT_LINE('other');
        end if;     
    END LOOP;
END;
    