-- Package Package UTL_FILE

-- Criar o diretorio 'C:\ARQUIVOS' no Windows

-- Conectar como SYS

--CREATE OR REPLACE DIRECTORY ARQUIVOS AS 'C:\ARQUIVOS';

--GRANT READ, WRITE ON DIRECTORY ARQUIVOS TO hr;

-- Gravando um arquivo Texto

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  vfile  UTL_FILE.FILE_TYPE;
  CURSOR employees_c IS
  SELECT employee_id, first_name, last_name, job_id, salary
  FROM   employees;

BEGIN
  vfile := UTL_FILE.FOPEN('ARQUIVOS', 'employees.txt','w',32767); -- w (write - escrita de arquivo); 32767 - tamanho do buffer
  FOR  employees_r IN employees_c LOOP
    --imprime/gera o arquivo
    UTL_FILE.PUT_LINE(vfile, employees_r.employee_id || ';' || 
                             employees_r.first_name || ';' || 
                             employees_r.last_name || ';' ||
                             employees_r.job_id || ';' || 
                             employees_r.salary);
  END LOOP;
  UTL_FILE.FCLOSE(vfile);
  DBMS_OUTPUT.PUT_LINE('Arquivo Texto employees.txt gerado com sucesso');
EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Diret�rio Inv�lido');
  WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Opera��o invalida no arquivo');
  WHEN UTL_FILE.WRITE_ERROR THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro de grava��o no arquivo');     
  WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Modo de acesso inv�lido');
  WHEN OTHERS THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);
END;

-- Lendo um arquivo Texto

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  vfile  UTL_FILE.FILE_TYPE;
  vregistro  VARCHAR2(400); -- tamanho de cada registro
BEGIN
  vfile := UTL_FILE.FOPEN('ARQUIVOS', 'employees.txt','r',32767); -- r (read - leitura de arquivo); 32767 - tamanho do buffer
  LOOP  
    -- LE O REGISTRO DO ARQUIVO
    UTL_FILE.GET_LINE(vfile, vregistro);
    DBMS_OUTPUT.PUT_LINE(vregistro);
  END LOOP;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Arquivo Texto employees.txt lido com sucesso');
  WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Diret�rio Inv�lido');
  WHEN OTHERS THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);
END;
