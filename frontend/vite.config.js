import { fileURLToPath, URL } from 'node:url'

import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, fileURLToPath(new URL('.', import.meta.url)), '')

  // So o /api passa por proxy. O Keycloak nao: com o fluxo de
  // redirecionamento o navegador navega ate ele de verdade, e o endereco
  // precisa ser o mesmo que o servidor declara como emissor do token.
  const proxy = {
    '/api': {
      target: env.BACKEND_URL || 'http://localhost:8080',
      changeOrigin: true,
    },
  }

  return {
    server: { port: 5173, strictPort: true, proxy },
    preview: { proxy },
    plugins: [vue(), vueDevTools()],
    resolve: {
      alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) },
    },
  }
})