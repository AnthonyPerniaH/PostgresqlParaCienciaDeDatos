SELECT A.pelicula_id,
        B.tipo_cambio_id,
        B.cambio_usd * A.precio_renta AS precio_mxn
FROM peliculas AS A,
        tipos_cambio AS B
WHERE B.codigo = 'MXN';

-------------------HACIENDOLO TRIGGER

CREATE OR REPLACE FUNCTION precio_peliculas_tipo_cambio()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $BODY$
BEGIN
    INSERT INTO precio_peliculas_tipo_cambio(
        pelicula_id,
        tipo_cambio_id,
        precio_tipo_cambio,
        ultima_actualizacion
    )

    SELECT NEW.pelicula_id,
        B.tipo_cambio_id,
        B.cambio_usd * NEW.precio_renta AS precio_mxn,
        CURRENT_TIMESTAMP
    FROM tipos_cambio AS B
    WHERE B.codigo = 'MXN';
    RETURN NEW;
END
$BODY$;

CREATE TRIGGER trigger_update_tipo_cambio
    AFTER INSERT OR UPDATE
    ON public.peliculas
    FOR EACH ROW
    EXECUTE PROCEDURE public.precio_peliculas_tipo_cambio();


-----probando
--hago update a ver
UPDATE peliculas
SET precio_renta=5.99
WHERE pelicula_id=98;