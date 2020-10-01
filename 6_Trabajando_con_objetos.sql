CREATE TABLE ordenes(ID SERIAL NOT NULL PRIMARY KEY,info JSON NOT NULL);


INSERT INTO ordenes(info)
VALUES 
('{"cliente":"David Sanchez", "items":{"producto":"Biberon","cantidad":"24"}}'), 
('{"cliente":"Edna Cardenas", "items":{"producto":"Carro juguete","cantidad":"1"}}')

, 
('{"cliente":"Anthony Pernia", "items":{"producto":"Consolas","cantidad":"2"}}')

--aca los trae en json, pero seleccionado el valor de la clave
--con una sola, te sigue trayendo un json, es decir, sirve para cuando es un json dentro de otro
SELECT 
    info -> 'cliente' AS cliente
FROM ordenes;

--aca los trae como string ya , los muestra como cualquier texto
SELECT 
    info ->> 'cliente' AS cliente
FROM ordenes;

SELECT
    info ->> 'cliente' AS cliente
FROM ordenes
WHERE info -> 'items' ->> 'producto' = 'Consolas';

SELECT
    MIN(
        CAST(
            info -> 'items' ->> 'cantidad' AS INTEGER
        )
    )
FROM ordenes;

SELECT
    MAX(
        CAST(
            info -> 'items' ->> 'cantidad' AS INTEGER
        )
    ),
    MIN(
        CAST(
            info -> 'items' ->> 'cantidad' AS INTEGER
        )
    ),
    SUM(
        CAST(
            info -> 'items' ->> 'cantidad' AS INTEGER
        )
    ),
    AVG(
        CAST(
            info -> 'items' ->> 'cantidad' AS INTEGER
        )
    )
FROM ordenes;