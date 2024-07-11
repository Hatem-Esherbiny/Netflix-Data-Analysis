---------------- ( USEING DATABASE ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE Netflix 
GO
---------------- ( CLEANING DATA ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *	
FROM netflix ;
 
---------------1_( DETECTING MISSING VALUES ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM netflix
WHERE director IS NULL
   OR country IS NULL
   OR date_added IS NULL
   OR release_year IS NULL
   OR rating IS NULL
   OR duration IS NULL
   OR listed_in IS NULL;

---------------2_( DETECTING DUPLICATES ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT show_id ,count(*)
FROM netflix 
GROUP BY show_id 
HAVING count(*) > 1 ;

SELECT   show_id, type , title, director, country, date_added, release_year, rating, duration, listed_in, COUNT(*)
FROM netflix
GROUP BY show_id, type , title, director, country, date_added, release_year, rating, duration, listed_in
HAVING COUNT(*) > 1;

---------------3_( Check for errors in the data ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT *
FROM netflix
WHERE date_added > CAST(GETDATE() AS DATE);

SELECT *
FROM netflix
WHERE release_year > YEAR(CAST(GETDATE() AS DATE));

---------------4_( Detecting Invalid Ratings ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM netflix
WHERE rating NOT IN ('G', 'PG', 'PG-13', 'R', 'NC-17', 'NR', 'TV-Y', 'TV-Y7', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA','TV-Y7-FV', 'UR');

---------------5_( Comprehensive Data Quality Summary )  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT 
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS null_director,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS null_date_added,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS null_release_year,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rate,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_duration,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS null_listed_in,
    SUM(CASE WHEN date_added > CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS invalid_date_added,
    SUM(CASE WHEN release_year > YEAR (CAST(GETDATE() AS DATE)) THEN 1 ELSE 0 END) AS invalid_release_year,
    SUM(CASE WHEN rating NOT IN ('G', 'PG', 'PG-13', 'R', 'NC-17', 'NR', 'TV-Y', 'TV-Y7', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA','TV-Y7-FV', 'UR') THEN 1 ELSE 0 END) AS invalid_rate,
    COUNT(*) AS total_rows
FROM netflix;

--------- ( End Cleanig )--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




------( Understanding the Data )------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  ( Count of shows by type )
SELECT type, COUNT(*) AS count
FROM netflix
GROUP BY type;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ( Number of shows added each year )

SELECT YEAR(date_added) AS 'year of added ', COUNT(*) AS count
FROM netflix
GROUP BY YEAR(date_added)
ORDER BY  'Year Of Added '  Desc;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ( Number of shows per director )

SELECT TOP(10)director,country, COUNT(*) AS count
FROM netflix
GROUP BY director , country
HAVING director != 'Not Given'
ORDER BY count DESC

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows by rating )

SELECT rating, COUNT(*) AS count
FROM netflix
GROUP BY rating
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows by country )

SELECT TOP(10) country, COUNT(*) AS count
FROM netflix
WHERE country != 'Not Given '
GROUP BY country
ORDER BY count DESC

SELECT type, country , count(*)	AS count
FROM netflix
GROUP BY type, country 
Having type = 'TV Show'
ORDER BY count desc

SELECT type, country , count(*)	AS count
FROM netflix
GROUP BY type, country 
Having type = 'Movie'
ORDER BY count desc
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ( Number of shows by type and rating )

SELECT type, rating, COUNT(*) AS count
FROM netflix
GROUP BY type, rating
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
