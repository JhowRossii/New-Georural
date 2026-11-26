package br.com.fatec.georural.controller;

import br.com.fatec.georural.dto.UsuarioAtualResponse;
import br.com.fatec.georural.entity.Usuario;
import br.com.fatec.georural.repository.UsuarioRepository;
import br.com.fatec.georural.security.UsuarioAutenticado;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

// Identidade de quem esta autenticado. E a primeira chamada do portal depois
// do login: e dela que o front tira o nome e o perfil para montar o menu, e e
// ela que confirma que a conta existe do lado do GeoRural - no projeto
// anterior essa confirmacao estava pendurada em /api/fontes, que nao tem nada
// a ver com o assunto.
@RestController
@RequestMapping("/api/v1/usuario-atual")
public class UsuarioAtualController {

    private static final Logger log = LoggerFactory.getLogger(UsuarioAtualController.class);

    private final UsuarioRepository usuarios;

    public UsuarioAtualController(UsuarioRepository usuarios) {
        this.usuarios = usuarios;
    }

    @GetMapping
    @Transactional
    public UsuarioAtualResponse consultar(@AuthenticationPrincipal UsuarioAutenticado autenticado) {
        Usuario usuario = usuarios.getReferenceById(autenticado.id());

        // Unico escritor de usu_ultimo_login. Sem isto a coluna nasceria morta.
        usuario.registrarAcesso(Instant.now(), autenticado.nome(), autenticado.email());

        log.info("entrada no portal | usuario={} | perfil={}",
                usuario.getEmail(), usuario.getPerfil().getFuncao());

        return new UsuarioAtualResponse(usuario.getId(), usuario.getNome(),
                usuario.getEmail(), usuario.getPerfil().getFuncao());
    }
}