
-- CREANDO PL
DO $$
DECLARE
    rec record;
    contador INTEGER := 0 ;
BEGIN
    FOR rec IN SELECT * FROM PERSONA LOOP
        RAISE NOTICE 'UN PASAJERO SE LLAMA %', rec.nombre;
        contador := contador + 1 ;
    END LOOP;
    RAISE NOTICE 'el conteo fue %', contador;
END
$$

---- HACIENDOLO FUNCION

CREATE FUNCTION ImportantePL()
RETURNS VOID
AS  $$
DECLARE
    rec record;
    contador INTEGER := 0 ;
BEGIN
    FOR rec IN SELECT * FROM PERSONA LOOP
        RAISE NOTICE 'UN PASAJERO SE LLAMA %', rec.nombre;
        contador := contador + 1 ;
    END LOOP;
    RAISE NOTICE 'el conteo fue %', contador;
END
$$
LANGUAGE PLPGSQL;

-- LLAMANDOLA 
SELECT ImportantePL();

--------Que devuelva algo la funcion y odenando
-- BORRAMOS LA ANTERIOR
DROP FUNCTION ImportantePL();
CREATE OR REPLACE FUNCTION ImportantePL()
RETURNS INTEGER
AS  
$BODY$ --aca puedes poner lo que quierdas
DECLARE
    rec record;
    contador INTEGER := 0 ;
BEGIN
    FOR rec IN SELECT * FROM PERSONA LOOP
        RAISE NOTICE 'UN PASAJERO SE LLAMA %', rec.nombre;
        contador := contador + 1 ;
    END LOOP;
    RAISE NOTICE 'el conteo fue %', contador;
    RETURN contador;
END
$BODY$ -- solo es para señalar
LANGUAGE PLPGSQL;

---------------

CREATE TABLE cont_pasajero
(
    total INTEGER,
    tiempo TIMESTAMP,
    id SERIAL,
    PRIMARY KEY (id)
);

--------------- modificando la funcion para que haga insert
DROP FUNCTION ImportantePL();
CREATE OR REPLACE FUNCTION ImportantePL()
RETURNS INTEGER
AS  
$BODY$ --aca puedes poner lo que quierdas
DECLARE
    rec record;
    contador INTEGER := 0 ;
BEGIN
    FOR rec IN SELECT * FROM PERSONA LOOP
        RAISE NOTICE 'UN PASAJERO SE LLAMA %', rec.nombre;
        contador := contador + 1 ;
    END LOOP;
    INSERT INTO cont_pasajero (total, tiempo)
    VALUES (contador, now());
    RETURN contador;
END
$BODY$ -- solo es para señalar
LANGUAGE PLPGSQL;

-------
DELETE FROM PERSONA WHERE ID IN (1,3,5);

-------------- usando trigger

DROP FUNCTION ImportantePL();
CREATE OR REPLACE FUNCTION ImportantePL()
RETURNS TRIGGER
AS  
$BODY$ --aca puedes poner lo que quierdas
DECLARE
    rec record;
    contador INTEGER := 0 ;
BEGIN
    FOR rec IN SELECT * FROM PERSONA LOOP
        contador := contador + 1 ;
    END LOOP;
    INSERT INTO cont_pasajero (total, tiempo)
    VALUES (contador, now());
    RETURN NEW; 
END
$BODY$ -- solo es para señalar
LANGUAGE PLPGSQL;

---------------- CREANDO TRIGGER
DROP TRIGGER mitrigger;
CREATE TRIGGER mitrigger
AFTER INSERT 
ON persona
FOR EACH ROW
EXECUTE PROCEDURE ImportantePL();

--------- probando el trigger
INSERT INTO persona VALUES (55, 'ANtoryyyyy','otrooossssso', '1995-09-12');

----------------
CREATE DATABASE remota;
\c remota;
CREATE TABLE vip
(
    id INTEGER,
    fecha TIMESTAMP
);

INSERT INTO vip VALUES (55, now());
INSERT INTO vip VALUES (10, now());
INSERT INTO vip VALUES (11, now());

\c postgres;

CREATE EXTENSION dblink;
----- ALTER USER postgres PASSWORD 'xxxxxx';
-------------- accediendo a la remota con dblink y probando
SELECT * FROM 
dblink('dbname = remota
        port = 5432
        host = 127.0.0.1
        user=postgres
        password=cualquiera',
        'SELECT id,fecha FROM vip'
) AS datos_remotos (id INTEGER, fecha DATE);
-------------- join desde la remota 
SELECT * FROM persona AS A 
INNER JOIN
dblink('dbname = remota
        port = 5432
        host = 127.0.0.1
        user=postgres
        password=cualquiera',
        'SELECT id,fecha FROM vip'
) AS datos_remotos (id INTEGER, fecha DATE)
ON (A.id = datos_remotos.id);
----------- o asi (las dos funcan)
SELECT * FROM persona AS A 
INNER JOIN
dblink('dbname = remota
        port = 5432
        host = 127.0.0.1
        user=postgres
        password=cualquiera',
        'SELECT id,fecha FROM vip'
) AS datos_remotos (id INTEGER, fecha DATE)
USING(id);
---------------- con left
SELECT * FROM persona AS A 
left JOIN
dblink('dbname = remota
        port = 5432
        host = 127.0.0.1
        user=postgres
        password=cualquiera',
        'SELECT id,fecha FROM vip'
) AS datos_remotos (id INTEGER, fecha DATE)
USING(id);

---------- Transacciones
\set AUTOCOMMIT off ;---DESACTIVO EL AUTOCOMMIT
------------

BEGIN;
insert into estacion (id, nombre, direccion) 
values (99, 'obelisco', 'corrientes 1000');
insert into estacion (id, nombre, direccion) 
values (98, 'lavalle', 'lavalle 700');
--commit;

----probando una con fallas 

BEGIN;
insert into estacion (id, nombre, direccion) 
values (95, 'otra', 'otra 1000');
insert into estacion (id, nombre, direccion) 
values (98, 'repetida1', 'calle repetida 700');
COMMIT;

----------------- EXTENSIONES 
--fuzzy
CREATE EXTENSION fuzzystrmatch;
--LA SIGUIENTE FUNCION ME INDICA LA DIFERENCIA EN LETRAS EN ESAS DOS PORCIONES DE TEXTO
SELECT levenshtein('anthony', 'antoni');
-- esta nos dice que tan diferentes son las palabras en un rango de 0 a 4
SELECT DIFFERENCE ('anthony', 'anthony');
SELECT DIFFERENCE ('anthony', 'antho');
SELECT DIFFERENCE ('bear', 'beer');

