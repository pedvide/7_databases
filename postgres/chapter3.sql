--- Install extensions: tablefunc, dict_xsyn, fuzzystrmatch, pg_trgm, and cube 
CREATE EXTENSION IF NOT EXISTS tablefunc;

CREATE EXTENSION IF NOT EXISTS dict_xsyn;

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE EXTENSION IF NOT EXISTS cube;

--- Fuzzy Searching
SELECT title
FROM movies
WHERE title ILIKE 'stardust%';

SELECT title
FROM movies
WHERE title ILIKE 'stardust_%';

SELECT COUNT(*)
FROM movies
WHERE title !~* '^the.*';

CREATE INDEX movies_title_pattern ON movies (lower(title) text_pattern_ops);

SELECT levenshtein('bat', 'fads');

SELECT levenshtein('bat', 'fad') fad,
    levenshtein('bat', 'fat') fat,
    levenshtein('bat', 'bat') bat;

SELECT movie_id,
    title
FROM movies
WHERE levenshtein(lower(title), lower('a hard day nght')) <= 3;

SELECT show_trgm('Avatar');

CREATE INDEX movies_title_trigram ON movies USING gist (title gist_trgm_ops);

SELECT title
FROM movies
WHERE title % 'Avatre';

--- Full text
SELECT title
FROM movies
WHERE title @ @ 'night & day';

SELECT to_tsvector('A Hard Day''s Night'),
    to_tsquery('english', 'night & day');

SELECT *
FROM movies
WHERE title @ @ to_tsquery('english', 'a');

SELECT to_tsvector('simple', 'A Hard Day''s Night');

SELECT ts_lexize('english_stem', 'Day''s');

SELECT to_tsvector('german', 'was machst du gerade?');

EXPLAIN
SELECT *
FROM movies
WHERE title @ @ 'night & day';

CREATE INDEX movies_title_searchable ON movies USING gin(to_tsvector('english', title));

EXPLAIN
SELECT *
FROM movies
WHERE to_tsvector('english', title) @ @ 'night & day';

SELECT *
FROM actors
WHERE name % 'Broos Wils';

SELECT title
FROM movies
    NATURAL JOIN movies_actors
    NATURAL JOIN actors
WHERE metaphone(name, 6) = metaphone('Broos Wils', 6);

SELECT name,
    dmetaphone(name),
    dmetaphone_alt(name),
    metaphone(name, 8),
    soundex(name)
FROM actors;

SELECT *
FROM actors
WHERE metaphone(name, 8) % metaphone('Robin Williams', 8)
ORDER BY levenshtein(lower('Robin Williams'), lower(name));

SELECT *
FROM actors
WHERE dmetaphone(name) % dmetaphone('Ron');

--- Genres as a Multidimensional Hypercube
SELECT *
FROM movies;

SELECT name,
    cube_ur_coord(
        '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)',
        position
    ) AS score
FROM genres g
WHERE cube_ur_coord(
        '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)',
        position
    ) > 0;

SELECT *,
    cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
FROM movies
ORDER BY dist;

SELECT title,
    cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
FROM movies
WHERE cube_enlarge(
        '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)'::cube,
        5,
        18
    ) @> genre
ORDER BY dist;

SELECT m.movie_id,
    m.title,
    cube_distance(m.genre, s.genre) dist
FROM movies m,
    (
        SELECT genre,
            title
        FROM movies
        WHERE title = 'Mad Max'
    ) s
WHERE cube_enlarge(s.genre, 5, 18) @> m.genre
    AND s.title <> m.title
ORDER BY dist
LIMIT 10;

--- Homework
-- 1
SELECT *
FROM similar_movies('Mad Max');

SELECT *
FROM similar_movies('Bruce Willis');
