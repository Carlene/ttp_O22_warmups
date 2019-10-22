-- DEBUGGING CODE IS A VERY IMPORTANT SKILL

-- Right out of this program, you're hired as a mid-level data analyst. So the
-- junior analysts come to you with problems! They just can't get the code to 
-- run! Fix all the error in each query to make it run, AND runs properly!

-- DON'T LOOK AT PREVIOUS WARMUPS! TRY TO DO ON YOUR OWN.

-- hint: Try to run parts of the query to see if they run at all. And don't 
-- forget to check the error message. They ARE actually helpful sometimes.


-- hint: 3 kinds of errors, all in the CASE WHEN STATEMENT
WITH with_holidays AS (
SELECT title, description, rental_rate,
	CASE
	WHEN title LIKE halloween OR description LIKE halloween THEN Halloween 
	WHEN title LIKE christmas OR description LIKE christmas THEN Christmas 
	WHEN title LIKE valentine OR description LIKE valentine THEN Valentines_Day 
	ELSE '' 
FROM film
ORDER BY holiday DESC, title)
SELECT *,
	CASE
	WHEN holiday = '' THEN rental_rate
	ELSE ROUND(rental_rate/2, 2)
	END as promo
FROM with_holidays;

-- FIX

WITH with_holidays AS (
SELECT title, description, rental_rate,
	CASE
	-- Missing single quotes, wildcards, and ILIKE fo case insensitivity
	WHEN title ILIKE '%halloween%' OR description ILIKE '%halloween%' THEN 'Halloween'
	WHEN title ILIKE '%christmas%' OR description ILIKE '%christmas%' THEN 'Christmas' 
	WHEN title ILIKE '%valentine%' OR description ILIKE '%valentine%' THEN 'Valentines_Day'
	ELSE '' 
	-- Missing end statement and alias
	END as holiday
FROM film
ORDER BY holiday DESC, title)
SELECT *,
	CASE
	WHEN holiday = '' THEN rental_rate
	ELSE ROUND(rental_rate/2, 2)
	END as promo
FROM with_holidays;

-----------------------------------


--hint: 4 errors total
WITH lowest_rate AS (
SELECT DISTINCT rental_rate
FROM film
ORDER by rental_rate
LIMIT 1
)
rate_next_above_1 AS (
SELECT DISTINCT rental_rate
FROM film
WHERE rental_rate > 1
ORDER by rental_rate
LIMIT 1
)

SELECT title, rental_rate,
	CASE
	WHEN rental_rate = (SELECT FROM lowest_rate) THEN 0.10 
	WHEN rental_rate = (SELECT FROM rate_next_above_1) THEN 1 
	END AS new_rate
FROM film
WHERE rating = 'PG-13';


-- FIX

WITH lowest_rate AS (
SELECT DISTINCT rental_rate
FROM film
ORDER by rental_rate
LIMIT 1
)
-- Missing comma
,rate_next_above_1 AS (
SELECT DISTINCT rental_rate
FROM film
WHERE rental_rate > 1
ORDER by rental_rate
LIMIT 1
)

SELECT title, rental_rate,
	CASE
-- Missing anything in the SELECT for the subqueries
	WHEN rental_rate = (SELECT * FROM lowest_rate) THEN 0.10 
	WHEN rental_rate = (SELECT * FROM rate_next_above_1) THEN 1 
-- If the $4.99 price is supposed to be in the new_rate, need 'ELSE rental_rate'
	END AS new_rate
FROM film
WHERE rating = 'PG-13';

---------------------------

-- hint: 3 errors
WITH top_actor AS (
SELECT a.actor_id, COUNT(*)
FROM film_actor as fa
	JOIN film as f ON fa.film_id=f.film_id
	JOIN actor as a ON fa.actor_id=a.actor_id
GROUP BY a.actor_id
ORDER BY COUNT(*) DESC) 
,
films_list AS (
SELECT f.film_id, fa.actor_id
FROM film as f
JOIN film_actor as fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id FROM top_actor)
)

SELECT DISTINCT fa.actor_id, a.first_name + a.last_name as name -- || ' ' ||
FROM film as f
	JOIN film_actor as fa ON f.film_id=fa.film_id
	JOIN actor as a ON a.actor_id=fa.actor_id
WHERE f.film_id IN (SELECT film_id FROM films_list) AND
WHERE fa.actor_id != (SELECT actor_id FROM top_actor); 
  
 
-- FIX

WITH top_actor AS (
SELECT a.actor_id, COUNT(*)
FROM film_actor as fa
	JOIN film as f ON fa.film_id=f.film_id
	JOIN actor as a ON fa.actor_id=a.actor_id
GROUP BY a.actor_id
ORDER BY COUNT(*) DESC
--Adding a limit to get one result
LIMIT 1) 
,
films_list AS (
SELECT f.film_id, fa.actor_id
FROM film as f
JOIN film_actor as fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id FROM top_actor)
)

SELECT DISTINCT fa.actor_id, CONCAT(a.first_name, ' ', a.last_name) as name 
-- Fixed combination of first and last name
FROM film as f
	JOIN film_actor as fa ON f.film_id=fa.film_id
	JOIN actor as a ON a.actor_id=fa.actor_id
WHERE f.film_id IN (SELECT film_id FROM films_list) AND
-- Took out extra WHERE
      fa.actor_id != (SELECT actor_id FROM top_actor); 

---------------------------
---------------------------
---------------------------

-- BONUS ROUND! Go through again, this time there's new errors!
-- hint: 3 errors
WITH with_holidays AS (
SELECT title, description, rental_rate 
	CASE
	WHEN titel ILIKE '%halloween%' OR description ILIKE '%halloween%' THEN 'Halloween' 
	WHEN title ILIKE '%christmas%' OR description ILIKE '%christmas%' THEN 'Christmas'
	WHEN title ILIKE '%valentine%' OR description ILIKE '%valentine%' THEN 'Valentines Day'
	ELSE ''
	END 
FROM film
ORDER BY holiday DESC, title)
SELECT *,
	CASE
	WHEN holiday = '' THEN rental_rate
	ELSE ROUND(rental_rate/2, 2)
	END as promo
FROM with_holidays;

-- FIX

WITH with_holidays AS (
SELECT title, description, rental_rate 
-- Added comma after rental_rate
	,CASE
-- Fixed typo of "title"
	WHEN title ILIKE '%halloween%' OR description ILIKE '%halloween%' THEN 'Halloween' 
	WHEN title ILIKE '%christmas%' OR description ILIKE '%christmas%' THEN 'Christmas'
	WHEN title ILIKE '%valentine%' OR description ILIKE '%valentine%' THEN 'Valentines Day'
	ELSE ''
	END as holiday
-- Added alias for CASE WHEN
FROM film
ORDER BY holiday DESC, title)
SELECT *,
	CASE
	WHEN holiday = '' THEN rental_rate
	ELSE ROUND(rental_rate/2, 2)
	END as promo
FROM with_holidays;

---------------------------

--hint: 3 types of errors (4 errors total)
WITH lowest_rate AS (
SELECT DISTINCT rental_rate
FROM film
ORDER by rental_rate
LIMIT 1
)
, rate_next_above_1 AS (
SELECT DISTINCT rental_rate
FROM film
HAVING rental_rate > 1 
ORDER by rental_rate
LIMIT 1
)

SELECT title, rental_rate,
	CASE
	WHERE rental_rate = (SELECT * FROM lowest_rate) THEN 0.10 
	WHERE rental_rate = (SELECT * FROM rate_next_above_1) THEN 1 
	ELSE rental_rate
	END AS new_rate
FROM film
WHERE rating IS 'PG-13'; 


-- FIX

WITH lowest_rate AS (
SELECT DISTINCT rental_rate
FROM film
ORDER by rental_rate
LIMIT 1
)
, rate_next_above_1 AS (
SELECT DISTINCT rental_rate
FROM film
-- Added GROUP BY
GROUP BY rental_rate
HAVING rental_rate > 1 
ORDER by rental_rate
LIMIT 1
)

SELECT title, rental_rate,
	CASE
-- Changed WHEREs to WHENs
	WHEN rental_rate = (SELECT * FROM lowest_rate) THEN 0.10 
	WHEN rental_rate = (SELECT * FROM rate_next_above_1) THEN 1 
	ELSE rental_rate
	END AS new_rate
FROM film
-- Used an = instead of "is"
WHERE rating = 'PG-13'; 


---------------------------


--hint: 3 errors, 2 are the same type
WITH top_actor AS (
SELECT a.actor_id, COUNT(*)
FROM film_actor as fa
	JOIN film as f ON fa.film_id=f.film_id
	JOIN actor as a ON fa.actor_id=a.actor_id
ORDER BY COUNT(*) DESC
GROUP BY a.actor_id  
LIMIT 1)
,
films_list AS (
SELECT f.film_id, fa.actor_id
FROM film as f
JOIN film_actor as fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id FROM top_actor)
)

SELECT DISTINCT fa.actor_id, a.first_name||' '||a.last_name as name
FROM film as f
	JOIN film_actor as fa 
	JOIN actor as a 
WHERE f.film_id IN (SELECT film_id FROM films_list) AND
	fa.actor_id != (SELECT actor_id FROM top_actor);

-- FIX

WITH top_actor AS (
SELECT a.actor_id, COUNT(*)
FROM film_actor as fa
	JOIN film as f ON fa.film_id=f.film_id
	JOIN actor as a ON fa.actor_id=a.actor_id
GROUP BY a.actor_id 
-- Switched order of GROUP BY and ORDER BY
ORDER BY COUNT(*) DESC 
LIMIT 1)
,
films_list AS (
SELECT f.film_id, fa.actor_id
FROM film as f
JOIN film_actor as fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id FROM top_actor)
)

SELECT DISTINCT fa.actor_id, a.first_name||' '||a.last_name as name
FROM film as f
-- Added ON statements for both JOINs
	JOIN film_actor as fa ON f.film_id=fa.film_id
	JOIN actor as a ON a.actor_id=fa.actor_id
WHERE f.film_id IN (SELECT film_id FROM films_list) AND
	fa.actor_id != (SELECT actor_id FROM top_actor);