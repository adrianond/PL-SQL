-- Flashback Drop


CREATE TABLE employees_copia 
AS
SELECT *
FROM employees;

SELECT *
FROM   user_objects
WHERE  object_name = 'EMPLOYEES_COPIA';

SELECT *
FROM employees_copia;

-- Removendo um objeto

DROP TABLE employees_copia;

SELECT *
FROM   user_objects
WHERE  object_name = 'EMPLOYEES_COPIA';

SELECT *
FROM employees_copia;

-- Consultando a Lixeira

SELECT *
FROM   user_recyclebin
WHERE  original_name = 'EMPLOYEES_COPIA';

-- Confimando que o objeto foi removido

SELECT *
FROM   user_objects
WHERE object_name = 'EMPLOYEES_COPIA';

-- Restaurando o Objeto a partir da Lixeira

FLASHBACK TABLE EMPLOYEES_COPIA TO BEFORE DROP;

-- Confimando que o objeto foi restaurado

SELECT *
FROM user_objects
WHERE object_name = 'EMPLOYEES_COPIA';

SELECT *
FROM employees_copia;

SELECT *
FROM   user_recyclebin
WHERE  original_name = 'EMPLOYEES_COPIA';
