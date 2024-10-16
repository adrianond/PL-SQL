-- Armazenando imagens em uma coluna BFILE


CREATE TABLE job_Profiles2
(resume_id   NUMBER,
 first_name  VARCHAR2(200),
 last_name   VARCHAR2(200),
 profile_picture  BFILE); -- BFILE, um ponteiro q aponta para um diretório de contém a imagem
 
SELECT * FROM job_Profiles2; 

DECLARE
  vNomeArquivo   VARCHAR2(100) := 'CursoOracleCompleto.jpeg';
  vDiretorio     VARCHAR2(100) := 'IMAGENS';
  vArquivoOrigem   BFILE;  
BEGIN

  vArquivoOrigem := BFILENAME(vDiretorio,vNomeArquivo);
  
  IF DBMS_LOB.FILEEXISTS(vArquivoOrigem) = 1 THEN
     INSERT INTO job_profiles2
     VALUES (1, 'Oracle', 'Man', vArquivoOrigem);
     COMMIT;
  END IF;
   
EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
END;

