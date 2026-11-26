package br.com.fatec.georural.security;

import br.com.fatec.georural.entity.Usuario;
import br.com.fatec.georural.repository.UsuarioRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

import java.util.List;

// Decisao D4 do marco zero: o token prova QUEM e; o banco diz o QUE pode.
// O papel nunca vem dos realm_access.roles - se viesse, existiria um
// invariante "token igual a banco" que alguem quebraria, e a quebra
// apareceria como 401 sem explicacao.
@Component
public class ConversorDeTokenParaUsuario implements Converter<Jwt, AbstractAuthenticationToken> {

    private static final Logger log = LoggerFactory.getLogger(ConversorDeTokenParaUsuario.class);

    private final UsuarioRepository usuarios;

    public ConversorDeTokenParaUsuario(UsuarioRepository usuarios) {
        this.usuarios = usuarios;
    }

    @Override
    public AbstractAuthenticationToken convert(Jwt token) {
        String sub = token.getSubject();

        Usuario usuario = usuarios.findByKeycloakId(sub).orElseThrow(() -> {
            log.warn("acesso negado | motivo=sem cadastro em USUARIO | sub={} | emissor={}",
                    sub, token.getIssuer());
            return new ContaSemAcessoException(
                    "Sua conta foi autenticada, mas nao tem cadastro no GeoRural. "
                            + "Procure o administrador.");
        });

        if (!usuario.ativo()) {
            log.warn("acesso negado | motivo=conta desativada | sub={} | email={}",
                    sub, usuario.getEmail());
            throw new ContaSemAcessoException(
                    "Sua conta esta desativada no GeoRural. Procure o administrador.");
        }

        String funcao = usuario.getPerfil().getFuncao();

        UsuarioAutenticado principal = new UsuarioAutenticado(
                usuario.getId(), usuario.getKeycloakId(),
                usuario.getNome(), usuario.getEmail(), funcao);

        // O prefixo ROLE_ e o que hasRole() e @PreAuthorize("hasRole(...)")
        // esperam encontrar.
        return new AutenticacaoGeorural(token, principal,
                List.of(new SimpleGrantedAuthority("ROLE_" + funcao)));
    }
}