PREGUNTAS 
-- 1) ¿Cuál es la cantidad total que gastó cada cliente en el restaurante? 
SELECT
    s.customer_id,
    SUM(m.price) AS total_gastado
FROM sales AS s
INNER JOIN menu AS m
    ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2) ¿Cuántos días ha visitado cada cliente el restaurante? 
SELECT
    customer_id,
    COUNT(DISTINCT order_date) AS dias_visitados
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

-- 3) ¿Cuál fue el primer artículo del menú comprado por cada cliente? 
SELECT DISTINCT
    s.customer_id,
    s.order_date,
    m.product_name
FROM sales AS s
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date = (
    SELECT MIN(s2.order_date)
    FROM sales AS s2
    WHERE s2.customer_id = s.customer_id
)
ORDER BY s.customer_id, m.product_name;

-- 4) ¿Cuál es el artículo más comprado en el menú y cuántas veces lo compraron todos los clientes? 
SELECT
    m.product_name,
    COUNT(*) AS veces_comprado
FROM sales AS s
INNER JOIN menu AS m
    ON s.product_id = m.product_id
GROUP BY m.product_id, m.product_name
ORDER BY veces_comprado DESC
LIMIT 1;

-- 5) ¿Qué artículo fue el más popular para cada cliente? 
WITH compras_cliente AS (
    SELECT
        s.customer_id,
        m.product_name,
        COUNT(*) AS veces_comprado
    FROM sales AS s
    INNER JOIN menu AS m
        ON s.product_id = m.product_id
    GROUP BY
        s.customer_id,
        m.product_id,
        m.product_name
),
ranking_productos AS (
    SELECT
        customer_id,
        product_name,
        veces_comprado,
        DENSE_RANK() OVER (
            PARTITION BY customer_id
            ORDER BY veces_comprado DESC
        ) AS posicion
    FROM compras_cliente
)
SELECT
    customer_id,
    product_name,
    veces_comprado
FROM ranking_productos
WHERE posicion = 1
ORDER BY customer_id, product_name;

-- 6) ¿Qué artículo compró primero el cliente después de convertirse en miembro? 
SELECT DISTINCT
    s.customer_id,
    s.order_date,
    m.product_name
FROM sales AS s
INNER JOIN members AS mb
    ON s.customer_id = mb.customer_id
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date = (
    SELECT MIN(s2.order_date)
    FROM sales AS s2
    WHERE s2.customer_id = s.customer_id
      AND s2.order_date >= mb.join_date
)
ORDER BY s.customer_id;


-- 7) --¿Qué artículo se compró justo antes de que el cliente se convirtiera en miembro? 
SELECT DISTINCT
    s.customer_id,
    s.order_date,
    m.product_name
FROM sales AS s
INNER JOIN members AS mb
    ON s.customer_id = mb.customer_id
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date = (
    SELECT MAX(s2.order_date)
    FROM sales AS s2
    WHERE s2.customer_id = s.customer_id
      AND s2.order_date < mb.join_date
)
ORDER BY s.customer_id, m.product_name;

-- 8) ¿Cuál es el total de artículos y la cantidad gastada por cada miembro antes de convertirse en miembro? 
SELECT
    s.customer_id,
    COUNT(*) AS total_articulos,
    SUM(m.price) AS total_gastado
FROM sales AS s
INNER JOIN members AS mb
    ON s.customer_id = mb.customer_id
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 9) Si cada $ 1 gastado equivale a 10 puntos y el sushi tiene un multiplicador de puntos 2x, ¿cuántos puntos tendría cada cliente? 
SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN m.product_name = 'sushi'
                THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_puntos
FROM sales AS s
INNER JOIN members AS mb
    ON s.customer_id = mb.customer_id
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date >= mb.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

Suposición: Solo los clientes que son miembros reciben puntos al comprar artículos, los puntos los reciben en las ordenes iguales o posteriores a la fecha en la que se convierten en 
miembros.  
-- 10) En la primera semana después de que un cliente se une al programa (incluida la fecha de ingreso), gana el doble de puntos en todos los artículos, no solo en sushi. ¿Cuántos puntos tienen los clientes A y B a fines de enero? 
SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN s.order_date BETWEEN mb.join_date
                                 AND DATE_ADD(mb.join_date, INTERVAL 6 DAY)
                THEN m.price * 20
            WHEN m.product_name = 'sushi'
                THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_puntos_enero
FROM sales AS s
INNER JOIN members AS mb
    ON s.customer_id = mb.customer_id
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date >= mb.join_date
  AND s.order_date <= '2021-01-31'
  AND s.customer_id IN ('A', 'B')
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- Suposición: Solo los clientes que son miembros reciben puntos al comprar artículos, los puntos los reciben en las ordenes iguales o posteriores a la fecha en la que se convierten en miembros. Solo las ordenes de la primer semana en la que se convierten en miembros suman 20 puntos para todos los articulos.