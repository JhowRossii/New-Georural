package br.com.fatec.georural.security;

import br.com.fatec.georural.config.CorrelacaoFilter;
import br.com.fatec.georural.dto.ErroResposta;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.time.Instant;

// 401 e 403 nascem DENTRO da cadeia de filtros, antes do Spring MVC, entao um
// @RestControllerAdvice nunca os enxerga. Sem esta classe eles sairiam como
// pagina de erro padrao, sem codigo de correlacao e sem explicacao - que foi
// exatamente o que escondeu a causa de um 403 por horas no projeto anterior.
@Component
public class EnvelopeDeErroHttp {

    private final ObjectMapper json;

    public EnvelopeDeErroHttp(ObjectMapper json) {
        this.json = json;
    }

    public void naoAutenticado(HttpServletRequest requisicao, HttpServletResponse resposta,
                               AuthenticationException excecao) throws IOException {
        String mensagem = excecao instanceof ContaSemAcessoException
                ? excecao.getMessage()
                : "Token ausente, invalido ou expirado. Entre novamente.";
        escrever(requisicao, resposta, HttpStatus.UNAUTHORIZED, mensagem);
    }

    public void acessoNegado(HttpServletRequest requisicao, HttpServletResponse resposta,
                             AccessDeniedException excecao) throws IOException {
        escrever(requisicao, resposta, HttpStatus.FORBIDDEN,
                "Seu perfil nao permite esta operacao.");
    }

    private void escrever(HttpServletRequest requisicao, HttpServletResponse resposta,
                          HttpStatus status, String mensagem) throws IOException {
        ErroResposta corpo = new ErroResposta(
                status.value(),
                status.getReasonPhrase(),
                mensagem,
                requisicao.getRequestURI(),
                MDC.get(CorrelacaoFilter.CHAVE_MDC),
                Instant.now());

        resposta.setStatus(status.value());
        resposta.setContentType(MediaType.APPLICATION_JSON_VALUE);
        resposta.setCharacterEncoding("UTF-8");
        resposta.getWriter().write(json.writeValueAsString(corpo));
    }
}