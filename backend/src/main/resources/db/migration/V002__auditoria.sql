-- =====================================================================
-- V002 - Auditoria
--
-- O desafio exige auditoria de uploads, regras, execucoes, publicacoes,
-- downloads e responsaveis. A gravacao entra agora, junto com a primeira
-- operacao que altera dado -- nao depois, porque auditoria e a unica
-- coisa do sistema que nao se recupera: linha nao gravada esta perdida.
-- =====================================================================


-- Um registro por acao relevante. aud_entidade_afetada e aud_registro_id
-- dizem sobre o que a acao foi, sem exigir uma chave estrangeira para
-- cada tabela auditada.
--
-- aud_usuario_nome guarda o nome no momento da acao: se o usuario for
-- renomeado ou desativado depois, o historico continua legivel.
CREATE TABLE AUDITORIA (
    aud_id               NUMBER        GENERATED ALWAYS AS IDENTITY,
    usu_id               NUMBER        NOT NULL,
    aud_usuario_nome     VARCHAR2(120) NOT NULL,
    aud_operacao         VARCHAR2(20)  NOT NULL,
    aud_entidade_afetada VARCHAR2(30)  NOT NULL,
    aud_registro_id      NUMBER,
    aud_dados_antigos    CLOB,
    aud_dados_novos      CLOB,
    aud_origem           VARCHAR2(10)  DEFAULT 'PORTAL' NOT NULL,
    aud_ip_origem        VARCHAR2(45),
    aud_data_hora        TIMESTAMP     DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,
    CONSTRAINT pk_auditoria PRIMARY KEY (aud_id),
    CONSTRAINT fk_aud_usuario FOREIGN KEY (usu_id) REFERENCES USUARIO (usu_id),
    CONSTRAINT ck_aud_operacao CHECK (aud_operacao IN
        ('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','DOWNLOAD','EXPORT','API_ACCESS')),
    CONSTRAINT ck_aud_origem CHECK (aud_origem IN ('PORTAL','API','AIRFLOW')),
    CONSTRAINT ck_aud_antigos_json CHECK (aud_dados_antigos IS NULL OR aud_dados_antigos IS JSON),
    CONSTRAINT ck_aud_novos_json   CHECK (aud_dados_novos  IS NULL OR aud_dados_novos  IS JSON)
);

-- A tela de historico filtra por periodo, por usuario e por entidade.
CREATE INDEX ix_auditoria_data     ON AUDITORIA (aud_data_hora);
CREATE INDEX ix_auditoria_usuario  ON AUDITORIA (usu_id);
CREATE INDEX ix_auditoria_entidade ON AUDITORIA (aud_entidade_afetada, aud_registro_id);

COMMENT ON TABLE  AUDITORIA IS 'Trilha de auditoria: quem fez o que, quando, de onde e sobre qual registro.';
COMMENT ON COLUMN AUDITORIA.usu_id IS 'Responsavel pela acao. Nunca nulo: acao sem responsavel nao e auditavel.';
COMMENT ON COLUMN AUDITORIA.aud_usuario_nome IS 'Nome do responsavel no momento da acao, preservado contra renomeacao futura.';
COMMENT ON COLUMN AUDITORIA.aud_entidade_afetada IS 'Nome da tabela ou do recurso afetado.';
COMMENT ON COLUMN AUDITORIA.aud_registro_id IS 'Identificador do registro afetado, quando existe um.';
COMMENT ON COLUMN AUDITORIA.aud_dados_antigos IS 'Retrato JSON de antes da alteracao.';
COMMENT ON COLUMN AUDITORIA.aud_dados_novos IS 'Retrato JSON de depois da alteracao.';
COMMENT ON COLUMN AUDITORIA.aud_origem IS 'Por onde a acao entrou: PORTAL, API ou AIRFLOW.';
COMMENT ON COLUMN AUDITORIA.aud_data_hora IS 'Instante da acao, em UTC.';
