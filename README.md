# Proyecto RetailPro - Data Analytics
 
Repositorio con los entregables y prácticas del módulo de análisis de datos: modelado de una base de ventas de tecnología, consultas SQL de negocio, JOINs y procesos ETL con Power BI.
 
## Modelo de datos (Ventas_Tech_DB)
| Tabla | Descripción |
|---|---|
| `categorias` | Categorías de producto (Computación, Accesorios, Audio, Almacenamiento) |
| `clientes` | Clientes con ciudad y fecha de registro |
| `productos` | Catálogo con precio, stock y categoría (FK a `categorias`) |
| `ventas` | Tabla de hechos: cliente, producto, cantidad, precio unitario y fecha |
 
## Contenido del repositorio
* **`m4_consultas_negocio.sql`**: crea la base `Ventas_Tech_DB`, define las 4 tablas e inserta los datos de ejemplo.
* **`m5_consultas_joins.sql`**: consultas con `INNER JOIN`, `LEFT JOIN` y `UNION ALL` para enriquecer la vista de datos (vista plana, clientes y productos sin ventas, consolidado por canal).
* **`Entregable 3.sql`**: script base de creación de tablas, inserción de datos y consultas iniciales.
 
## Tecnologías utilizadas
* **SQL Server (T-SQL)**: modelado y consultas
* **Power BI / Power Query**: ETL y visualización
 
**Autor:** Matías Nuñez
