<script setup>
import { RouterLink } from 'vue-router'
import BarraNavegacao from '../components/BarraNavegacao.vue'
import { autenticacaoService } from '../services/autenticacaoService'
import { rotuloPerfil } from '../services/permissaoService'

const estado = autenticacaoService.estado
</script>

<template>
  <BarraNavegacao />
  <main class="pagina" role="main">
    <h1>Acesso nao permitido</h1>
    <p>
      Seu perfil ({{ rotuloPerfil(estado.perfil) }}) nao tem permissao para
      esta pagina.
    </p>
    <!-- So aparece quando a negacao veio do back. Bloqueio feito aqui no
         navegador nao chega a fazer requisicao, entao nao tem codigo. -->
    <p v-if="estado.codigoAviso" class="codigo">
      Codigo: {{ estado.codigoAviso }}
    </p>
    <RouterLink :to="{ name: 'Imoveis' }">Voltar para imoveis</RouterLink>
  </main>
</template>

<style scoped>
.pagina {
  padding: 40px 24px;
  color: var(--cor-texto);
}
h1 {
  font-family: var(--fonte-titulo);
}
p {
  margin: 16px 0;
}
.codigo {
  font-family: var(--fonte-mono);
  color: var(--cor-texto-secundario);
}
a {
  color: var(--cor-roxo);
}
</style>