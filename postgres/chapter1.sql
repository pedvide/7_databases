--- Countries
CREATE TABLE countries (
    country_code char(2) PRIMARY KEY,
    country_name text UNIQUE
);

INSERT INTO countries (country_code, country_name)
VALUES ('us', 'United States'),
    ('mx', 'Mexico'),
    ('au', 'Australia'),
    ('gb', 'United Kingdom'),
    ('de', 'Germany'),
    ('ll', 'Loompaland');

SELECT *
FROM countries;

DELETE FROM countries
WHERE country_code = 'll';

--- Cities
CREATE TABLE cities (
    name text NOT NULL,
    postal_code varchar(9) CHECK (postal_code <> ''),
    country_code char(2) REFERENCES countries,
    PRIMARY KEY (country_code, postal_code)
);

INSERT INTO cities
VALUES ('Portland', '87200', 'us');

UPDATE cities
SET postal_code = '97206'
WHERE name = 'Portland';

-- Join
SELECT cities.*,
    country_name
FROM cities
    INNER JOIN countries
    /* or just FROM cities JOIN countries */
    ON cities.country_code = countries.country_code;

-- Venues
CREATE TABLE venues (
    venue_id SERIAL PRIMARY KEY,
    name varchar(255),
    street_address text,
    TYPE char(7) CHECK (TYPE IN ('public', 'private')) DEFAULT 'public',
    postal_code varchar(9),
    country_code char(2),
    FOREIGN KEY (country_code, postal_code) REFERENCES cities (country_code, postal_code) MATCH FULL
);

INSERT INTO venues (name, postal_code, country_code)
VALUES ('Crystal Ballroom', '97206', 'us');

SELECT v.venue_id,
    v.name,
    c.name
FROM venues v
    INNER JOIN cities c ON v.postal_code = c.postal_code
    AND v.country_code = c.country_code;