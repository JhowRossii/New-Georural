-- =====================================================================
-- V006 - Conta de servico do Airflow
--
-- Decisao D4 do marco zero: conta de maquina e usuario de primeira
-- classe. Tem linha, perfil e status, igual a pessoa. Sem esta linha
-- nenhuma acao do pipeline teria responsavel, e a AUDITORIA exige
-- usu_id NOT NULL - ou seja, nada do que o Airflow fizesse poderia ser
-- auditado.
--
-- Perfil OPERADOR, nao ADMIN: as DAGs recebem, validam, tratam e
-- calculam, que e o trabalho do operador. Publicar versao e do gestor,
-- porque a US#15 exige que uma pessoa confira a qualidade e decida.
--
-- O UUID e o do usuario que o Keycloak cria sozinho para o service
-- account do client georural-airflow.
--
-- O token de client_credentials nao traz os claims name e email, entao
-- o filtro de autenticacao nao sobrescreve estes valores: eles sao a
-- identidade desta conta nos registros de auditoria.
-- =====================================================================

INSERT INTO USUARIO (per_id, usu_keycloak_id, usu_nome, usu_email)
SELECT p.per_id, 'b3881cdb-8edf-44f0-9e97-73110a8f6de9', 'Agendador Airflow', 'airflow@georural.invalid'
  FROM PERFIL p WHERE p.per_funcao = 'OPERADOR';