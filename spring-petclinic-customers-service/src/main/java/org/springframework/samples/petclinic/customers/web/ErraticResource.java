/*
 * Copyright 2002-2021 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.samples.petclinic.customers.web;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

/**
 * @author Juergen Hoeller
 * @author Ken Krebs
 * @author Arjen Poutsma
 * @author Michael Isvy
 * @author Maciej Szarlinski
 */
@RequestMapping("/erratic")
@RestController
@Timed("petclinic.erratic")
@RequiredArgsConstructor
@Slf4j
class ErraticResource {

    private int requestCount = 0;

    private synchronized void logRequestCount() {
        log.info("Request #" + ++requestCount);
    }

    /**
     * Read List of Owners
     */
    @GetMapping
    public List<String> findAll(@RequestParam int errorRate) {
        logRequestCount();
        if(requestCount % errorRate == 0 ){
            throw new ServerException("Fake error.");
        }
        return Arrays.asList("OK");
    }
}
