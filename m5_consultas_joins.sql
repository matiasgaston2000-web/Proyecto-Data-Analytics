SELECT 
    MONTH(fecha_venta) AS mes, 
    SUM(cantidad * precio_unitario) AS total_facturado, 
    COUNT(DISTINCT id_venta) AS cantidad_de_pedidos, 
    SUM(cantidad * precio_unitario) / COUNT(DISTINCT id_venta) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta)
ORDER BY 
    mes;
SELECT TOP 5 id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
SELECT id_cliente,
COUNT(*) AS cantidad_de_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING 
COUNT(*) > 1;
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT SUM(cantidad * precio_unitario) / COUNT(DISTINCT MONTH(fecha_venta)) 
            FROM ventas
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta);
    -- HALLAZGOS Y CONCLUSIONES DEL NEGOCIO:
-- 1. Análisis de Productos: El producto con ID [1] lidera ampliamente el ranking, siendo el que más ingresos genera con un total facturado de $3600.
-- 2. Fidelización: Existe una base de clientes recurrentes. Se identificaron 5 clientes que realizaron más de un pedido, destacándose el cliente ID 1 por su alto nivel de gasto.
-- 3. Rendimiento Mensual: El mes de Marzo fue el más exitoso a nivel ventas, superando el promedio general de facturación y logrando el ticket promedio más alto del período.


--ENTREGABLE 5--

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
SELECT 
    v.fecha_venta AS fecha, 
    c.id_cliente AS identificacion_del_cliente,
    c.ciudad AS region,
    p.nombre_producto AS descripcion_del_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad, 
    v.precio_unitario, 
    (v.cantidad * v.precio_unitario) AS total_de_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
SELECT 
    c.nombre, 
    c.email, 
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
SELECT 
    p.nombre_producto, 
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL)
SELECT 
    canal,
    SUM(total) AS total_por_origen
FROM (
    SELECT 
        v.fecha_venta AS fecha, 
        (v.cantidad * v.precio_unitario) AS total, 
        'Sucursal Mendoza' AS canal 
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE c.ciudad = 'Mendoza'
    
    UNION ALL 
    
    SELECT 
        v.fecha_venta AS fecha, 
        (v.cantidad * v.precio_unitario) AS total, 
        'Envíos Resto del País' AS canal 
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    WHERE c.ciudad != 'Mendoza'
) AS consolidado
GROUP BY canal;