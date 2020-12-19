--- Aggregate FUNCTIONS
INSERT INTO EVENTS (title, starts, ends, venue_id)
VALUES (
        'Moby',
        '2018-02-06 21:00',
        '2018-02-06 23:00',
        (
            SELECT venue_id
            FROM venues
            WHERE name = 'Crystal Ballroom'
        )
    );

INSERT INTO countries (country_name, country_code)
VALUES ('Spain', 'es');

INSERT INTO cities (name, postal_code, country_code)
VALUES ('Burgos', '09004', 'es');

INSERT INTO venues (name, street_address, postal_code, country_code)
VALUES ('My Place', 'Fake street 123', '09004', 'es');

INSERT INTO EVENTS (title, starts, ends, venue_id)
VALUES (
        'Wedding',
        '2018-02-26 21:00:00',
        '2018-02-26 23:00:00',
        (
            SELECT venue_id
            FROM venues
            WHERE name = 'Voodoo Doughnut'
        )
    ),
    (
        'Dinner with Mom',
        '2018-02-26 18:00:00',
        '2018-02-26 20:30:00',
        (
            SELECT venue_id
            FROM venues
            WHERE name = 'My Place'
        )
    ),
    (
        'Valentine''s Day',
        '2018-02-14 00:00:00',
        '2018-02-14 23:59:00',
        NULL
    );

SELECT COUNT(title)
FROM EVENTS
WHERE title LIKE '%Day%';

SELECT min(starts),
    max(ends)
FROM EVENTS
    INNER JOIN venues ON EVENTS.venue_id = venues.venue_id
WHERE venues.name = 'Crystal Ballroom';

--- Grouping
