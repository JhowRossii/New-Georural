-- =====================================================================
-- V003 - Catalogo: tipos de conjunto, fontes e conjuntos de dados
--
-- Atende ao requisito de catalogo do desafio: esquema, sistema de
-- referencia, cobertura, competencia e versao vigente.
--
-- A coluna da versao vigente NAO entra aqui. A tabela VERSAO so nasce na
-- migracao de versionamento, e coluna que aponta para tabela inexistente
-- e exatamente o defeito que o marco zero proibe -- no projeto anterior
-- havia coluna no esquema que nenhum codigo jamais escreveu. Ela entra
-- por ALTER TABLE junto com a VERSAO.
-- =====================================================================


-- As dez camadas de entrada previstas no desafio. O tipo define o que se
-- espera do arquivo: o esquema de campos, os formatos aceitos e quais
-- indicadores dependem dele.
CREATE TABLE TIPO_CONJUNTO (
    tip_id          NUMBER        GENERATED ALWAYS AS IDENTITY,
    tip_codigo      VARCHAR2(30)  NOT NULL,
    tip_nome        VARCHAR2(120) NOT NULL,
    tip_esquema     CLOB,
    tip_formatos    VARCHAR2(100),
    tip_indicadores VARCHAR2(60),
    CONSTRAINT pk_tipo_conjunto PRIMARY KEY (tip_id),
    CONSTRAINT uk_tipo_codigo UNIQUE (tip_codigo),
    CONSTRAINT ck_tipo_esquema_json CHECK (tip_esquema IS NULL OR tip_esquema IS JSON)
);

COMMENT ON TABLE  TIPO_CONJUNTO IS 'Catalogo das camadas de entrada previstas e do que se espera de cada uma.';
COMMENT ON COLUMN TIPO_CONJUNTO.tip_esquema IS 'Campos esperados do arquivo, em JSON. Base da validacao de esquema.';
COMMENT ON COLUMN TIPO_CONJUNTO.tip_formatos IS 'Formatos de origem aceitos, separados por virgula.';
COMMENT ON COLUMN TIPO_CONJUNTO.tip_indicadores IS 'Siglas dos indicadores que dependem desta camada.';


-- Quem produz o dado: IBAMA, INPE, IBGE, CAR e os demais orgaos.
CREATE TABLE FONTE_DO_DADO (
    fon_id            NUMBER        GENERATED ALWAYS AS IDENTITY,
    usu_id            NUMBER        NOT NULL,
    fon_nome          VARCHAR2(120) NOT NULL,
    fon_sigla         VARCHAR2(20),
    fon_esfera        VARCHAR2(20),
    fon_url           VARCHAR2(500),
    fon_status        CHAR(1)       DEFAULT 'S' NOT NULL,
    fon_data_cadastro TIMESTAMP     DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,
    CONSTRAINT pk_fonte PRIMARY KEY (fon_id),
    CONSTRAINT uk_fonte_nome UNIQUE (fon_nome),
    CONSTRAINT fk_fon_usuario FOREIGN KEY (usu_id) REFERENCES USUARIO (usu_id),
    CONSTRAINT ck_fonte_status CHECK (fon_status IN ('S','N')),
    CONSTRAINT ck_fonte_esfera CHECK (fon_esfera IN ('FEDERAL','ESTADUAL','MUNICIPAL','PRIVADA'))
);

CREATE INDEX ix_fonte_usuario ON FONTE_DO_DADO (usu_id);

COMMENT ON TABLE  FONTE_DO_DADO IS 'Orgao ou entidade que produz o dado.';
COMMENT ON COLUMN FONTE_DO_DADO.usu_id IS 'Quem cadastrou a fonte.';
COMMENT ON COLUMN FONTE_DO_DADO.fon_url IS 'Endereco oficial de publicacao do dado.';
COMMENT ON COLUMN FONTE_DO_DADO.fon_status IS 'S = ativa, N = desativada para novas ingestoes.';


-- Um conjunto e um par fonte + tipo: "embargos ambientais do IBAMA".
-- E o que se ingere, se versiona e se publica.
--
-- A unicidade por (fonte, tipo) e deliberada: duas entradas da mesma
-- camada vinda do mesmo orgao seriam o mesmo conjunto em competencias
-- diferentes, e competencia pertence a versao, nao ao conjunto.
CREATE TABLE CONJUNTO_DADOS (
    con_id            NUMBER        GENERATED ALWAYS AS IDENTITY,
    fon_id            NUMBER        NOT NULL,
    tip_id            NUMBER        NOT NULL,
    usu_id            NUMBER        NOT NULL,
    con_nome          VARCHAR2(160) NOT NULL,
    con_descricao     VARCHAR2(400),
    con_srs           NUMBER(6)     DEFAULT 4674 NOT NULL,
    con_cobertura     VARCHAR2(30),
    con_periodicidade VARCHAR2(20)  DEFAULT 'SOB_DEMANDA' NOT NULL,
    con_forma_entrada VARCHAR2(10)  DEFAULT 'UPLOAD' NOT NULL,
    con_api_endpoint  VARCHAR2(500),
    con_api_formato   VARCHAR2(20),
    con_situacao      VARCHAR2(15)  DEFAULT 'RASCUNHO' NOT NULL,
    con_data_cadastro TIMESTAMP     DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,
    CONSTRAINT pk_conjunto PRIMARY KEY (con_id),
    CONSTRAINT uk_conjunto_fonte_tipo UNIQUE (fon_id, tip_id),
    CONSTRAINT fk_con_fonte   FOREIGN KEY (fon_id) REFERENCES FONTE_DO_DADO (fon_id),
    CONSTRAINT fk_con_tipo    FOREIGN KEY (tip_id) REFERENCES TIPO_CONJUNTO (tip_id),
    CONSTRAINT fk_con_usuario FOREIGN KEY (usu_id) REFERENCES USUARIO (usu_id),
    CONSTRAINT ck_con_situacao CHECK (con_situacao IN
        ('RASCUNHO','EM_VALIDACAO','PUBLICADO','ARQUIVADO')),
    CONSTRAINT ck_con_entrada CHECK (con_forma_entrada IN ('UPLOAD','API','AMBOS')),
    CONSTRAINT ck_con_periodicidade CHECK (con_periodicidade IN
        ('DIARIA','SEMANAL','MENSAL','TRIMESTRAL','ANUAL','SOB_DEMANDA','UNICA'))
);

CREATE INDEX ix_conjunto_fonte   ON CONJUNTO_DADOS (fon_id);
CREATE INDEX ix_conjunto_tipo    ON CONJUNTO_DADOS (tip_id);
CREATE INDEX ix_conjunto_usuario ON CONJUNTO_DADOS (usu_id);

COMMENT ON TABLE  CONJUNTO_DADOS IS 'Conjunto ingerivel: uma camada vinda de uma fonte. Unidade de versionamento e publicacao.';
COMMENT ON COLUMN CONJUNTO_DADOS.usu_id IS 'Quem cadastrou o conjunto; responde por ele.';
COMMENT ON COLUMN CONJUNTO_DADOS.con_srs IS 'Sistema de referencia declarado da origem. 4674 = SIRGAS 2000.';
COMMENT ON COLUMN CONJUNTO_DADOS.con_cobertura IS 'Abrangencia territorial da origem: NACIONAL, ESTADUAL, MUNICIPAL.';
COMMENT ON COLUMN CONJUNTO_DADOS.con_periodicidade IS 'Cadencia esperada de atualizacao; define qual DAG de varredura o processa.';
COMMENT ON COLUMN CONJUNTO_DADOS.con_forma_entrada IS 'Como o dado chega: UPLOAD, API ou AMBOS.';
COMMENT ON COLUMN CONJUNTO_DADOS.con_situacao IS 'Estado do conjunto no catalogo, independente da versao dos dados.';
