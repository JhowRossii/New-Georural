// Capacidades por perfil. Isto governa APENAS o que a interface mostra - quais
// itens de menu e quais botoes. Quem decide o que pode de verdade e o back, em
// SecurityConfig. Esconder botao nao e seguranca.
//
// A tabela perfisRequisicao do projeto anterior foi removida: ela repetia a
// matriz do back no cliente, e matriz em dois lugares e matriz que diverge.

export const PERFIS = Object.freeze([
  'ADMIN',
  'GESTOR',
  'OPERADOR',
  'ANALISTA',
  'AUDITOR',
])

const ROTULOS = Object.freeze({
  ADMIN: 'Administrador',
  GESTOR: 'Gestor',
  OPERADOR: 'Operador de dados',
  ANALISTA: 'Analista',
  AUDITOR: 'Auditor',
})

const capacidades = {
  consultar: PERFIS,
  operar: ['ADMIN', 'GESTOR', 'OPERADOR'],
  gerir: ['ADMIN', 'GESTOR'],
  qualidade: ['ADMIN', 'GESTOR', 'OPERADOR', 'AUDITOR'],
  administrar: ['ADMIN'],
}

export function rotuloPerfil(perfil) {
  return ROTULOS[perfil] || perfil || ''
}

export function possuiPermissao(perfil, capacidade = 'consultar') {
  // ADMIN alcanca tudo, sem excecao e sem caso especial espalhado pelo codigo.
  if (perfil === 'ADMIN') return true
  return capacidades[capacidade]?.includes(perfil) ?? false
}

export function permissaoRota(nome) {
  if (nome === 'GestaoUsuarios' || nome === 'MonitoramentoPlataforma') {
    return 'administrar'
  }

  if (['QuarentenaDados', 'AuditoriaDados', 'AuditoriaLinhagem'].includes(nome)) {
    return 'qualidade'
  }

  if (nome === 'Ingestao' || nome === 'ProcessarDados') {
    return 'operar'
  }

  if (nome === 'RegraNovaVersao' || nome === 'Regras') {
    return 'gerir'
  }

  return 'consultar'
}

export function caminhoRetornoSeguro(valor) {
  if (
    typeof valor !== 'string' ||
    !valor.startsWith('/') ||
    valor.startsWith('//') ||
    /[\\\r\n]/.test(valor)
  ) {
    return '/imoveis'
  }

  const url = new URL(valor, 'https://georural.local')

  if (
    url.origin !== 'https://georural.local' ||
    ['/', '/sem-acesso'].includes(url.pathname)
  ) {
    return '/imoveis'
  }

  return url.pathname + url.search + url.hash
}