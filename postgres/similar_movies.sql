CREATE OR REPLACE FUNCTION similar_movies(title_or_author text) RETURNS TABLE (m_movie_id integer, m_title text) AS $$
DECLARE the_movie_id integer;

the_actor_id integer;

BEGIN
SELECT movie_id INTO the_movie_id
FROM movies m
WHERE m.title = title_or_author
LIMIT 1;

SELECT actor_id INTO the_actor_id
FROM actors a
WHERE metaphone(a.name, 8) % metaphone(title_or_author, 8)
ORDER BY levenshtein(lower(title_or_author), lower(a.name))
LIMIT 1;

IF the_movie_id IS NOT NULL THEN RAISE NOTICE 'Movie found %',
the_movie_id;

ELSE RAISE NOTICE 'Actor found %',
the_actor_id;

END IF;

IF the_movie_id IS NOT NULL THEN RETURN QUERY
SELECT m.movie_id,
    m.title
FROM movies m,
    (
        SELECT genre,
            title
        FROM movies
        WHERE movie_id = the_movie_id
    ) s
WHERE cube_enlarge(s.genre, 5, 18) @> m.genre
    AND s.title <> m.title
ORDER BY cube_distance(m.genre, s.genre)
LIMIT 5;

ELSE RETURN QUERY
SELECT m.movie_id,
    m.title
FROM movies m
WHERE m.movie_id IN (
        SELECT movie_id
        FROM movies_actors
        WHERE actor_id = the_actor_id
    )
LIMIT 5;

END IF;

END;

$$ LANGUAGE plpgsql;
