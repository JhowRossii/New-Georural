package br.com.fatec.georural.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Locale;
import java.util.UUID;
import java.util.regex.Pattern;

// Da um codigo curto a cada requisicao, poe no MDC para que ele apareca em
// toda linha de log daquela requisicao, devolve no cabecalho para o front
// mostrar na tela, e garante uma linha de log por requisicao.
// HIGHEST_PRECEDENCE porque precisa rodar antes do Spring Security: assim um
// 401 tambem sai com codigo, e 401 e o erro que o usuario mais encontra.
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CorrelacaoFilter extends OncePerRequestFilter {

    public static final String CHAVE_MDC = "correlacao";
    public static final String CABECALHO = "X-Correlacao";

    private static final Logger log = LoggerFactory.getLogger(CorrelacaoFilter.class);

    // So aceita codigo vindo de fora neste formato. Sem isso um cliente
    // poderia injetar texto arbitrario dentro das linhas de log.
    private static final Pattern ACEITO = Pattern.compile("[A-Za-z0-9-]{1,36}");

    @Override
    protected void doFilterInternal(HttpServletRequest requisicao,
                                    HttpServletResponse resposta,
                                    FilterChain cadeia) throws ServletException, IOException {

        String codigo = requisicao.getHeader(CABECALHO);
        if (codigo == null || !ACEITO.matcher(codigo).matches()) {
            codigo = gerar();
        }

        MDC.put(CHAVE_MDC, codigo);
        resposta.setHeader(CABECALHO, codigo);

        long inicio = System.nanoTime();
        try {
            cadeia.doFilter(requisicao, resposta);
        } finally {
            long ms = (System.nanoTime() - inicio) / 1_000_000;
            // Uma linha por requisicao, sempre. Sem ela, um 401 ou um 404 nao
            // deixam rastro nenhum e o codigo da tela nao acha nada no log.
            // Sem a query string de proposito: ela pode carregar token.
            log.info("{} {} -> {} em {}ms",
                    requisicao.getMethod(), requisicao.getRequestURI(),
                    resposta.getStatus(), ms);
            // O Tomcat reusa a thread: sem limpar, o codigo vaza para a
            // proxima requisicao atendida por ela.
            MDC.remove(CHAVE_MDC);
        }
    }

    private String gerar() {
        return "GR-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase(Locale.ROOT);
    }
}