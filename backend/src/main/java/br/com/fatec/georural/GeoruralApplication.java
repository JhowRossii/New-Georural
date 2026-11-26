package br.com.fatec.georural;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.TimeZone;

@SpringBootApplication
public class GeoruralApplication {

    public static void main(String[] args) {
        // Marco zero: fuso da JVM fixado
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        SpringApplication.run(GeoruralApplication.class, args);
    }
}