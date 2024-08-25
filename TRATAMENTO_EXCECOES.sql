-- Tratamento de Exceções Pré-definidas Oracle

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  vFirst_name   employees.first_name%TYPE;
  vLast_name    employees.last_name%TYPE;
  vEmployee_id  employees.employee_id%TYPE := 1103;
BEGIN
  SELECT first_name, last_name
  INTO   vfirst_name, vlast_name
  FROM   employees
  WHERE  employee_id = vEmployee_id;

  DBMS_OUTPUT.PUT_LINE('Empregado: ' || vfirst_name || ' ' || vlast_name);
 
EXCEPTION
  WHEN NO_DATA_FOUND 
  THEN
     DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND EXCEPTION');
     RAISE_APPLICATION_ERROR(-20001, 'Empregado não encontrado, id = ' || TO_CHAR(vEmployee_id));
  WHEN OTHERS 
  THEN
     DBMS_OUTPUT.PUT_LINE('OTHERS EXCEPTION');
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);

END;
-----------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 60;
DECLARE
   CURSOR EMPLOYEE_DATA_CURSOR IS
        SELECT * FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 600;
        
    EMPLOYEE_DATA  EMPLOYEE_DATA_CURSOR%ROWTYPE;
    EMPLOYEE_DATA_EXECEPTION EXCEPTION;

BEGIN

    -- FOR I IN EMPLOYEE_DATA_CURSOR LOOP
     OPEN EMPLOYEE_DATA_CURSOR;
     LOOP
        FETCH EMPLOYEE_DATA_CURSOR INTO EMPLOYEE_DATA;
        EXIT WHEN EMPLOYEE_DATA_CURSOR%NOTFOUND;
     
        DBMS_OUTPUT.PUT_LINE('COLABORADOR: ' || EMPLOYEE_DATA.FIRST_NAME || ' ' || EMPLOYEE_DATA.LAST_NAME 
        || ' - ' || 'SALARIO: ' || EMPLOYEE_DATA.SALARY);
        IF EMPLOYEE_DATA.SALARY <= 8503.000 THEN 
            RAISE EMPLOYEE_DATA_EXECEPTION;
        END IF; 
        
     END LOOP;
     
     DBMS_OUTPUT.PUT_LINE('EXIT WHEN EMPLOYEE_DATA_CURSOR%NOTFOUND');   
     CLOSE EMPLOYEE_DATA_CURSOR;
     
     EXCEPTION 
     WHEN EMPLOYEE_DATA_EXECEPTION THEN
      DBMS_OUTPUT.PUT_LINE('O salario do colaborador : ' || EMPLOYEE_DATA.FIRST_NAME || ' ' || EMPLOYEE_DATA.LAST_NAME || ' ' || 'esta fora da faixa salarial');
     WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
        
END;

-------------------------------------------------------------------------------------------------------------------------------------------
-- PRAGMA EXCEPTION INIT
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;
DECLARE
   vemployee_id    employees.employee_id%TYPE := 300;
   vfirst_name     employees.first_name%TYPE := 'Robert';
   vlast_name      employees.last_name%TYPE := 'Ford';
   vjob_id         employees.job_id%TYPE := 'XX_YYYY'; -- JOB INEXISTENTE
   vphone_number   employees.phone_number%TYPE := '650.511.9844';
   vemail          employees.email%TYPE := 'RFORD';
   efk_inexistente EXCEPTION;
   PRAGMA EXCEPTION_INIT(efk_inexistente, -2291); -- codigo oracle para violação constraint fk (job_id não existe na tabela JOBS)

BEGIN
   INSERT INTO employees (employee_id, first_name, last_name, phone_number, email, hire_date,job_id)
   VALUES (vemployee_id, vfirst_name, vlast_name, vphone_number, vemail, sysdate, vjob_id);
EXCEPTION
   WHEN  efk_inexistente THEN
    DBMS_OUTPUT.PUT_LINE('efk_inexistente');
    RAISE_APPLICATION_ERROR(-20003, 'Job inexistente!');
   WHEN OTHERS THEN
   DBMS_OUTPUT.PUT_LINE('WHEN OTHERS');
   RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;


