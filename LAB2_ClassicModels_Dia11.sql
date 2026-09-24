Ejercicio 3 (Usar subconsultas)

Análisis de compras anuales: Analicemos algunos cálculos avanzados mediante subconsultas. Queremos encontrar el importe promedio del carrito y el total de artículos, desglosados por año y mes. Esto se aplica específicamente a las compras realizadas en los años 2004 y 2005, pero nos interesan los clientes atendidos por empleados de la familia Patterson.
SELECT
    pedidos.anio,
    pedidos.mes,
    ROUND(AVG(pedidos.importe_carrito), 2) AS promedio_carrito,
    SUM(pedidos.total_articulos) AS total_articulos
FROM
(
    SELECT
        o.orderNumber,
        YEAR(o.orderDate) AS anio,
        MONTH(o.orderDate) AS mes,
        SUM(od.quantityOrdered * od.priceEach) AS importe_carrito,
        SUM(od.quantityOrdered) AS total_articulos
    FROM orders AS o
    INNER JOIN orderdetails AS od
        ON o.orderNumber = od.orderNumber
    WHERE YEAR(o.orderDate) IN (2004, 2005)
      AND o.customerNumber IN
      (
          SELECT c.customerNumber
          FROM customers AS c
          WHERE c.salesRepEmployeeNumber IN
          (
              SELECT e.employeeNumber
              FROM employees AS e
              WHERE e.lastName = 'Patterson'
          )
      )
    GROUP BY
        o.orderNumber,
        YEAR(o.orderDate),
        MONTH(o.orderDate)
) AS pedidos
GROUP BY
    pedidos.anio,
    pedidos.mes
ORDER BY
    pedidos.anio,
    pedidos.mes;

SELECT DISTINCT
    o.officeCode,
    o.city,
    o.country
FROM offices o
JOIN employees e
    ON o.officeCode = e.officeCode
JOIN customers c
    ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE c.state IS NULL
   OR c.state = '';