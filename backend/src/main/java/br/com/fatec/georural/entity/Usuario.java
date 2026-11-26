package br.com.fatec.georural.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;

import java.time.Instant;

// Pessoa ou conta de maquina do GeoRural. A identidade e autenticada pelo
// Keycloak; aqui ficam o vinculo com o perfil e o estado da conta.
@Entity
@Table(name = "USUARIO")
@Getter
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "usu_id")
    private Long id;

    // EAGER de proposito: o perfil e lido em toda requisicao autenticada, e
    // com open-in-view desligado um LAZY aqui quebraria fora da transacao.
    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "per_id", nullable = false)
    private Perfil perfil;

    @Column(name = "usu_keycloak_id", nullable = false, updatable = false, length = 36)
    private String keycloakId;

    @Column(name = "usu_nome", nullable = false, length = 120)
    private String nome;

    @Column(name = "usu_email", nullable = false, length = 255)
    private String email;

    @Column(name = "usu_status", nullable = false, length = 1)
    private String status;

    @Column(name = "usu_ultimo_login")
    private Instant ultimoLogin;

    // Preenchida pelo DEFAULT da tabela, em UTC. insertable e updatable
    // falsos para que o Hibernate nunca tente escrever nela.
    @Column(name = "usu_data_cadastro", insertable = false, updatable = false)
    private Instant dataCadastro;

    protected Usuario() {
    }

    public boolean ativo() {
        return "S".equals(status);
    }

    // Chamado quando o portal pergunta quem e a pessoa, logo apos o login.
    // Nome e email so sao atualizados quando o token os traz: o token de
    // client_credentials da conta de maquina nao tem esses claims, e sem
    // esta guarda a identidade dela seria apagada a cada chamada.
    public void registrarAcesso(Instant quando, String nomeDoToken, String emailDoToken) {
        this.ultimoLogin = quando;
        if (nomeDoToken != null && !nomeDoToken.isBlank()) {
            this.nome = nomeDoToken;
        }
        if (emailDoToken != null && !emailDoToken.isBlank()) {
            this.email = emailDoToken;
        }
    }
}