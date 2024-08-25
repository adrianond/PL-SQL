--
-- Seção 10 - Tipos Compostos - Variável Tipo PL/SQL Record
--
-- Aula 1 - Variável Tipo PL/SQL Record
--

-- Criando um PL/SQL Record 
--SELECT * FROM EMPLOYEES;
SET SERVEROUTPUT ON
DECLARE
TYPE  employee_record_type IS RECORD 
          (employee_id   employees.employee_id%type,
           first_name    employees.first_name%type,
           last_name     employees.last_name%type,
           email          employees.email%type,
           department_name  departments.department_name%type,
           phone_number  employees.phone_number%type);

employee_record  employee_record_type; 

BEGIN
SELECT  e.employee_id, e.first_name, e.last_name, e.email, d.department_name, e.phone_number
INTO    employee_record
FROM    employees e, departments d
WHERE   e.employee_id = 100
AND     e.department_id = d.department_id; 
DBMS_OUTPUT.PUT_LINE(employee_record.employee_id || ' - ' || 
                     employee_record.first_name || ' - ' || 
                     employee_record.last_name || ' - ' || 
                     employee_record.department_name || ' - ' ||
                     employee_record.phone_number);
END;
-------------------------------------------------------------------------------------------------------------------
-- ROWTYPE
DECLARE
employee_record  employees%rowtype; 

BEGIN
SELECT  *
INTO    employee_record
FROM    employees
WHERE   employee_id = 100;
DBMS_OUTPUT.PUT_LINE(employee_record.employee_id || ' - ' || 
                     employee_record.first_name || ' - ' || 
                     employee_record.last_name || ' - ' || 
                     employee_record.phone_number);
END;
