DROP SCHEMA IF EXISTS turingMachine CASCADE;

DROP TABLE IF EXISTS programa;

DROP TABLE IF EXISTS traza_ejecucion;

DROP TABLE IF EXISTS alfabeto;

CREATE TABLE programa(
    estado_ori varchar(50) NOT NULL,
    caracter_ori varchar(50) NOT NULL,
    estado_nue varchar(50) NOT NULL,
    caracter_nue varchar(50) NOT NULL,
    desplazamiento varchar(50) NOT NULL
);

CREATE TABLE traza_ejecucion(
    traza_id serial PRIMARY KEY,
    estado_ori varchar(50),
    caracter_ori varchar(50),
    estado_nue varchar(50),
    caracter_nue varchar(50),
    desplazamiento varchar(50)
);

CREATE TABLE alfabeto(
    valor char(1) NOT NULL
);

CREATE OR REPLACE FUNCTION simuladorMT(cinta_input varchar(200))
    RETURNS VOID
    AS $$
DECLARE
    prog programa%ROWTYPE;
    t_est varchar(50)
    DEFAULT 'q0';
    cin_long integer;
    i integer := 1;
    counter integer := 1;
    pos integer := 2;
    caracter char(1);
BEGIN
    cinta_input = CONCAT(cinta_input, '_');
    cinta_input = CONCAT('_', cinta_input);
    cin_long := length(cinta_input);
    FOR i IN 1..LENGTH(cinta_input)
    LOOP
        caracter = SUBSTRING(cinta_input FROM i FOR 1);
        IF NOT EXISTS (
            SELECT
                *
            FROM
                alfabeto
            WHERE
                valor = caracter) THEN
        RAISE NOTICE 'El caracter % no pertenece al lenguaje.', caracter;
        RETURN;
    END IF;
END LOOP;
    SELECT
        * INTO prog
    FROM
        programa
    WHERE
        estado_ori = 'q0'
        AND caracter_ori = substring(cinta_input FROM pos FOR 1)
    LIMIT 1;
    WHILE t_est <> 'f'
    AND counter < 200 LOOP
        INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento);
        cinta_input = CONCAT(SUBSTRING(cinta_input FROM 1 FOR pos - 1), prog.caracter_nue, SUBSTRING(cinta_input FROM pos + 1));
        IF prog.estado_ori <> prog.estado_nue AND t_est <> prog.estado_nue THEN
            t_est := prog.estado_nue;
        END IF;
        IF prog.desplazamiento = 'R' THEN
            pos = pos + 1;
        END IF;
        IF prog.desplazamiento = 'L' THEN
            pos = pos - 1;
        END IF;
        counter = counter + 1;
        SELECT
            * INTO prog
        FROM
            programa
        WHERE
            estado_ori = t_est
            AND caracter_ori = substring(cinta_input FROM pos FOR 1)
        LIMIT 1;
    END LOOP;
    RAISE NOTICE 'estado final %', prog.estado_nue;
    IF t_est = 'f' THEN
        INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento);
        RAISE NOTICE 'El string SI pertenece al lenguaje';
    ELSE
        RAISE NOTICE 'El string NO pertenece al lenguaje';
    END IF;
END;
$$
LANGUAGE 'plpgsql';

