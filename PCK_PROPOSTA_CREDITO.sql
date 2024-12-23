create or replace PACKAGE PCK_PROPOSTA_CREDITO IS

PROCEDURE PRC_CRIA_PROPOSTA(P_PROPOSTA IN PROPOSTA_CREDITO_TYPE);
PROCEDURE PRC_POPULA_ENDERECO(P_ENDERECO IN ENDERECO_PROPOSTA_CREDITO_TYPE);
PROCEDURE PRC_POPULA_CLIENTE(P_CLIENTE IN CLIENTE_PROPOSTA_CREDITO_TYPE);
PROCEDURE PRC_POPULA_TELEFONE(P_TELEFONES IN TELEFONE_PROPOSTA_CREDITO_TYPE_TABLE, ID_CLIENTE IN NUMBER);
PROCEDURE PRC_POPULA_PROPOSTA(P_PROPOSTA IN PROPOSTA_CREDITO_TYPE);

END PCK_PROPOSTA_CREDITO;