CREATE TYPE humor as ENUM ('triste', 'normal', 'feliz');

CREATE TABLE persona_prueba(
    nombre text,
    humor_actual humor
);

INSERT INTO persona_prueba VALUES ('anthony', 'feliz'); 
--el dato tiene que estar en la lista anterior