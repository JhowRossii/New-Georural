import { createRouter, createWebHistory } from 'vue-router'

import { autenticacaoService } from '../services/autenticacaoService'
import { criarGuardaAutenticacao } from '../services/guardaAutenticacaoService'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),

  routes: [
    {
      // A tela de login agora e a do Keycloak, com o tema do GeoRural.
      // Quem chega na raiz ja esta autenticado: o keycloak-js redireciona
      // antes de a aplicacao montar.
      path: '/',
      redirect: { name: 'Imoveis' },
    },
    {
      path: '/operacao',
      name: 'PainelOperacao',
      component: () => import('../views/PaineldeOperacao.vue'),
    },
    {
      path: '/usuarios',
      name: 'GestaoUsuarios',
      component: () => import('../views/Usuarios.vue'),
    },
    {
      path: '/quarentena',
      name: 'QuarentenaDados',
      component: () => import('../views/QuarentenaDados.vue'),
    },
    {
      path: '/zona-tratada',
      name: 'ZonaTratadaDados',
      component: () => import('../views/ZonaTratadaDados.vue'),
    },
    {
      path: '/arquivos-recebidos',
      name: 'ArquivosRecebidos',
      component: () => import('../views/ArquivosRecebidos.vue'),
    },
    {
      path: '/arquivos-recebidos/:id',
      name: 'DetalheArquivoRecebido',
      component: () => import('../views/DetalheArquivoRecebido.vue'),
      props: true,
    },
    {
      path: '/cadastros',
      name: 'Cadastros',
      component: () => import('../views/Cadastros.vue'),
    },
    {
      path: '/ingestao',
      name: 'Ingestao',
      component: () => import('../views/Ingestao.vue'),
    },
    {
      path: '/processar',
      name: 'ProcessarDados',
      component: () => import('../views/ProcessarDados.vue'),
    },
    {
      path: '/qualidade',
      name: 'QualidadeDados',
      component: () => import('../views/QualidadeDados.vue'),
    },
    {
      path: '/indicadores',
      name: 'Indicadores',
      component: () => import('../views/Indicadores.vue'),
    },
    {
      path: '/mapa-indicadores/:car?',
      name: 'MapaIndicadores',
      component: () => import('../views/MapaIndicadores.vue'),
      props: true,
    },
    {
      path: '/comparar-versoes',
      name: 'CompararVersoes',
      component: () => import('../views/CompararVersoes.vue'),
    },
    {
      path: '/resultado/:car',
      redirect: (to) => ({
        name: 'MapaIndicadores',
        params: {
          car: to.params.car,
        },
        query: to.query,
        hash: to.hash,
      }),
    },
    {
      path: '/imoveis',
      name: 'Imoveis',
      component: () => import('../views/ListaImoveis.vue'),
    },
    {
      path: '/auditoria',
      name: 'AuditoriaDados',
      component: () => import('../views/AuditoriaDados.vue'),
    },
    {
      path: '/historico',
      name: 'AuditoriaLinhagem',
      component: () => import('../views/AuditoriaLinhagem.vue'),
    },
    {
      path: '/regras',
      name: 'Regras',
      component: () => import('../views/Regras.vue'),
      children: [
        {
          path: 'nova-versao',
          name: 'RegraNovaVersao',
          component: () => import('../components/ModalSalvarRegras.vue'),
        },
        {
          path: 'detalhe-versao',
          name: 'RegraDetalheVersao',
          component: () => import('../components/ModalDetalheVersao.vue'),
        },
        {
          path: 'comparar-versoes',
          name: 'RegraCompararVersoes',
          component: () => import('../components/ModalCompararVersoes.vue'),
        },
      ],
    },
    {
      path: '/municipios',
      name: 'ComparacaoMunicipios',
      component: () => import('../views/ComparacaoMunicipios.vue'),
    },
    {
      path: '/rastreabilidade',
      name: 'Rastreabilidade',
      component: () => import('../views/RastreabilidadeDados.vue'),
    },
    {
      path: '/api-consulta',
      name: 'DocumentacaoApi',
      component: () => import('@/views/DocumentacaoApi.vue'),
    },
    {
      path: '/monitoramento',
      name: 'MonitoramentoPlataforma',
      component: () => import('../views/MonitoramentoPlataforma.vue'),
    },
    {
      path: '/sem-acesso',
      name: 'SemAcesso',
      component: () => import('../views/SemAcesso.vue'),
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: {
        name: 'Imoveis',
      },
    },
  ],
})

router.beforeEach(
  criarGuardaAutenticacao(autenticacaoService),
)

export default router
