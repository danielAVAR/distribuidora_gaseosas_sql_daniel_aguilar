

USE gaseosas_del_valle;


DROP VIEW IF EXISTS vista_resumen_pedidos_por_sede;

CREATE VIEW vista_resumen_pedidos_por_sede AS
SELECT
    se.id_sede,
    se.nombre_sede,
    COUNT(p.id_pedido)        AS total_pedidos,
    IFNULL(SUM(p.total_con_iva), 0) AS total_ventas
FROM sedes se
LEFT JOIN pedidos p ON se.id_sede = p.id_sede
GROUP BY se.id_sede, se.nombre_sede;

DROP VIEW IF EXISTS vista_productos_bajo_stock;

CREATE VIEW vista_productos_bajo_stock AS
SELECT
    id_producto,
    nombre,
    categoria,
    stock_actual,
    stock_minimo
FROM productos
WHERE stock_actual <= stock_minimo;

-- Uso: SELECT * FROM vista_productos_bajo_stock;

DROP VIEW IF EXISTS vista_clientes_activos;

CREATE VIEW vista_clientes_activos AS
SELECT
    c.id_cliente,
    c.nombre_completo,
    c.correo_electronico,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.correo_electronico;


SELECT id_producto, nombre, categoria, stock_actual, stock_minimo
FROM productos
WHERE stock_actual <= stock_minimo;


SELECT id_pedido, fecha_pedido, id_cliente, id_sede, total_con_iva
FROM pedidos
WHERE fecha_pedido BETWEEN '2026-01-01' AND '2026-02-28';

SELECT
    pr.id_producto,
    pr.nombre,
    SUM(dp.cantidad) AS total_unidades_vendidas
FROM detalle_pedido dp
INNER JOIN productos pr ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre
ORDER BY total_unidades_vendidas DESC;


SELECT
    c.id_cliente,
    c.nombre_completo,
    COUNT(p.id_pedido) AS cantidad_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY cantidad_pedidos DESC;


SELECT id_cliente, nombre_completo, telefono, correo_electronico
FROM clientes
WHERE nombre_completo LIKE '%García%';


SELECT id_producto, nombre, categoria, precio
FROM productos
WHERE categoria IN ('Gaseosa', 'Agua', 'Jugo');


SELECT c.id_cliente, c.nombre_completo, COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
HAVING COUNT(p.id_pedido) = (
    SELECT MAX(cantidad_pedidos)
    FROM (
        SELECT COUNT(id_pedido) AS cantidad_pedidos
        FROM pedidos
        GROUP BY id_cliente
    ) AS conteo
);


    se.id_sede,
    se.nombre_sede,
    COUNT(p.id_pedido)      AS total_pedidos,
    SUM(p.total_sin_iva)    AS total_sin_iva,
    SUM(p.total_con_iva)    AS total_con_iva
FROM sedes se
INNER JOIN pedidos p ON se.id_sede = p.id_sede
GROUP BY se.id_sede, se.nombre_sede
ORDER BY total_con_iva DESC;