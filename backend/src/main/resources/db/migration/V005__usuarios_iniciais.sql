-- =====================================================================
-- V005 - Usuarios iniciais
--
-- Uma linha por pessoa criada no realm georural do Keycloak.
--
-- usu_keycloak_id guarda o claim "sub" do token: e por ele que o filtro
-- encontra a linha a cada requisicao. Sem a linha, a pessoa autentica no
-- Keycloak mas nao entra no GeoRural - que e o comportamento correto
-- para quem nao tem cadastro, e por isso o cadastro nao pode faltar para
-- quem tem.
--
-- Os UUIDs foram gerados pelo Keycloak e viajam no JSON do realm, que e
-- versionado junto: os dois lados sobem iguais em qualquer maquina.
--
-- per_id e resolvido por consulta a PERFIL em vez de numero fixo. A
-- coluna e IDENTITY, entao o valor depende da ordem de insercao da V004
-- e nao e garantido entre ambientes.
--
-- usu_nome e usu_email nascem aqui so para satisfazer o NOT NULL. O
-- filtro de autenticacao os atualiza a partir do token a cada login, o
-- que tambem e quem preenche usu_ultimo_login.
-- =====================================================================

INSERT INTO USUARIO (per_id, usu_keycloak_id, usu_nome, usu_email)
SELECT p.per_id, '3f33b117-92c8-4b2b-8b7b-ba1c6a8ad4d4', 'Admin GeoRural', 'admin@georural.invalid'
  FROM PERFIL p WHERE p.per_funcao = 'ADMIN';

INSERT INTO USUARIO (per_id, usu_keycloak_id, usu_nome, usu_email)
SELECT p.per_id, 'bb2da378-c239-4e8a-881e-0cd02a352264', 'Gestor GeoRural', 'gestor@georural.invalid'
  FROM PERFIL p WHERE p.per_funcao = 'GESTOR';

INSERT INTO USUARIO (per_id, usu_keycloak_id, usu_nome, usu_email)
SELECT p.per_id, '36dab3a5-f666-4d4c-924c-11be21e65a20', 'Operador GeoRural', 'operador@georural.invalid'
  FROM PERFIL p WHERE p.per_funcao = 'OPERADOR';

INSERT INTO USUARIO (per_id, usu_keycloak_id, usu_nome, usu_email)
SELECT p.per_id, '4a8710bd-fa24-42ae-9a08-91f90bf2fe21', 'Analista GeoRural', 'analista@georural.invalid'
  FROM PERFIL p WHERE p.per_funcao = 'ANALISTA';

INSERT INTO USUARIO (per_id, usu_keycloak_id, usu_nome, usu_email)
SELECT p.per_id, '6cf2816f-28b8-4227-90cf-e50821a3d1ff', 'Auditor GeoRural', 'auditor@georural.invalid'
  FROM PERFIL p WHERE p.per_funcao = 'AUDITOR';