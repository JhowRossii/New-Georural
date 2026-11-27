<!DOCTYPE html>
<html lang="pt-BR" data-tema="light">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Entrar &middot; GeoRural</title>
  <link rel="icon" href="${url.resourcesPath}/img/LogoSquadTech.png">
  <link rel="stylesheet" href="${url.resourcesPath}/css/variaveis.css">
  <link rel="stylesheet" href="${url.resourcesPath}/css/login.css">
</head>
<body class="pagina-login">
  <main class="login-page">
    <section class="login-card" aria-label="Acesso ao GeoRural">
      <aside class="presentation">
        <div class="brand">
          <img src="${url.resourcesPath}/img/LogoSquadTech.png" alt="Logo GeoRural">
          <span>Geo<strong>Rural</strong></span>
        </div>

        <div class="presentation-content">
          <h1>
            Uma visão mais completa
            <span>do seu território.</span>
          </h1>

          <p class="presentation-description">
            Reúna informações, acompanhe processos e explore dados
            geoespaciais em um só lugar.
          </p>

          <ul class="feature-list">
            <li>
              <span class="feature-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                  <ellipse cx="12" cy="5" rx="8" ry="3" />
                  <path d="M4 5v7c0 4 16 4 16 0V5" />
                  <path d="M4 12v7c0 4 16 4 16 0v-7" />
                </svg>
              </span>
              <div>
                <h2>Gestão de dados</h2>
                <p>Organize arquivos e acompanhe as etapas de processamento.</p>
              </div>
            </li>

            <li>
              <span class="feature-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                  <path d="m3 6 6-3 6 3 6-3v15l-6 3-6-3-6 3Z" />
                  <path d="M9 3v15M15 6v15" />
                </svg>
              </span>
              <div>
                <h2>Análise territorial</h2>
                <p>Explore imóveis, municípios e indicadores geoespaciais.</p>
              </div>
            </li>

            <li>
              <span class="feature-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                  <circle cx="6" cy="5" r="2" />
                  <circle cx="18" cy="12" r="2" />
                  <circle cx="6" cy="19" r="2" />
                  <path d="M6 7v10M8 5h3a7 7 0 0 1 7 5" />
                  <path d="M8 19h3a7 7 0 0 0 7-5" />
                </svg>
              </span>
              <div>
                <h2>Rastreabilidade</h2>
                <p>Consulte a origem e a trajetória dos dados na plataforma.</p>
              </div>
            </li>
          </ul>
        </div>

        <p class="presentation-footer">
          Dados conectados para decisões mais informadas.
        </p>
      </aside>

      <section class="access" aria-labelledby="login-title">
        <header class="login-header">
          <span class="access-label" id="login-title">ACESSO À PLATAFORMA</span>
          <p>Informe suas credenciais.</p>
        </header>

        <#if message?has_content>
          <p class="login-message" role="alert">${kcSanitize(message.summary)?no_esc}</p>
        </#if>

        <form class="login-form" action="${url.loginAction}" method="post">
          <div class="field">
            <label for="username">E-mail</label>
            <input id="username" name="username" type="text"
                   value="${(login.username!'')}"
                   placeholder="seu@email.com"
                   autocomplete="username" autofocus required>
          </div>

          <div class="field">
            <label for="password">Senha</label>
            <div class="password-field">
              <input id="password" name="password" type="password"
                     placeholder="Digite sua senha"
                     autocomplete="current-password" required>
              <button class="password-toggle" type="button" id="verSenha"
                      aria-label="Mostrar senha" aria-pressed="false">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.5" stroke-linecap="round" aria-hidden="true">
                  <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z" />
                  <circle cx="12" cy="12" r="3" />
                  <path id="riscoSenha" d="m3 3 18 18" style="display:none" />
                </svg>
              </button>
            </div>
          </div>

          <div class="form-options">
            <#if realm.rememberMe>
              <label class="remember">
                <input name="rememberMe" type="checkbox"
                       <#if login.rememberMe??>checked</#if>>
                Lembrar de mim
              </label>
            <#else>
              <span></span>
            </#if>

            <#if realm.resetPasswordAllowed>
              <a class="text-button" href="${url.loginResetCredentialsUrl}">
                Esqueci minha senha
              </a>
            </#if>
          </div>

          <button class="submit-button" type="submit">Entrar na plataforma</button>
        </form>
      </section>
    </section>

    <footer class="login-footer">
      <span>&copy; 2026 GeoRural</span>
    </footer>
  </main>

  <script>
    // Mostrar e ocultar a senha. No front isto era reatividade do Vue; aqui a
    // pagina e renderizada no servidor, entao sao estas dez linhas.
    (function () {
      var botao = document.getElementById('verSenha');
      var campo = document.getElementById('password');
      var risco = document.getElementById('riscoSenha');
      botao.addEventListener('click', function () {
        var mostrando = campo.type === 'text';
        campo.type = mostrando ? 'password' : 'text';
        risco.style.display = mostrando ? 'none' : '';
        botao.setAttribute('aria-pressed', String(!mostrando));
        botao.setAttribute('aria-label', mostrando ? 'Mostrar senha' : 'Ocultar senha');
      });
    })();
  </script>
</body>
</html>