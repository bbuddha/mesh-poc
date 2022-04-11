package org.springframework.samples.petclinic.customers.web;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class ExternalServiceClient {

    public String get(Map<String, String> allParams) {
        RestTemplate restTemplate = new RestTemplate();
        String resourceUrl = "http://localhost:10000/get?foo={foo}";
        return restTemplate.getForObject(resourceUrl, String.class, allParams);
    }
}
