SELECT	    MONTHNAME(fecha_publicacion) AS post_month, estatus, COUNT(*) AS post_quantity
FROM	    posts
WHERE       post_quantity > 1
GROUP BY    estatus, post_month
ORDER BY    post_month;

SELECT      MAX(ultima_actualizacion) AS fecha_ultima_actualizacion, clasificacion, COUNT(*) AS post_quantity
FROM        peliculas
WHERE       duracion_renta > 3
GROUP BY    clasificacion, ultima_actualizacion
ORDER BY    fecha_ultima_actualizacion;