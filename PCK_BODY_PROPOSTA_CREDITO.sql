create or replace PACKAGE BODY PCK_PROPOSTA_CREDITO IS

PROCEDURE PRC_CRIA_PROPOSTA(p_proposta in propostaType) IS

BEGIN
 DBMS_OUTPUT.PUT_LINE('CRIA PROPOSTA CREDITO');

 DBMS_OUTPUT.PUT_LINE('produto: ' || p_proposta.produto);
 DBMS_OUTPUT.PUT_LINE('cliente: ' || p_proposta.cliente.nome);

 FOR i IN 1 .. p_proposta.cliente.telefones.COUNT LOOP
   DBMS_OUTPUT.PUT_LINE('telefone: ' || p_proposta.cliente.telefones(i).numero);
 END LOOP;
 
END PRC_CRIA_PROPOSTA;

END PCK_PROPOSTA_CREDITO;