package br.com.fatec.georural.security;

// Quem esta por tras da requisicao, ja resolvido contra o banco. Viaja como
// principal da autenticacao para que nenhum controller precise consultar
// USUARIO de novo.
public record UsuarioAutenticado(
        Long id,
        String keycloakId,
        String nome,
        String email,
        String perfil) {
}