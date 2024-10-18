

DECLARE 
  v_proposta propostaType;
  v_cliente clienteType;
  v_telefones telefoneTypeTable;
BEGIN
  
  v_telefones:= telefoneTypeTable(
   telefoneType(null,'1','999999999','11'),
   telefoneType(null,'2','99999999','11')
  );
  
  v_cliente:= clienteType (
   null,
   'ADRIANO DANTAS',
  '99999999999',
  '2755519X',
   null,
   null, 
   v_telefones
  );
  
  v_proposta:= propostaType(
    null,
    'EMPRESTIMO',
    500,
    'ANALISE',
    v_cliente
  );
  pck_proposta_credito.prc_cria_proposta(v_proposta);
END;