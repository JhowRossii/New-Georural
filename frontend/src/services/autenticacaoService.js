import Keycloak from 'keycloak-js'
import axios from 'axios'
import { reactive, readonly } from 'vue'

// Autenticacao por redirecionamento (Authorization Code + PKCE). A senha nunca
// passa por aqui: quem a recebe e o Keycloak, na pagina dele. Renovacao de
// token, expiracao e logout sao da biblioteca - nao sao codigo nosso.
//
// O perfil NAO vem do token. Vem de GET /api/v1/usuario-atual, que le a tabela
// USUARIO. Decisao D4 do marco zero: o token prova quem e, o banco diz o que
// pode. Com o papel nos dois lugares existiria um invariante que alguem
// quebraria, e a quebra apareceria como 401 sem explicacao.

const keycloak = new Keycloak({
  url: import.meta.env.VITE_KEYCLOAK_URL,
  realm: import.meta.env.VITE_KEYCLOAK_REALM,
  clientId: import.meta.env.VITE_KEYCLOAK_CLIENT_ID,
})

const baseApi = (import.meta.env.VITE_API_URL || '').replace(/\/$/, '')

const estado = reactive({
  pronto: false,
  autenticado: false,
  id: null,
  nome: '',
  email: '',
  perfil: '',
  mensagem: '',
  aviso: '',
  codigoAviso: '',
})

async function iniciar() {
  try {
    await keycloak.init({
      onLoad: 'login-required',
      pkceMethod: 'S256',
      // Desligado de proposito: o iframe de verificacao depende de cookie de
      // terceiros, que os navegadores vem bloqueando. A renovacao por
      // updateToken cobre o mesmo.
      checkLoginIframe: false,
    })
  } catch (erro) {
    estado.pronto = true
    estado.mensagem = 'Nao foi possivel falar com o servico de login.'
    return
  }

  await carregarIdentidade()
  estado.pronto = true
}

// Confirma que a conta existe do lado do GeoRural. Estar autenticado no
// Keycloak nao basta: sem linha em USUARIO a pessoa nao entra.
async function carregarIdentidade() {
  try {
    const { data } = await axios.get(`${baseApi}/api/v1/usuario-atual`, {
      headers: { Authorization: `Bearer ${keycloak.token}` },
      timeout: 15000,
    })
    estado.id = data.id
    estado.nome = data.nome
    estado.email = data.email
    estado.perfil = data.perfil
    estado.autenticado = true
    estado.mensagem = ''
  } catch (erro) {
    estado.autenticado = false
    const corpo = erro?.response?.data
    estado.mensagem =
      corpo?.mensagem || 'Nao foi possivel confirmar seu cadastro no GeoRural.'
    estado.codigoAviso = corpo?.correlacao || ''
  }
}

// Renova quando faltam menos de 30 segundos. Chamado antes de cada requisicao.
async function obterToken() {
  try {
    await keycloak.updateToken(30)
    return keycloak.token
  } catch {
    estado.autenticado = false
    estado.mensagem = 'Sua sessao expirou. Entre novamente.'
    throw Object.assign(new Error(estado.mensagem), { code: 'AUTH_REQUIRED' })
  }
}

function sair() {
  return keycloak.logout({ redirectUri: globalThis.location.origin })
}

function encerrar(mensagem = '') {
  estado.autenticado = false
  estado.mensagem = mensagem
}

export const autenticacaoService = {
  estado: readonly(estado),
  iniciar,
  obterToken,
  sair,
  encerrar,
  avisarSemPermissao(codigo = '') {
    estado.aviso = 'Voce nao possui permissao para realizar esta operacao.'
    estado.codigoAviso = codigo
  },
  fecharAviso() {
    estado.aviso = ''
    estado.codigoAviso = ''
  },
}