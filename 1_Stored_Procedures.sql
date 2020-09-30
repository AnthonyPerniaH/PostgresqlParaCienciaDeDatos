--CON SQL
CREATE OR REPLACE PROCEDURE test_drpcreate_procedure()
LANGUAGE SQL
AS $$
    DROP TABLE IF EXISTS aaa;
    CREATE TABLE aaa (bbb CHAR(5) CONSTRAINT firstkey PRIMARY KEY);
$$;

--llamandola
CALL test_drpcreate_procedure();


---CON PLPGSQL
CREATE OR REPLACE FUNCTION test_dropcreate_function()
RETURNS VOID
LANGUAGE PLPGSQL
AS $$
BEGIN
    DROP TABLE IF EXISTS aaa;
    CREATE TABLE aaa (bbb CHAR(5) CONSTRAINT firstkey PRIMARY KEY, ccc char(5));
    DROP TABLE IF EXISTS aab;
    CREATE TABLE aab (bba CHAR(5) CONSTRAINT secondkey PRIMARY KEY, cca char(5));
END
$$;

--llamandola
SELECT test_dropcreate_function();