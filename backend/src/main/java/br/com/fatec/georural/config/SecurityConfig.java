package br.com.fatec.georural.config;

import br.com.fatec.georural.security.ConversorDeTokenParaUsuario;
import br.com.fatec.georural.security.EnvelopeDeErroHttp;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

// Matriz de permissao do GeoRural. Hoje so existe /api/v1/eu; cada US que
// trouxer rota nova acrescenta a linha dela aqui.
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    SecurityFilterChain cadeiaDeSeguranca(HttpSecurity http,
                                          ConversorDeTokenParaUsuario conversor,
                                          EnvelopeDeErroHttp envelope) throws Exception {

        http
                // Sem CSRF porque nao ha sessao nem cookie: a identidade vem
                // no cabecalho Authorization a cada requisicao.
                .csrf(csrf -> csrf.disable())
                .sessionManagement(sessao -> sessao
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(rotas -> rotas
                        // Aberto para o Docker e o balanceador saberem se a
                        // aplicacao esta viva sem precisar de credencial.
                        .requestMatchers("/actuator/health", "/actuator/health/**").permitAll()
                        // O Spring redireciona falha para /error. Se essa rota
                        // exigir autenticacao, o 401 dela cobre o erro de
                        // verdade e some com o codigo de correlacao.
                        .requestMatchers("/error").permitAll()
                        .anyRequest().authenticated())
                .oauth2ResourceServer(oauth -> oauth
                        .jwt(jwt -> jwt.jwtAuthenticationConverter(conversor))
                        .authenticationEntryPoint(envelope::naoAutenticado)
                        .accessDeniedHandler(envelope::acessoNegado))
                .exceptionHandling(erros -> erros
                        .authenticationEntryPoint(envelope::naoAutenticado)
                        .accessDeniedHandler(envelope::acessoNegado));

        return http.build();
    }
}