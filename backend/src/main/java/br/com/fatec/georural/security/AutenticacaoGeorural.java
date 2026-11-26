package br.com.fatec.georural.security;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.Collection;

// Autenticacao do GeoRural: o token como credencial e o usuario resolvido do
// banco como principal.
public class AutenticacaoGeorural extends AbstractAuthenticationToken {

    private final transient Jwt token;
    private final transient UsuarioAutenticado usuario;

    public AutenticacaoGeorural(Jwt token, UsuarioAutenticado usuario,
                                Collection<? extends GrantedAuthority> autoridades) {
        super(autoridades);
        this.token = token;
        this.usuario = usuario;
        setAuthenticated(true);
    }

    @Override
    public Object getCredentials() {
        return token;
    }

    @Override
    public Object getPrincipal() {
        return usuario;
    }

    @Override
    public String getName() {
        return usuario.keycloakId();
    }
}