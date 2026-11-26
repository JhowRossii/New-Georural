package br.com.fatec.georural;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.TimeZone;

@SpringBootApplication
public class GeoruralApplication {

    public static void main(String[] args) {
        // Marco zero, decisao 1: fuso da JVM fixado aqui, antes de qualquer
        // componente subir. Fixar em codigo e nao na configuracao de execucao
        // tira a decisao das maos de quem roda: o IntelliJ de um, o terminal de
        // outro e o container da nuvem passam a concordar sobre que horas sao.
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        SpringApplication.run(GeoruralApplication.class, args);
    }
}