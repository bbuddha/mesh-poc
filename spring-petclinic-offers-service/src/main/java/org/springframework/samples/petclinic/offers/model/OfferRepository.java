package org.springframework.samples.petclinic.offers.model;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Repository class for <code>Offer</code> domain objects All method names are compliant with Spring Data naming
 * conventions so this interface can easily be extended for Spring Data
 * See here: http://static.springsource.org/spring-data/jpa/docs/current/reference/html/jpa.repositories.html#jpa.query-methods.query-creation
 */
public interface OfferRepository extends JpaRepository<Offer, Integer> {
}
