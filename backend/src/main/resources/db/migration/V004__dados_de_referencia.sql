-- =====================================================================
-- V004 - Dados de referencia
--
-- Conteudo fixo que o sistema precisa para funcionar: os cinco perfis do
-- desafio e as dez camadas de entrada previstas.
--
-- Nao ha usuarios aqui de proposito. Usuario nasce vinculado a uma
-- identidade do Keycloak pelo claim sub, e inventar UUID em migracao
-- criaria linha que nenhum token encontra. Eles entram quando o realm
-- deste projeto for definido.
-- =====================================================================


-- Os cinco perfis. O codigo tem que ser igual ao papel do realm.
INSERT INTO PERFIL (per_funcao, per_nome, per_descricao) VALUES
    ('ADMIN', 'Administrador', 'Acesso total, incluindo gestao de usuarios e monitoramento da plataforma.');
INSERT INTO PERFIL (per_funcao, per_nome, per_descricao) VALUES
    ('GESTOR', 'Gestor', 'Avalia a qualidade e decide a publicacao de uma versao.');
INSERT INTO PERFIL (per_funcao, per_nome, per_descricao) VALUES
    ('OPERADOR', 'Operador de dados', 'Cadastra fontes e conjuntos, envia arquivos e executa o pipeline.');
INSERT INTO PERFIL (per_funcao, per_nome, per_descricao) VALUES
    ('ANALISTA', 'Analista', 'Consulta indicadores, mapas, tabelas e graficos.');
INSERT INTO PERFIL (per_funcao, per_nome, per_descricao) VALUES
    ('AUDITOR', 'Auditor', 'Consulta linhagem, qualidade e historico de acoes.');


-- As dez camadas de entrada, com os formatos de origem e os indicadores
-- que dependem de cada uma. tip_esquema fica nulo: os campos esperados
-- sao definidos junto com a validacao, que e de outro marco.
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('IMOVEL_RURAL', 'Imovel rural (perimetro)', 'SHP,GPKG', 'TODOS');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('APP', 'APP declarada', 'SHP,GEOJSON', 'IAPP,ICV');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('RESERVA_LEGAL', 'Reserva Legal declarada', 'SHP,GEOJSON', 'IRL');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('VEGETACAO_NATIVA', 'Vegetacao nativa', 'TIF,SHP', 'ICV,IAPP');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('BIOMA', 'Limites de biomas', 'SHP', 'IRL');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('AREA_PROTEGIDA', 'Areas protegidas e territorios especiais', 'SHP', 'ISAP');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('EMBARGO', 'Embargos ambientais', 'SHP,CSV', 'IAE');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('DESMATAMENTO', 'Desmatamento', 'SHP,GEOJSON', 'IDESMAT');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('FOCO_CALOR', 'Focos de calor', 'CSV,SHP', 'IFC');
INSERT INTO TIPO_CONJUNTO (tip_codigo, tip_nome, tip_formatos, tip_indicadores) VALUES
    ('MUNICIPIO', 'Malha municipal', 'SHP', 'AGREGACAO');
