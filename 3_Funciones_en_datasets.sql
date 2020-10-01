CREATE OR REPLACE FUNCTION movies_stats()
RETURNS VOID
LANGUAGE PLPGSQL
AS $$
DECLARE 
    total_rated_r REAL:=  0.0;
    total_larger_thank_100 REAL := 0.0;
    total_published_2006 REAL := 0.0;
    average_duration REAL := 0.0;
    average_rental_price REAL := 0.0;
BEGIN
    total_rated_r := COUNT(*) FROM peliculas WHERE clasificacion = 'R';
    total_larger_thank_100 := COUNT(*) FROM peliculas WHERE duracion > 100;
    total_published_2006 := COUNT(*) FROM peliculas WHERE anio_publicacion = 2006;
    average_duration := AVG(duracion) FROM peliculas;
    average_rental_price := AVG(precio_renta) FROM peliculas;

    TRUNCATE TABLE peliculas_estadisticas;

    INSERT INTO peliculas_estadisticas(tipo_estadistica, total)
    VALUES 
        ('Peliculas con clasificacion R', total_rated_r),
        ('Peliculas de mas de 100 minutos', total_larger_thank_100),
        ('Peliculas publicadas en 2006', total_published_2006),
        ('Promedio de duracion', average_duration),
        ('Promedio de renta', average_rental_price);

END
$$;

SELECT movies_stats();