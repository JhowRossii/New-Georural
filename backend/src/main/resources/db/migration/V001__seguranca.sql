-- =====================================================================
-- V001 - Seguranca: perfis e usuarios
--
-- Marco 1 do plano de reconstrucao. Entram so as tabelas que o codigo
-- deste marco escreve e le; o resto do esquema vem nas migracoes
-- seguintes, uma por dominio.
--
-- Todo instante e gravado em UTC, pela decisao 1 do marco zero. O banco
-- esta em UTC, a JVM tambem, e a conversao para America/Sao_Paulo
-- acontece num lugar so: a exibicao no front.
-- =====================================================================


-- Os cinco perfis do desafio. per_funcao precisa bater EXATAMENTE com os
-- papeis do realm no Keycloak: o filtro de autenticacao compara os dois.
CREATE TABLE PERFIL (
    per_id        NUMBER        GENERATED ALWAYS AS IDENTITY,
    per_funcao    VARCHAR2(20)  NOT NULL,
    per_nome      VARCHAR2(60)  NOT NULL,
    per_descricao VARCHAR2(240),
    CONSTRAINT pk_perfil PRIMARY KEY (per_id),
    CONSTRAINT uk_perfil_funcao UNIQUE (per_funcao),
    CONSTRAINT ck_perfil_funcao CHECK (per_funcao IN
        ('ADMIN','GESTOR','OPERADOR','ANALISTA','AUDITOR'))
);

COMMENT ON TABLE  PERFIL IS 'Perfis de acesso. O codigo da funcao espelha o papel no Keycloak.';
COMMENT ON COLUMN PERFIL.per_funcao IS 'Codigo tecnico, igual ao realm role do Keycloak.';
COMMENT ON COLUMN PERFIL.per_nome IS 'Nome exibido nas telas.';


-- Um usuario do portal. A identidade e autenticada pelo Keycloak; aqui
-- fica o vinculo com o perfil e o estado da conta.
--
-- usu_keycloak_id guarda o "sub" do token e e por ele que o filtro
-- encontra a linha a cada requisicao. Contas de servico (robo do Airflow,
-- por exemplo) sao usuarios como qualquer outro: nenhuma acao do sistema
-- fica sem responsavel identificado.
CREATE TABLE USUARIO (
    usu_id            NUMBER        GENERATED ALWAYS AS IDENTITY,
    per_id            NUMBER        NOT NULL,
    usu_keycloak_id   VARCHAR2(36)  NOT NULL,
    usu_nome          VARCHAR2(120) NOT NULL,
    usu_email         VARCHAR2(255) NOT NULL,
    usu_status        CHAR(1)       DEFAULT 'S' NOT NULL,
    usu_ultimo_login  TIMESTAMP,
    usu_data_cadastro TIMESTAMP     DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (usu_id),
    CONSTRAINT uk_usuario_email UNIQUE (usu_email),
    CONSTRAINT uk_usuario_keycloak UNIQUE (usu_keycloak_id),
    CONSTRAINT fk_usu_perfil FOREIGN KEY (per_id) REFERENCES PERFIL (per_id),
    CONSTRAINT ck_usuario_status CHECK (usu_status IN ('S','N'))
);

-- Oracle nao indexa chave estrangeira sozinho, e sem indice um UPDATE no
-- pai bloqueia a tabela filha inteira.
CREATE INDEX ix_usuario_perfil ON USUARIO (per_id);

COMMENT ON TABLE  USUARIO IS 'Usuarios do portal e contas de servico, vinculados a um perfil.';
COMMENT ON COLUMN USUARIO.usu_keycloak_id IS 'Claim sub do token do Keycloak; chave de ligacao com a identidade.';
COMMENT ON COLUMN USUARIO.usu_status IS 'S = ativo, N = desativado. Conta desativada tem acesso negado.';
COMMENT ON COLUMN USUARIO.usu_ultimo_login IS 'Instante em UTC do ultimo login bem-sucedido.';
