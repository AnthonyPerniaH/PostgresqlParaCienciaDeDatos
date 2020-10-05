

-----Geo
SELECT A.ciudad_id,
        A.ciudad,
        COUNT(*) AS rentas_por_ciudad
FROM ciudades AS A
    INNER JOIN direcciones AS B ON A.ciudad_id=B.ciudad_id
    INNER JOIN tiendas AS T ON T.direccion_id=B.direccion_id
    INNER JOIN inventarios AS I ON i.tienda_id=T.tienda_id
    INNER JOIN rentas AS R ON i.inventario_id = r.inventario_id
GROUP BY A.ciudad_id;
------tiempo
SELECT date_part('year', a.fecha_renta) as anio,
        date_part('month',a.fecha_renta) as mes,
        b.titulo,
        count(*) AS numero_rentas
FROM rentas AS a
INNER JOIN inventarios as i on a.inventario_id=i.inventario_id
INNER JOIN peliculas AS b on b.pelicula_id=i.pelicula_id
GROUP BY anio, mes, b.pelicula_id;

SELECT date_part('year', a.fecha_renta) as anio,
        date_part('month',a.fecha_renta) as mes,
        count(*) AS numero_rentas
FROM rentas AS a
GROUP BY anio, mes
ORDER BY anio, mes;
