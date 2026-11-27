import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import autorizado from './directives/autorizado'
import { autenticacaoService } from './services/autenticacaoService'

let temaInicial = 'light'

try {
  const temaSalvo = localStorage.getItem('georural-tema')
  if (temaSalvo === 'light' || temaSalvo === 'dark') {
    temaInicial = temaSalvo
  }
} catch {
  // Mantem o tema claro se o armazenamento estiver bloqueado.
}

document.documentElement.dataset.tema = temaInicial

// A aplicacao so monta depois do Keycloak resolver a sessao. Com
// login-required, quem nao esta autenticado nem chega aqui: o navegador ja foi
// redirecionado para a tela de login. O finally monta mesmo em caso de falha,
// para que o App.vue possa explicar o que houve em vez de mostrar tela branca.
autenticacaoService.iniciar().finally(() => {
  const app = createApp(App)
  app.directive('autorizado', autorizado)
  app.use(createPinia())
  app.use(router)
  app.mount('#app')
})