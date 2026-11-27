<script setup>
import { RouterView } from 'vue-router'
import { autenticacaoService } from './services/autenticacaoService'
import ToastMensagem from './components/ToastMensagem.vue'

const estado = autenticacaoService.estado
</script>

<template>
  <!-- Autenticado no Keycloak mas sem cadastro em USUARIO, ou sessao caida.
       Sem este bloco a pessoa veria uma tela vazia sem saber por que. -->
  <main v-if="estado.pronto && !estado.autenticado" class="bloqueio">
    <h1>Acesso nao liberado</h1>
    <p>{{ estado.mensagem }}</p>
    <p v-if="estado.codigoAviso" class="bloqueio-codigo">
      Codigo: {{ estado.codigoAviso }}
    </p>
    <button type="button" @click="autenticacaoService.sair()">Sair</button>
  </main>

  <template v-else>
    <RouterView />
    <ToastMensagem
      v-if="estado.aviso"
      :mensagem="estado.aviso"
      tipo="erro"
      :duracao="0"
      @fechar="autenticacaoService.fecharAviso"
    />
  </template>
</template>

<style scoped>
.bloqueio {
  display: grid;
  gap: 16px;
  justify-items: start;
  max-width: 560px;
  margin: 80px auto;
  padding: 32px;
  border: 1px solid var(--cor-borda);
  border-radius: 16px;
  background: var(--cor-painel);
  color: var(--cor-texto);
}

.bloqueio h1 {
  margin: 0;
  font-family: var(--fonte-titulo);
}

.bloqueio p {
  margin: 0;
}

.bloqueio-codigo {
  font-family: var(--fonte-mono);
  color: var(--cor-texto-secundario);
}

.bloqueio button {
  padding: 10px 20px;
  border: 1px solid var(--cor-borda);
  border-radius: 12px;
  background: var(--cor-painel-secundario);
  color: var(--cor-texto);
}
</style>