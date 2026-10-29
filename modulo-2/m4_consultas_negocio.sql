-- =================================================
-- Consulta 1 — Resumen ejecutivo mensual 
-- =================================================
SELECT 
	MONTH(fecha_venta) AS mes,
	SUM(cantidad * precio_unitario) AS total_facturado,
	COUNT(*) AS pedidos,
	AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);


-- =================================================
-- Consulta 2 — Ranking de productos
-- =================================================
SELECT TOP 5
	id_producto,
	SUM(cantidad) AS unidades_vendidas,
	SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY SUM(cantidad * precio_unitario) DESC;

-- =================================================
-- Consulta 3 — Clientes recurrentes
-- =================================================

SELECT 
	id_cliente,
	COUNT(*) AS total_ventas,
	SUM(cantidad * precio_unitario) AS total_gasto
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- =================================================
-- Consulta 4 — Meses por encima/por debajo del promedio
-- =================================================
--Tabla Temporal
;WITH ventas_mensuales AS (
    SELECT 
        YEAR(fecha_venta) AS anio,
        MONTH(fecha_venta) AS mes, 
        SUM(cantidad * precio_unitario) AS facturacion 
    FROM ventas 
    GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
-- Comparacion
SELECT anio, mes, facturacion,               
  CASE WHEN facturacion >= (SELECT AVG(facturacion) FROM ventas_mensuales)
       THEN 'Por encima' ELSE 'Por debajo'
  END AS evaluacion_promedio
FROM ventas_mensuales
ORDER BY anio, mes;

-- Hallazgos:
-- El producto 1 lidera la facturación con $3.600, casi el 56% de los ingresos.
-- El producto 2 fue el que mas vendio con 13 unidades con $364 de ingresos. Es un posible producto ancla.
-- Los clientes 1 y 3 representan el 73.5% de los ingresos del mes, podrian considerarse VIP y merecen seguimiento.
