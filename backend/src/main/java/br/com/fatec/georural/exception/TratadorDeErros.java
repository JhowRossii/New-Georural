package br.com.fatec.georural.exception;

import br.com.fatec.georural.config.CorrelacaoFilter;
import br.com.fatec.georural.dto.ErroResposta;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;

// Erros que nascem dentro do Spring MVC. Os que nascem na cadeia de filtros
// (401 e 403 do proprio Spring Security) sao tratados pelo EnvelopeDeErroHttp.
@RestControllerAdvice
public class TratadorDeErros {

    private static final Logger log = LoggerFactory.getLogger(TratadorDeErros.class);

    // AccessDeniedException lancada dentro de um controller e RuntimeException
    // como qualquer outra: sem este tratador ela cai no generico e volta 500.
    // No projeto anterior isso fez o cliente do Airflow repetir tres vezes uma
    // chamada que jamais seria permitida, porque 5xx para ele e falha
    // temporaria.
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErroResposta> acessoNegado(AccessDeniedException excecao,
                                                     HttpServletRequest requisicao) {
        log.warn("403 {} {} -> {}", requisicao.getMethod(), requisicao.getRequestURI(),
                excecao.getMessage());
        return montar(HttpStatus.FORBIDDEN, "Seu perfil nao permite esta operacao.", requisicao);
    }

    // Ultima linha. Nunca devolve getMessage() de excecao desconhecida: o texto
    // pode conter detalhe interno. O que acontece fica no log, com o codigo.
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErroResposta> erroInesperado(Exception excecao,
                                                       HttpServletRequest requisicao) {
        log.error("500 {} {} -> {}", requisicao.getMethod(), requisicao.getRequestURI(),
                excecao.toString(), excecao);
        return montar(HttpStatus.INTERNAL_SERVER_ERROR,
                "Erro inesperado. Informe o codigo desta mensagem ao suporte.", requisicao);
    }

    private ResponseEntity<ErroResposta> montar(HttpStatus status, String mensagem,
                                                HttpServletRequest requisicao) {
        return ResponseEntity.status(status).body(new ErroResposta(
                status.value(),
                status.getReasonPhrase(),
                mensagem,
                requisicao.getRequestURI(),
                MDC.get(CorrelacaoFilter.CHAVE_MDC),
                Instant.now()));
    }
}