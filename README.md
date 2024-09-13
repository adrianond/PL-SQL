# PL-SQL

-- Consultando objetos tipo Procedure e Function do seu Usuário

DESC USER_OBJECTS

SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  object_type IN ('PROCEDURE', 'FUNCTION');

SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   all_objects
WHERE  object_type IN ('PROCEDURE', 'FUNCTION');

-- Consultando objetos Inválidos do schema do seu usuário 

DESC USER_OBJECTS

SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  status = 'INVALID';

-- Consultando o Código Fonte de Procedures e Funções  do seu usuário

DESC user_source

SELECT line, text
FROM   user_source
WHERE  name = 'PRC_INSERE_EMPREGADO' AND
       type = 'PROCEDURE'
ORDER BY line;

SELECT line, text
FROM   user_source
WHERE  name = 'FNC_CONSULTA_SALARIO_EMPREGADO' AND
       type = 'FUNCTION'
ORDER BY line;

-- Consultando a lista de parâmetros de Procedures e Funções 

DESC PRC_INSERE_EMPREGADO

DESC FNC_CONSULTA_SALARIO_EMPREGADO

-- Consultando Erros de Compilação

-- Forçando um erro de compilação

CREATE OR REPLACE FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
  (pemployee_id   IN NUMBER)
   RETURN NUMBER
IS 
  vsalary  employees.salary%TYPE;
BEGIN
  SELECT salary
  INTO   vsalary
  FROM   employees
  WHERE employee_id = pemployee_id
  RETURN (vsalary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR(-20001, 'Empregado inexistente');
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

-- Consultando Erros de Compilação - Comando SHOW ERRORS

SHOW ERRORS PROCEDURE FNC_CONSULTA_SALARIO_EMPREGADO

-- Consultando Erros de Compilação - Visão USER_ERRORS

DESC user_errors

COLUMN position FORMAT a4
COLUMN text FORMAT a60
SELECT line||'/'||position position, text
FROM   user_errors
WHERE  name = 'FNC_CONSULTA_SALARIO_EMPREGADO'
ORDER BY line;
***********************************************************************************

-- Gerenciando Dependências de Objetos

-- Consultando Dependencias Diretas dos objetos do seu schema utilizando a visão USER_DEPENDENCIES 

DESC user_dependencies

SELECT *
FROM   user_dependencies
WHERE  referenced_name = 'EMPLOYEES' AND
       referenced_type = 'TABLE';
       
-- Consultando Dependencias Diretas e Indiretas dos objetos do seu schema utilizando a visão USER_DEPENDENCIES 

SELECT      *
FROM        user_dependencies
START WITH  referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  name = referenced_name AND
                  type = referenced_type;
                  

-- Consultando Dependencias Diretas e Indiretas dos objetos de todos schemas utilizando a visão DBA_DEPENDENCIES        

-- Conecte-se como SYS

DESC DBA_DEPENDENCIES

SELECT      *
FROM        dba_dependencies
START WITH  referenced_owner = 'HR' AND
            referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  owner = referenced_owner AND
                  name =  referenced_name   AND
                  type =  referenced_type;
                  

*********************************************************************************************************

Gerenciando Dependências de Objetos
Utilizando as Visões DEPTREE e IDEPTREE


-- Executando o script UTLDTREE

@C:\app\Emilio\product\18.0.0\dbhomeXE\rdbms\admin\utldtree.sql  

-- Obs.: Substitua o caminho de pastas pelo sua instalação

-- Executando a procedure DEPTREE_FILL

exec DEPTREE_FILL('TABLE','HR','EMPLOYEES')

-- Utilizando as Visões DEPTREE

DESC deptree

SELECT   *
FROM     deptree
ORDER by seq#


-- Utilizando as Visões IDEPTREE

desc ideptree

SELECT *
FROM ideptree;
**************************************************************************************************************

-- Debugando Procedures e Functions

-- Edite a function FNC_CONSULTA_SALARIO_EMPREGADO

-- Compilar a function FNC_CONSULTA_SALARIO_EMPREGADO para debug

-- Debugando Procedures e Functions

-- Tente debugar uma procedure ou funtion, ocorrerá o seguinte erro

Conectando ao banco de dados hr_XEPDB1.
Executando PL/SQL: CALL DBMS_DEBUG_JDWP.CONNECT_TCP( '127.0.0.1', '52091' )
ORA-01031: privilégios insuficientes
ORA-06512: em "SYS.DBMS_DEBUG_JDWP", line 68
ORA-06512: em line 1
Essa sessão exige os privilégios de usuário DEBUG CONNECT SESSION e DEBUG ANY PROCEDURE.
Processo encerrado.
Desconectando do banco de dados hr_XEPDB1.

-- Passando privilégios necessários para o usuário hr poder debugar procedures e functions

/*
  Requisitos necessários para executar o PL/SQL Debuger:

  . Efetuar o grant dos privilégios DEBUG CONNECT SESSION e DEBUG ANY PROCEDURE para o usuário que vai debugar a procedure ou function
  . O usuário deve ser o owner ou possuir o privilégio de  EXECUTE da procedure ou function a que deseja debugar
  . A procedure ou function deve ser compilada  para debug (Compiled for Debug)
	
*/

-- Conectado como SYS

grant DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE to hr;

-- Tente debugar novamente, ocorrerá o seguinte erro

Conectando ao banco de dados hr_XEPDB1.
Executando PL/SQL: CALL DBMS_DEBUG_JDWP.CONNECT_TCP( '127.0.0.1', '52100' )
ORA-24247: acesso à rede negado pela ACL (access control list)
ORA-06512: em "SYS.DBMS_DEBUG_JDWP", line 68
ORA-06512: em line 1
Processo encerrado.
Desconectando do banco de dados hr_XEPDB1.


-- Conectado como SYS

Starting with Oracle 12c, if you want to debug PL/SQL stored procedures in the database through a Java 
Debug Wire Protocol (JDWP)-based debugger, such as SQL Developer or JDeveloper, then you must be granted 
the jdwp ACL privilege to connect your database session to the debugger at a particular host.

This is one way you can configure network access for JDWP operations:

	
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
 (
 host => '127.0.0.1',
 lower_port => null,
 upper_port => null,
 ace => xs$ace_type(privilege_list => xs$name_list('jdwp'),
 principal_name => 'hr',
 principal_type => xs_acl.ptype_db)
 );
END;


-- Tente debugar novamente, agora deve funcionar ok!




