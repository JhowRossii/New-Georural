import { possuiPermissao, permissaoRota } from './permissaoService'

// O keycloak-js sobe com onLoad: 'login-required', entao quando a aplicacao
// monta a pessoa ja esta autenticada. Resta a guarda conferir o perfil.
export function criarGuardaAutenticacao(autenticacao) {
  return (to) => {
    if (!autenticacao.estado.autenticado) {
      // Sem cadastro ou sessao caida: o App.vue mostra o bloqueio.
      return true
    }

    if (!possuiPermissao(autenticacao.estado.perfil, permissaoRota(to.name))) {
      return { name: 'SemAcesso', replace: true }
    }

    return true
  }
}