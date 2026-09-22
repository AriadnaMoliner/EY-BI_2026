SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.customer;

SELECT title
From sakila.film;

SELECT DISTINCT name AS language
from language

select * from store;
SELECT COUNT(*) AS numero_tiendas
FROM store;

select * from staff;
select COUNT(*) as numero_empleados
from staff;

SELECT first_name 
as nombre_empleados
from staff;

SELECT first_name, last_name
from actor
WHERE first_name = "Scarlett";

SELECT first_name, last_name
from actor
where last_name = "Johansson";

SELECT COUNT(*) AS peliculas_disponibles
from film;

SELECT COUNT(*) AS peliculas_alquiladas
from rental;

SELECT
min(rental_duration) as alquiler_mas_corto,
max(rental_duration) as alquiler_mas_largo
from film;

SELECT
min(length) as min_duration,
max(length) as max_duration
from film;

SELECT AVG(length) as duracion_media
from film;

SELECT
FLOOR(AVG(length) / 60) AS horas,
ROUND(AVG(length) % 60) AS minutos
FROM film;

SELECT *
FROM film
where length >= 180

SELECT concat(first_name,".", UPPER(last_name),"-", email) as cliente
from customer;

SELECT title, length
from film
order by length(title) DESC
LIMIT 1;