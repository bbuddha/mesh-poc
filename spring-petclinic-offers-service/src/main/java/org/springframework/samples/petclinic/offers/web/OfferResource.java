package org.springframework.samples.petclinic.offers.web;

import lombok.RequiredArgsConstructor;
import org.springframework.samples.petclinic.offers.model.Offer;
import org.springframework.samples.petclinic.offers.model.OfferRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;


@RequestMapping("/offers")
@RestController
@RequiredArgsConstructor
class OfferResource {

    private final OfferRepository offerRepository;

    @GetMapping
    public List<String> getOffers() {
        List<Offer> offers = offerRepository.findAll();
        System.out.println(offers);
        return offers.stream().map(offer -> offer.getDescription()).collect(Collectors.toList());
    }
}
