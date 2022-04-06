package org.springframework.samples.petclinic.offers.system;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Typesafe custom configuration.
 */
@Data
@ConfigurationProperties(prefix = "offers")
public class OffersProperties {

    private Cache cache;

    @Data
    public static class Cache {
        private int ttl;
        private int heapSize;
    }
}
