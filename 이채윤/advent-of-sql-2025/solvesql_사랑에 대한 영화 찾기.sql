-- [풀이]
    SELECT 
    title
    ,year
    ,rotten_tomatoes
    FROM movies
    WHERE LOWER(title) LIKE '%love%'
    ORDER BY rotten_tomatoes DESC, year DESC;
    ;

    -- [개념 정리]
    -- LIKE: 
