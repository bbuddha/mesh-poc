package org.springframework.samples.petclinic.offers;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.samples.petclinic.offers.system.OffersProperties;

@SpringBootApplication
@EnableConfigurationProperties(OffersProperties.class)
public class OffersServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(OffersServiceApplication.class, args);
	}
}
