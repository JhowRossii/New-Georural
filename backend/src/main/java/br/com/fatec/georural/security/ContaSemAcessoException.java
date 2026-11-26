package br.com.fatec.georural.security;

import org.springframework.security.core.AuthenticationException;

// Token valido no Keycloak, mas a conta nao pode usar o GeoRural: ou nao tem
// cadastro em USUARIO, ou esta desativada. A mensagem aqui e a que chega ao
// usuario; o motivo tecnico vai para o log, com o sub.
public class ContaSemAcessoException extends AuthenticationException {

    public ContaSemAcessoException(String mensagem) {
        super(mensagem);
    }
}