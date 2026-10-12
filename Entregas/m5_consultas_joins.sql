-- ==============================================================================
-- Archivo: m5_consultas_joins.sql
-- Base de Datos: Ventas_Tech_DB
-- ==============================================================================

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Cruza la tabla de hechos (ventas) con todas las dimensiones (clientes, productos, categorías)
-- para obtener la vista plana y enriquecida en una sola fila.
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
-- Aísla los registros de clientes que no tienen un id_venta asociado.
SELECT 
    c.nombre, 
    c.email, 
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Aísla los artículos del catálogo que no tuvieron movimiento en la tabla de ventas.
SELECT 
    p.nombre_producto, 
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Genera dos orígenes de datos mediante un valor literal ('Sucursal Mendoza' y 'Envíos Resto del País'), 
-- los une sin eliminar repetidos y cierra con un GROUP BY general.
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