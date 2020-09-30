--Creando funcion que me devuelva total de peliculas
CREATE OR REPLACE FUNCTION count_total_movies()
RETURNS  INT
LANGUAGE PLPGSQL
AS $$
BEGIN
    RETURN COUNT(*) FROM peliculas;
END
$$;

--llamandola
SELECT count_total_movies();

--CREANDO FUNCION PARA TRIGGER, QUE INSERTE EN UNA TABLA CUANDO INSERTE A OTRA
CREATE OR REPLACE FUNCTION duplicate_records()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
    INSERT INTO aab (bba, cca)
    VALUES (NEW.bbb, NEW.ccc);
    RETURN NEW;
END
$$;
---creando trigger en si 
CREATE TRIGGER aaa_changes
    BEFORE INSERT
    ON aaa
    FOR EACH ROW
    EXECUTE PROCEDURE duplicate_records();

--probando
INSERt INTO aaa(bbb,ccc)
VALUES ('abc','def');