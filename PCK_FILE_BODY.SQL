create or replace PACKAGE BODY PCK_FILE AS

PROCEDURE PRC_GERA_ARQUIVO_ADESAO AS
  
V_FILE                 UTL_FILE.FILE_TYPE;
V_LINE                 VARCHAR2(1000);
V_NOME_ARQUIVO         VARCHAR2(31);
V_CARTAO_CNPJ          VARCHAR2(16):= '92228410000102';
V_TIPO_ACAO            NUMBER(1):= 1;
V_PRODUTO              NUMBER(4):= 7714;
V_DATA_ATUAL           VARCHAR(8);
V_DDD                  VARCHAR(3);
V_CELULAR              VARCHAR(11);
V_SEXO                 VARCHAR2(1):= 'F';


CURSOR C_DATA(P_PROPOSTA NUMBER) IS
     SELECT SUBSTR(CLI.NOME, 1, 50) AS NOME, 
     LPAD(CLI.CPF, 11, '0') AS CPF,
     TO_CHAR(CLI.DATA_NASCIMENTO, 'DDMMYYYY') AS DATA_NASCIMENTO,
     t.DDD,
     t.TELEFONE,
     cli_end.CEP,
     cli_end.ESTADO,
     SUBSTR(cli_end.CIDADE, 1,25) as CIDADE,
     SUBSTR(cli_end.BAIRRO, 1, 25) AS BAIRRO,
     SUBSTR(cli_end.COMPLEMENTO, 1, 10) AS COMPLEMENTO,
     SUBSTR(cli_end.LOGRADOURO, 1, 100) AS LOGRADOURO,
     cli_end.NUMERO,
     SUBSTR(cli_comp.EMAIL, 1, 50) AS EMAIL
     FROM PROPOSTA p, CLIENTE cli, CLIENTE_COMPLEMENTAR cli_comp, CLIENTE_TELEFONE t,CLIENTE_ENDERECO cli_end
     WHERE p.PROPOSTA = P_PROPOSTA
     AND cli.PROPOSTA = P_PROPOSTA
     AND t.PROPOSTA = P_PROPOSTA
     AND cli_comp.PROPOSTA = P_PROPOSTA;
     
C_DATA_RECORD C_DATA%ROWTYPE;


  BEGIN
  SELECT TO_CHAR(SYSDATE, 'DDMMYYYY') INTO V_DATA_ATUAL FROM DUAL;
     
     V_NOME_ARQUIVO := 'ADESAO' || '_' || V_PRODUTO || '_' || V_DATA_ATUAL || '_' || '100000' || '.CSV';
    
     -- Abrir o arquivo para escrita
     V_FILE := UTL_FILE.FOPEN('ARQUIVOS', V_NOME_ARQUIVO, 'W', 32767);
    
     -- Escrever cabeçalho do CSV
     V_LINE := 'TIPO DE ACAO;CARTAO OU CNPJ;PRODUTO;CPF;NOME COMPLETO;DATA DE NASCIMENTO;TELEFONE;SEXO;E-MAIL;CEP;ESTADO;CIDADE;BAIRRO;COMPLEMENTO;LOGRADOURO;NUMEROENDERECO;CN';
    
     UTL_FILE.PUT_LINE(V_FILE, V_LINE);
    
     FOR I IN(SELECT PROPOSTA 
          FROM HR.CONTROLE_PROGRAMA 
          WHERE ACEITE = 'S'
          AND ENVIADO_ADESAO IS NULL) LOOP
                
     OPEN C_DATA(I.PROPOSTA);
     FETCH C_DATA INTO C_DATA_RECORD;
   
   
     V_DDD := C_DATA_RECORD.DDD;
     IF LENGTH(V_DDD) > 2 THEN
       V_DDD := SUBSTR(V_DDD, 2, 3);
     END IF;
     V_CELULAR := V_DDD || C_DATA_RECORD.TELEFONE;
   
      
     -- Montar linha do CSV
     V_LINE := V_TIPO_ACAO || ';' || '''' || V_CARTAO_CNPJ || '''' || ';' || V_PRODUTO || ';' || '''' || C_DATA_RECORD.CPF || '''' || ';' || 
               C_DATA_RECORD.NOME || ';' || '''' || C_DATA_RECORD.DATA_NASCIMENTO || '''' || ';' || '''' || V_CELULAR || '''' || ';'|| 
               V_SEXO || ';' || C_DATA_RECORD.EMAIL || ';' || '''' || C_DATA_RECORD.CEP || '''' || ';' || C_DATA_RECORD.ESTADO || ';'|| 
               C_DATA_RECORD.CIDADE || ';' || C_DATA_RECORD.BAIRRO || ';' || C_DATA_RECORD.COMPLEMENTO || ';'|| 
               C_DATA_RECORD.LOGRADOURO || ';' || C_DATA_RECORD.NUMERO;
               
    
     -- Escrever a linha no arquivo
     UTL_FILE.PUT_LINE(V_FILE, V_LINE);
 
   
    CLOSE C_DATA;
   END LOOP;  
   -- Fechar o arquivo
  UTL_FILE.FCLOSE(V_FILE);
  DBMS_OUTPUT.PUT_LINE('Arquivo CSV gerado com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        -- Tratar erros e fechar o arquivo se necessário
        IF UTL_FILE.IS_OPEN(V_FILE) THEN
            UTL_FILE.FCLOSE(V_FILE);
        END IF;
        RAISE;
    
    
END PRC_GERA_ARQUIVO_ADESAO;
  
PROCEDURE PRC_GERA_ARQUIVO_EMPRREGADOS AS 
  
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
      DBMS_OUTPUT.PUT_LINE('Diretório Inválido');
  WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Operação invalida no arquivo');
  WHEN UTL_FILE.WRITE_ERROR THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro de gravação no arquivo');     
  WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Modo de acesso inválido');
  WHEN OTHERS THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);
  
END PRC_GERA_ARQUIVO_EMPRREGADOS;


PROCEDURE PRC_EXECUTA_LEITURA_ARQUIVO_EMPREGADOS AS

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
      DBMS_OUTPUT.PUT_LINE('Diretório Inválido');
  WHEN OTHERS THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);


END PRC_EXECUTA_LEITURA_ARQUIVO_EMPREGADOS;

END PCK_FILE;