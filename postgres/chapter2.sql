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
SELECT venue_id,
    COUNT(*)
FROM EVENTS
GROUP BY venue_id;

SELECT venue_id,
    COUNT(*)
FROM EVENTS
GROUP BY venue_id
HAVING COUNT(*) >= 2
    AND venue_id IS NOT NULL;

SELECT venue_id
FROM EVENTS
GROUP BY venue_id;

SELECT DISTINCT venue_id
FROM EVENTS;

--- Window Functions
SELECT title,
    COUNT(*) OVER (PARTITION BY venue_id)
FROM EVENTS;

--- Transactions
BEGIN TRANSACTION;

DELETE FROM EVENTS;

ROLLBACK;

SELECT *
FROM EVENTS;

END;

--- Stored Procedures
SELECT add_event(
        'House Party',
        '2018-05-03 23:00',
        '2018-05-04 02:00',
        'Run''s House',
        '97206',
        'us'
    );

--- Triggers
-- Table
CREATE TABLE LOGS (
    event_id integer,
    old_title varchar(255),
    old_starts timestamp,
    old_ends timestamp,
    logged_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- stored procedure
CREATE OR REPLACE FUNCTION log_event() RETURNS TRIGGER AS $$
DECLARE BEGIN
INSERT INTO LOGS (event_id, old_title, old_starts, old_ends)
VALUES (OLD.event_id, OLD.title, OLD.starts, OLD.ends);

RAISE NOTICE 'Someone just changed event #%',
OLD.event_id;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER log_events
AFTER
UPDATE ON EVENTS FOR EACH ROW EXECUTE PROCEDURE log_event();

-- test trigger
UPDATE EVENTS
SET ends = '2018-05-04 01:00:00'
WHERE title = 'House Party';

SELECT event_id,
    old_title,
    old_ends,
    logged_at
FROM LOGS;

--- Views
CREATE VIEW holidays AS
SELECT event_id AS holiday_id,
    title AS name,
    starts AS date
FROM EVENTS
WHERE title LIKE '%Day%'
    AND venue_id IS NULL;

SELECT name,
    to_char(date, 'Month DD, YYYY') AS date
FROM holidays
WHERE date <= '2018-04-01';

ALTER TABLE EVENTS
ADD colors text ARRAY;

CREATE OR REPLACE VIEW holidays AS
SELECT event_id AS holiday_id,
    title AS name,
    starts AS date,
    colors
FROM EVENTS
WHERE title LIKE '%Day%'
    AND venue_id IS NULL;

UPDATE holidays
SET colors = '{"red","green"}'
WHERE name = 'Christmas Day';

--- Rules
EXPLAIN VERBOSE
SELECT *
FROM holidays;

CREATE RULE update_holidays AS ON UPDATE TO holidays DO INSTEAD
UPDATE EVENTS
SET title = NEW.name,
    starts = NEW.date,
    colors = NEW.colors
WHERE title = OLD.name;

UPDATE holidays
SET colors = '{"red","green"}'
WHERE name = 'Christmas Day';

--- Crosstab
SELECT extract(
        year
        FROM starts
    ) AS year,
    extract(
        MONTH
        FROM starts
    ) AS MONTH,
    COUNT(*)
FROM EVENTS
GROUP BY year,
    MONTH
ORDER BY year,
    MONTH;

CREATE TEMPORARY TABLE month_count(MONTH INT);

INSERT INTO month_count
VALUES (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12);

--- Not in test, needed to use crosstab()
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
        'SELECT extract(year from starts) as year,
extract(month from starts) as month, count(*)
FROM events
GROUP BY year, month
ORDER BY year, month',
        'SELECT * FROM month_count'
    ) AS (
        year int,
        jan int,
        feb int,
        mar int,
        apr int,
        may int,
        jun int,
        jul int,
        aug int,
        sep int,
        oct int,
        nov int,
        dec int
    )
ORDER BY YEAR;

--- Homework
-- 1
CREATE RULE delete_venues AS ON DELETE TO venues DO INSTEAD
UPDATE venues
SET active = false
WHERE venue_id = OLD.venue_id;

SELECT *
FROM venues;

DELETE FROM venues
WHERE name = 'My Place';

UPDATE venues
SET active = TRUE
WHERE name = 'My Place';

-- 2
SELECT *
FROM crosstab(
        'SELECT extract(year from starts) as year,
extract(month from starts) as month, count(*)
FROM events
GROUP BY year, month
ORDER BY year, month',
        'SELECT * FROM generate_series(1, 12)'
    ) AS (
        year int,
        jan int,
        feb int,
        mar int,
        apr int,
        may int,
        jun int,
        jul int,
        aug int,
        sep int,
        oct int,
        nov int,
        dec int
    )
ORDER BY YEAR;

-- 3
SELECT week,
    COALESCE(sunday, 0) AS sunday,
    COALESCE(monday, 0) AS monday,
    COALESCE(tuesday, 0) AS tuesday,
    COALESCE(wednesday, 0) AS wednesday,
    COALESCE(thursday, 0) AS thursday,
    COALESCE(friday, 0) AS friday,
    COALESCE(saturday, 0) AS saturday
FROM crosstab(
        'SELECT extract(week from starts) as week,
extract(dow from starts) as day_of_week, count(*)
FROM events
WHERE extract(month from starts) = 2
GROUP BY week, day_of_week
ORDER BY week, day_of_week',
        'SELECT * FROM generate_series(0, 6)'
    ) AS (
        week int,
        sunday int,
        monday int,
        tuesday int,
        wednesday int,
        thursday int,
        friday int,
        saturday int
    )
ORDER BY week;
