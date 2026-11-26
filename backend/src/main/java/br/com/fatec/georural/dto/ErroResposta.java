package br.com.fatec.georural.dto;

import java.time.Instant;

// Contrato de erro do marco zero: toda falha sai com esta forma, venha ela da
// cadeia de seguranca ou do Spring MVC. O campo correlacao e o mesmo codigo
// que o CorrelacaoFilter poe no cabecalho X-Correlacao e em cada linha de log
// da requisicao - e por ele que a tela encontra o log.
public record ErroResposta(
        int status,
        String erro,
        String mensagem,
        String caminho,
        String correlacao,
        Instant instante) {
}