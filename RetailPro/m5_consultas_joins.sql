-- Consulta 1: Vista base del proyecto (INNER JOIN)
SELECT
    v.fecha_venta,
    v.id_cliente,
    c.nombre,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria;

    -- La ciudad del cliente permite agrupar y filtrar las ventas por ubicación
    -- La categoría permite analizarlas por tipo de producto

-- Consulta 2: Clientes sin ventas (LEFT JOIN)

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
    WHERE v.id_venta IS NULL;

    -- No hay clientes registrados sin compras

    -- Consulta 3: Productos sin ventas (LEFT JOIN)

    SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Los seis productos del catálogo registran ventas
-- Producto no tiene artículos sin movimiento que revisar.

--Reolucion de la consulta 4

WITH ventas_mensuales AS ( -- paso 1: una tabla temporal
SELECT YEAR(fecha_venta) AS anio, MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS facturacion
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
SELECT anio, mes, facturacion, -- paso 2: comparar
CASE WHEN facturacion >= (SELECT AVG(facturacion) FROM ventas_mensuales)
THEN 'Por encima' ELSE 'Por debajo'
END AS evaluacion_promedio
FROM ventas_mensuales
ORDER BY anio, mes;

-- El único mes con ventas por encima del promedio fue marzo de 2024