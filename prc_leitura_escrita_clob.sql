CREATE OR REPLACE PROCEDURE PRC_INSERE_RESUME
(presume_id IN job_resumes.resume_id%TYPE, presume IN VARCHAR2) 
IS
   vresume_localizador    CLOB;
   vTamanho_Texto         NUMBER;
   vDeslocamento          NUMBER;
BEGIN
   SELECT resume
   INTO   vresume_localizador
   FROM   job_resumes
   WHERE  resume_id = presume_id
   FOR UPDATE;

   vDeslocamento := 1;
   vTamanho_Texto := LENGTH(presume);
   DBMS_LOB.WRITE(vresume_localizador,vTamanho_Texto,vDeslocamento,presume);
   COMMIT;
END;

--exec PRC_INSERE_RESUME(1,'DBA - Database administrator , Porto Alegre, RS, Brasil');

CREATE OR REPLACE PROCEDURE PRC_EXIBE_RESUME
(presume_id IN job_resumes.resume_id%TYPE) 
IS
   vresume_localizador    CLOB;
   vTamanho_Texto         NUMBER;
   vDeslocamento          NUMBER;
   vTexto                 VARCHAR2(32767);
   vLoop                  NUMBER;
   vQuantidade            NUMBER := 1;
   vExibe                 VARCHAR2(240);
BEGIN
   SELECT resume
   INTO   vresume_localizador
   FROM   job_resumes
   WHERE  resume_id = presume_id
   FOR UPDATE;

   vDeslocamento := 1;
   vTamanho_Texto := DBMS_LOB.GETLENGTH(vresume_localizador);
   DBMS_LOB.READ(vresume_localizador,vTamanho_Texto,vDeslocamento,vTexto);
   vLoop := TRUNC((LENGTH(vTexto))/240)+1;
   FOR i IN 1 .. vLoop LOOP
     vExibe := SUBSTR(vTexto,vQuantidade,240);
     vQuantidade := vQuantidade + 240;
     DBMS_OUTPUT.PUT_LINE(vExibe);
   END LOOP;
   COMMIT; -- liberar lock do select
END;

--exec PRC_EXIBE_RESUME(1);