-- 1. Selecciona todos los clientes.
SELECT *
from clientes;

-- 2. Selecciona todos los empleados.
SELECT *
from empleados;

-- 3. Selecciona todas las tiendas.
SELECT *
from tiendas;

-- 4. Selecciona todas las prendas de ropa.
SELECT *
FROM prendas;

-- 5. Busca clientes cuyo nombre comience con la letra "L".
SELECT *
FROM clientes
WHERE nombre_cliente like "L%";

-- 6. Cuenta cuántos clientes hay en la base de datos.
SELECT count(*) as numero_clientes
From clientes;

-- 7. Selecciona las compras realizadas después del 1 de mayo de 2023.
SELECT *
from compras
where fecha_compra > "2023/05/01";

-- 8. Actualiza el correo electrónico de un cliente específico.
UPDATE clientes
SET email_cliente = "cramirez@gmail.com"
where id_cliente = 1;

-- 9. Elimina un cliente por su ID.
DELETE FROM clientes
where id_cliente = 2;

-- 10. Selecciona las prendas de color Negro.
SELECT *
from prendas
where color = "Negro";

-- 11. Selecciona todas las tiendas que hay en Madrid.
SELECT *
FROM tiendas
where ciudad = "Madrid";

-- 12. Cuenta cuántas prendas tienen un precio mayor a 50.
SELECT *
FROM prendas
where precio >50;

-- 13. Selecciona los empleados que trabajan en la tienda con ID 1.
SELECT *
from empleados
where tienda_id = "1";

-- 14. Busca clientes cuyo nombre contenga "Andrés".
SELECT *
from clientes
WHERE nombre_cliente like "%Andrés%";

-- 15. Selecciona las compras realizadas por el cliente con ID 2.
SELECT *
from compras
where id_cliente = 2;

-- 16. Elimina todas las compras cuyo monto sea menor a 30.
DELETE FROM compras
where monto_total <30;

-- 17. Selecciona las prendas cuyo precio esté entre 20 y 40.
SELECT *
FROM prendas
where precio between 20 and 40;

-- 18. Busca empleados cuyo nombre contenga la letra "a".
SELECT *
FROM empleados
where nombre_empleado like "%a%";

-- 19. Selecciona las 5 prendas más caras.
SELECT *
FROM PRENDAS
ORDER BY precio DESC
LIMIT 5;

-- 20. Selecciona las compras de un cliente con un monto superior a 75.
SELECT *
FROM COMPRAS
where monto_total >75
LIMIT 1;

-- 21. Selecciona las prendas de talla M.
SELECT *
FROM prendas
where talla = "M";

-- 22. Actualiza la talla de una prenda específica por su ID.
UPDATE prendas
SET talla = "M"
where id_prenda = 2;

-- 23. Selecciona todos los empleados contratados después del 1 de enero de 2022.
SELECT *
from empleados
where fecha_contratacion > "2022/01/01";

-- 24. Busca tiendas en "Barcelona".
SELECT *
from tiendas
where ciudad = "Barcelona";

-- 25. Elimina un empleado por su ID.
DELETE FROM empleados
where id_empleado = 1;

-- 26. Selecciona las compras que se realizaron antes del 1 de julio de 2023.
SELECT *
FROM COMPRAS
WHERE FECHA_COMPRA < 2023/07/01;

-- 27. Busca prendas cuyo nombre termine en "eta".
SELECT * 
FROM PRENDAS
WHERE tipo_prenda like "%eta%";

-- 28. Selecciona los clientes que no tengan un email registrado con "hotmail".
SELECT *
FROM CLIENTES
WHERE email_cliente not like "%hotmail%";

-- 29. Cuenta cuántas compras se realizaron en septiembre de 2023.
select *
FROM COMPRAS
WHERE fecha_compra like "%09%";
-- 30. Actualiza la dirección de una tienda por su ID.
UPDATE tiendas
SET direccion = "canada"
where id_tienda = 1;

-- 31. Selecciona las prendas que sean camisetas.
SELECT *
FROM prendas
where tipo_prenda = "Camiseta";

-- 32. Elimina todas las prendas cuyo precio sea menor a 20.
DELETE FROM prendas
where precio <20;

-- 33. Selecciona todas las tiendas y ordénalas por ciudad.
select *
from tiendas
order by ciudad;

-- 34. Selecciona los empleados que sean vendedores.
select *
from empleados
where puesto = "Vendedor";

-- 35. Cuenta cuántas prendas son de color blanco.
select *
from prendas
where color = "Blanco";

-- 36. Selecciona los clientes que tengan nombres de más de 10 caracteres.
select *
from clientes
where length(nombre_cliente) > 10;

-- 37. Busca compras cuyo monto total esté entre 50 y 100.
select * 
from compras
where monto_total between 50 and 100;

-- 38. Selecciona las 3 compras más recientes.
SELECT * 
FROM compras 
order by fecha_compra desc
limit 3;

-- 39. Busca cursos cuyo nombre contenga la palabra "Digital".

-- 40. Agrupa las prendas por color y cuenta cuántas hay de cada color.
select color, count(*) as cantidad
from prendas
group by color;

-- 41. Añade dos tiendas más que existan en Madrid y no estén en la base de datos.
INSERT INTO tienda (nombre_tienda, ciudad, direccion)
VALUES
('Zara nuevo 1', 'Madrid', 'Calle Mayor, 25'),
('Zara nuevo 2', 'Madrid', 'Calle Bravo Murillo, 80');
-- 42. El cliente Miguel Torres se ha hecho trans y ha pedido que le cambien el nombre a Micaela. Actualiza también su e-mail.
UPDATE clientes
SET nombre_cliente = 'Micaela Torres',
email_cliente = 'micaela.torres@gmail.com'
WHERE nombre_cliente = 'Miguel Torres';