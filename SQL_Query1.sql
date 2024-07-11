
---------------- ( Create Databases ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE Netflix
---------------- ( USEING DATABASE ) ----------------------------------------------------------------------------------------------------------------------------------------------------------------

USE Netflix 
GO

---------------- ( CLEANING DATA ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- عرض كل البيانات من جدول netflix
SELECT *	
FROM netflix;

---------------1_( DETECTING MISSING VALUES ) ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- الكشف عن القيم المفقودة في الأعمدة الرئيسية
SELECT *
FROM netflix
WHERE director IS NULL
   OR country IS NULL
   OR date_added IS NULL
   OR release_year IS NULL
   OR rating IS NULL
   OR duration IS NULL
   OR listed_in IS NULL;

---------------2_( DETECTING DUPLICATES ) --------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT show_id, COUNT(*)
FROM netflix 
GROUP BY show_id 
HAVING COUNT(*) > 1;

-- الكشف عن التكرارات باستخدام جميع الأعمدة
SELECT show_id, type, title, director, country, date_added, release_year, rating, duration, listed_in, COUNT(*)
FROM netflix
GROUP BY show_id, type, title, director, country, date_added, release_year, rating, duration, listed_in
HAVING COUNT(*) > 1;

---------------3_( Check for errors in the data ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- التحقق من صحة التواريخ المضافة
SELECT *
FROM netflix
WHERE date_added > CAST(GETDATE() AS DATE);

-- التحقق من صحة سنة الإصدار
SELECT *
FROM netflix
WHERE release_year > YEAR(CAST(GETDATE() AS DATE));

---------------4_( Detecting Invalid Ratings ) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- الكشف عن التقييمات غير الصالحة
SELECT *
FROM netflix
WHERE rating NOT IN ('G', 'PG', 'PG-13', 'R', 'NC-17', 'NR', 'TV-Y', 'TV-Y7', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA', 'TV-Y7-FV', 'UR');

---------------5_( Comprehensive Data Quality Summary )  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ملخص شامل لجودة البيانات
SELECT 
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS null_director,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS null_date_added,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS null_release_year,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rate,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_duration,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS null_listed_in,
    SUM(CASE WHEN date_added > CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS invalid_date_added,
    SUM(CASE WHEN release_year > YEAR(CAST(GETDATE() AS DATE)) THEN 1 ELSE 0 END) AS invalid_release_year,
    SUM(CASE WHEN rating NOT IN ('G', 'PG', 'PG-13', 'R', 'NC-17', 'NR', 'TV-Y', 'TV-Y7', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA', 'TV-Y7-FV', 'UR') THEN 1 ELSE 0 END) AS invalid_rate,
    COUNT(*) AS total_rows
FROM netflix;

--------- ( End Cleaning )--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------( Understanding the Data )------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  ( Count of shows by type )
SELECT type, COUNT(*) AS count
FROM netflix
GROUP BY type;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows added each year )
SELECT YEAR(date_added) AS 'year_of_added', COUNT(*) AS count
FROM netflix
GROUP BY YEAR(date_added)
ORDER BY 'year_of_added' DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows per director )
SELECT TOP 10 director, country, COUNT(*) AS count
FROM netflix
GROUP BY director, country
HAVING director IS NOT NULL
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows by rating )
SELECT rating, COUNT(*) AS count
FROM netflix
GROUP BY rating
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows by country )
SELECT TOP 10 country, COUNT(*) AS count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of TV Shows by country )
SELECT type, country, COUNT(*) AS count
FROM netflix
WHERE type = 'TV Show'
GROUP BY type, country 
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of Movies by country )
SELECT type, country, COUNT(*) AS count
FROM netflix
WHERE type = 'Movie'
GROUP BY type, country 
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ( Number of shows by type and rating )
SELECT type, rating, COUNT(*) AS count
FROM netflix
GROUP BY type, rating
ORDER BY count DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
