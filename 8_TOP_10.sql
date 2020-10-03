
SELECT 
    peliculas.pelicula_id as ID ,
    peliculas.titulo,
    count(*) as numero_rentas,
    ROW_NUMBER() OVER(
        ORDER BY count(*) DESC
    ) AS lugar
FROM rentas
    INNER JOIN inventarios ON rentas.inventario_id = inventarios.inventario_id
    INNER JOIN peliculas ON inventarios.pelicula_id = peliculas.pelicula_id
GROUP by ID
ORDER BY numero_rentas DESC
LIMIT 10;
