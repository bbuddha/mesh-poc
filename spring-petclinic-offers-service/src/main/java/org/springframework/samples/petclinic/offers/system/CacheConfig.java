package org.springframework.samples.petclinic.offers.system;

import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * Cache could be disabled in unit test.
 */
@Configuration
@EnableCaching
@Profile("production")
class CacheConfig {
}
