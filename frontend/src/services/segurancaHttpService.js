// Poe o token em cada requisicao e traduz as respostas de erro do back.
//
// Nao ha mais conferencia de permissao antes de enviar: quem decide e o back.
// O que havia aqui era uma copia da matriz, que divergiria dela no primeiro
// endpoint novo.
export function configurarSegurancaHttp(api, autenticacao) {
  api.interceptors.request.use(async (config) => {
    const base = new URL(
      config.baseURL || '/',
      globalThis.location?.origin || 'http://localhost',
    )
    const destino = new URL(config.url, base)

    // Trava para o token nunca sair para outra origem.
    if (destino.origin !== base.origin) {
      throw new Error('Destino de requisicao nao autorizado.')
    }

    const token = await autenticacao.obterToken()
    config.headers.set('Authorization', `Bearer ${token}`)
    return config
  })

  api.interceptors.response.use(
    (resposta) => resposta,
    (erro) => {
      // O back devolve o codigo de correlacao no corpo e no cabecalho. E com
      // ele que a pessoa acha a requisicao no log.
      const codigo =
        erro.response?.data?.correlacao ||
        erro.response?.headers?.['x-correlacao'] ||
        ''
      erro.codigoCorrelacao = codigo

      if (erro.response?.status === 401) {
        autenticacao.encerrar('Sua sessao expirou. Entre novamente.')
      }
      if (erro.response?.status === 403) {
        autenticacao.avisarSemPermissao(codigo)
      }
      return Promise.reject(erro)
    },
  )
}