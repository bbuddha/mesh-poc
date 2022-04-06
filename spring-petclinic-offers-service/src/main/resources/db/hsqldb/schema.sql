DROP TABLE offers IF EXISTS;

CREATE TABLE offers (
  id INTEGER IDENTITY PRIMARY KEY,
  description VARCHAR(80)
);

--CREATE TABLE vet_offers (
--  vet_id INTEGER NOT NULL,
--  offer_id INTEGER NOT NULL
--);
--ALTER TABLE vet_specialties ADD CONSTRAINT fk_vet_specialties_vets FOREIGN KEY (vet_id) REFERENCES vets (id);
--ALTER TABLE vet_offers ADD CONSTRAINT fk_vet_offers_offers FOREIGN KEY (offer_id) REFERENCES offers (id);
