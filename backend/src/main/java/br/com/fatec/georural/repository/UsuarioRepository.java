package br.com.fatec.georural.repository;

import br.com.fatec.georural.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    // usu_keycloak_id e UNIQUE e guarda o claim sub do token.
    Optional<Usuario> findByKeycloakId(String keycloakId);
}