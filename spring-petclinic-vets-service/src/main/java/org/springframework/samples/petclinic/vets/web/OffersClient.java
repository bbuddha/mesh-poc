package org.springframework.samples.petclinic.vets.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.List;

import lombok.RequiredArgsConstructor;

@Service
public class OffersClient {
    private static final Logger LOGGER = LoggerFactory.getLogger(OffersClient.class);

    @Autowired
    private RestTemplate restTemplate;

    public List<String> getOffers() {
        List<String> offers = Collections.EMPTY_LIST;
        try {
            String resourceUrl = "http://localhost:10000/offers";
            ResponseEntity<List> response = restTemplate.getForEntity(resourceUrl, List.class);
            offers = response.getBody();
            Collections.shuffle(offers);
        } catch (Exception e) {
            LOGGER.warn("Exception caught.", e);
            offers = Collections.singletonList("Offers not available, please try later.");
        }
        return offers;
    }
}
