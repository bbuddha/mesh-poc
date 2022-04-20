package org.springframework.samples.petclinic.customers.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class ExternalServiceClient {

    @Autowired
    private RestTemplate restTemplate;

    public String get(Map<String, String> allParams) {
        String resourceUrl = "http://localhost:10000/get?foo={foo}";
        return restTemplate.getForObject(resourceUrl, String.class, allParams);
    }
}
