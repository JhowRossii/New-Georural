package br.com.fatec.georural.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;

// Perfil de acesso. per_funcao e o mesmo texto do realm role no Keycloak,
// e e dele que sai a autoridade do Spring Security.
@Entity
@Table(name = "PERFIL")
@Getter
public class Perfil {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "per_id")
    private Long id;

    @Column(name = "per_funcao", nullable = false, updatable = false, length = 20)
    private String funcao;

    @Column(name = "per_nome", nullable = false, length = 60)
    private String nome;

    @Column(name = "per_descricao", length = 240)
    private String descricao;

    protected Perfil() {
    }
}