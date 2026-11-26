package br.com.fatec.georural.dto;

// O que o portal precisa saber sobre quem entrou. O perfil vem da tabela
// USUARIO, nao dos papeis do token.
public record UsuarioAtualResponse(
        Long id,
        String nome,
        String email,
        String perfil) {
}