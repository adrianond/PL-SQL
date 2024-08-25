SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 60; 
SELECT * FROM departments;

--CURSOR EXPLICITO
SET SERVEROUTPUT ON
DECLARE
   CURSOR CDATA_EMPLOYEES IS
      SELECT EMPLOYEE_ID AS ID, FIRST_NAME AS NOME, LAST_NAME AS SOBRENOME, 
        JOB_ID AS IDENTIFICADOR_FUNCAO, SALARY AS SALARIO, HIRE_DATE AS DATA_CONTRATACAO
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID IN (10)
        ORDER BY HIRE_DATE DESC;

V_SALARIO EMPLOYEES.SALARY%TYPE;

BEGIN
       
  FOR V_EMPLOYEES IN CDATA_EMPLOYEES LOOP
          
       DBMS_OUTPUT.PUT_LINE('Employee Fetched ID :' || V_EMPLOYEES.ID);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched NOME :' || V_EMPLOYEES.NOME);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched SOBRENOME :' || V_EMPLOYEES.SOBRENOME);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched IDENTIFICADOR FUNÇÃO :' || V_EMPLOYEES.IDENTIFICADOR_FUNCAO);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched SALÁRIO :' || V_EMPLOYEES.SALARIO);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched DATA CONTRATAÇÃO :' || V_EMPLOYEES.DATA_CONTRATACAO);
       
       IF (V_EMPLOYEES.ID = 200) THEN
         DBMS_OUTPUT.PUT_LINE('COLABORADOR: ' || V_EMPLOYEES.NOME || ' ' || V_EMPLOYEES.SOBRENOME || ' RECEBERÁ AUMENTO DE 10 PORCENTO');
         DBMS_OUTPUT.PUT_LINE('Employee Fetched SALÁRIO :' || V_EMPLOYEES.SALARIO);
         UPDATE EMPLOYEES 
         SET SALARY = V_EMPLOYEES.SALARIO * (1 + 10 / 100)
         WHERE EMPLOYEE_ID = V_EMPLOYEES.ID;
         COMMIT;
       END IF;
       
       SELECT SALARY INTO V_SALARIO FROM EMPLOYEES WHERE EMPLOYEE_ID = 200;
       DBMS_OUTPUT.PUT_LINE('SALÁRIO ATUALIZADO:' || V_SALARIO);
       
  END LOOP;          
END;

--------------------------------------------------------------------------------------------------------------------------------------------

-- Cursor Explícito com SELECT FOR UPDATE - USE COM CUIDADO, NÃO APLICAVEL PARA CONSULTAS COM MUITOS DADOS
-- POR CAUSA DO LOCK DE TRANSAÇÃO DO SELECT FOR UPDATE
DECLARE
  CURSOR  employees_cursor (pjob_id VARCHAR2) IS
  SELECT  *
  FROM  employees
  WHERE job_id = pjob_id
  FOR UPDATE;
BEGIN
  FOR employees_record IN  employees_cursor ('IT_PROG')
  LOOP
  DBMS_OUTPUT.PUT_LINE('Nome: ' || employees_record.first_name || ' - ' || 'SALÁRIO:' || employees_record.salary);
      UPDATE employees
      SET salary = salary * (1 + 10 / 100)
      WHERE CURRENT OF employees_cursor;
  END LOOP;
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------');
  FOR employees_record IN  employees_cursor ('IT_PROG')
  LOOP
   DBMS_OUTPUT.PUT_LINE('Nome: ' || employees_record.first_name || ' - ' || 'SALÁRIO ATUALIZADO:' || employees_record.salary);
  END LOOP;
END;

---------------------------------------------------------------------------------------------------------------------------------------------

DECLARE
   CURSOR CDATA_EMPLOYEES(P_DEPARTMENT_ID NUMBER) IS
      SELECT EMPLOYEE_ID AS ID, FIRST_NAME AS NOME, LAST_NAME AS SOBRENOME, 
        JOB_ID AS IDENTIFICADOR_FUNCAO, SALARY AS SALARIO, HIRE_DATE AS DATA_CONTRATACAO
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = P_DEPARTMENT_ID
        ORDER BY HIRE_DATE DESC;

V_SALARIO EMPLOYEES.SALARY%TYPE;
V_DEPARTMENT_ID DEPARTMENTS.DEPARTMENT_ID%TYPE;

BEGIN
       SELECT DEPARTMENT_ID INTO V_DEPARTMENT_ID
        FROM DEPARTMENTS
        WHERE DEPARTMENT_NAME = 'Administration';
        
  FOR V_EMPLOYEES IN CDATA_EMPLOYEES(V_DEPARTMENT_ID) LOOP
          
       DBMS_OUTPUT.PUT_LINE('Employee Fetched ID :' || V_EMPLOYEES.ID);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched NOME :' || V_EMPLOYEES.NOME);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched SOBRENOME :' || V_EMPLOYEES.SOBRENOME);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched IDENTIFICADOR FUNÇÃO :' || V_EMPLOYEES.IDENTIFICADOR_FUNCAO);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched SALÁRIO :' || V_EMPLOYEES.SALARIO);
       DBMS_OUTPUT.PUT_LINE('Employee Fetched DATA CONTRATAÇÃO :' || V_EMPLOYEES.DATA_CONTRATACAO);
       
       IF (V_EMPLOYEES.ID = 200) THEN
         DBMS_OUTPUT.PUT_LINE('COLABORADOR: ' || V_EMPLOYEES.NOME || ' ' || V_EMPLOYEES.SOBRENOME || ' RECEBERÁ AUMENTO DE 10 PORCENTO');
         DBMS_OUTPUT.PUT_LINE('Employee Fetched SALÁRIO :' || V_EMPLOYEES.SALARIO);
         UPDATE EMPLOYEES 
         SET SALARY = V_EMPLOYEES.SALARIO * (1 + 10 / 100)
         WHERE EMPLOYEE_ID = V_EMPLOYEES.ID;
         COMMIT;
       END IF;
       
       SELECT SALARY INTO V_SALARIO FROM EMPLOYEES WHERE EMPLOYEE_ID = 200;
       DBMS_OUTPUT.PUT_LINE('SALÁRIO ATUALIZADO:' || V_SALARIO);
       
  END LOOP;          
END;


---------------------------------------------------------------------------------------------------------------------------------------------

DECLARE
   CURSOR CDATA_EMPLOYEES(P_DEPARTMENT_ID NUMBER) IS
      SELECT FIRST_NAME AS NOME
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 100000
        --WHERE DEPARTMENT_ID = P_DEPARTMENT_ID 
        ORDER BY HIRE_DATE DESC;

V_NOME EMPLOYEES.FIRST_NAME%TYPE;

BEGIN

  FOR I IN (SELECT DEPARTMENT_ID AS ID
        FROM DEPARTMENTS
        WHERE DEPARTMENT_NAME = 'Administration') LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || I.ID);
        
        OPEN CDATA_EMPLOYEES(I.ID);
        FETCH CDATA_EMPLOYEES INTO V_NOME;
        
        IF CDATA_EMPLOYEES%NOTFOUND THEN
         DBMS_OUTPUT.PUT_LINE('DATA NOT FOUND');
         CLOSE CDATA_EMPLOYEES;
        EXIT;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('V_NOME :' || V_NOME);
        CLOSE CDATA_EMPLOYEES;
        
  END LOOP;   
END;
---------------------------------------------------------------------------------------------------------------------------------------

DECLARE
   CURSOR CDATA_EMPLOYEES(P_DEPARTMENT_ID NUMBER) IS
      SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_ID
        FROM EMPLOYEES e, DEPARTMENTS d
        --WHERE DEPARTMENT_ID = 100000
        WHERE e.DEPARTMENT_ID = P_DEPARTMENT_ID 
        AND e.DEPARTMENT_ID = d.DEPARTMENT_ID
        ORDER BY e.HIRE_DATE DESC;

EMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
FIRST_NAME EMPLOYEES.FIRST_NAME%TYPE;
LAST_NAME EMPLOYEES.LAST_NAME%TYPE;
DEPARTMENT_ID DEPARTMENTS.DEPARTMENT_ID%type;

BEGIN

  FOR I IN (SELECT DEPARTMENT_ID AS ID
        FROM DEPARTMENTS
        WHERE DEPARTMENT_NAME in('Administration', 'Marketing', 'IT')) LOOP
        
        DBMS_OUTPUT.PUT_LINE('ID PESQUISA: ' || I.ID);
        
        OPEN CDATA_EMPLOYEES(I.ID);
        LOOP
          FETCH CDATA_EMPLOYEES INTO EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID;
        
          EXIT WHEN CDATA_EMPLOYEES%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || EMPLOYEE_ID || ' - ' || 
        'NOME: ' || FIRST_NAME || ' - ' ||
        'SOBRENOME: ' || LAST_NAME || ' - ' ||
        'ID DEPARTAMENTO: ' || DEPARTMENT_ID);
        END LOOP;
        CLOSE CDATA_EMPLOYEES;     
  END LOOP;  
     DBMS_OUTPUT.PUT_LINE('PROCESSSO FINALIZADO');
END;
--------------------------------------------------------------------------------------------------------------------------------------
DECLARE

    CURSOR employee_cursor IS
        SELECT * FROM EMPLOYEES;
    
    employee_record Employees%ROWTYPE;

BEGIN
    OPEN employee_cursor;
    
    LOOP
        FETCH employee_cursor INTO employee_record;
        
        EXIT WHEN employee_cursor%NOTFOUND;
        
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || employee_record.EMPLOYEE_ID || 
                            ', Name: ' || employee_record.FIRST_NAME ||
                             ', SobreNome: ' || employee_record.LAST_NAME ||
                            ', e mail: ' || employee_record.EMAIL ||
                            ', Telefone: ' || employee_record.PHONE_NUMBER ||
                            ', Data Contratacao: ' || employee_record.HIRE_DATE ||
                            ', Identificador funcao: ' || employee_record.JOB_ID ||
                            ', Salario: ' || employee_record.SALARY ||
                            ', Comissao: ' || employee_record.COMMISSION_PCT ||
                            ', Identificador gerente: ' || employee_record.MANAGER_ID ||
                            ', Identificador departamento: ' || employee_record.DEPARTMENT_ID);
    END LOOP;
    CLOSE employee_cursor;
END;
---------------------------------------------------------------------------------------------------------------

DECLARE

    CURSOR data_cursor IS
        SELECT EMPL.EMPLOYEE_ID, EMPL.FIRST_NAME, EMPL.LAST_NAME, EMPL.DEPARTMENT_ID, EMPL.SALARY,
        DEPT.DEPARTMENT_ID AS IDENTIFICADOR_DEPARTAMENTO, DEPT.DEPARTMENT_NAME
        FROM EMPLOYEES EMPL, DEPARTMENTS DEPT
        WHERE EMPL.DEPARTMENT_ID = DEPT.DEPARTMENT_ID
        AND DEPT.DEPARTMENT_ID in (10, 40, 60, 70);
    
    data_record data_cursor%ROWTYPE;

BEGIN
    OPEN data_cursor;
    
    LOOP
        FETCH data_cursor INTO data_record;
        
        EXIT WHEN data_cursor%NOTFOUND;
        
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || data_record.EMPLOYEE_ID || 
                            ', Name: ' || data_record.FIRST_NAME ||
                             ', SobreNome: ' || data_record.LAST_NAME ||
                            ', Identificador departamento tabela employee: ' || data_record.DEPARTMENT_ID ||
                            ', Salario: ' || LTRIM(TO_CHAR(data_record.salary, 'L99G999G999D99')) ||
                            ', Identificador departamento tabela departments: ' ||data_record.IDENTIFICADOR_DEPARTAMENTO ||
                            ', Nome departamento: ' || data_record.DEPARTMENT_NAME);
    END LOOP;
    CLOSE data_cursor;
END;
