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
    caracter_nue varchar(50) ,
    desplazamiento varchar(50) 
);

CREATE TABLE alfabeto(
	id serial PRIMARY KEY,
    valor char(1) NOT NULL
);

CREATE OR REPLACE FUNCTION simuladorMT(cinta_input varchar(200))
    RETURNS VOID
    AS $$
DECLARE
    prog programa%ROWTYPE;
    cin cinta%ROWTYPE;
    t_est varchar(50) DEFAULT 'q0';
    cin_long integer;
    i integer := 1;
    pos integer := 1;
BEGIN
	cinta_input = CONCAT(cinta_input, '_');
    cin_long := length(cinta_input);
	
    SELECT
        * INTO prog
    FROM
        programa
    WHERE
        estado_ori = 'q0'
        AND caracter_ori = substring(cinta_input FROM pos FOR 1) LIMIT 1;
	RAISE NOTICE 'programa : %', prog;
	
    WHILE t_est <> 'f' AND pos < length(cinta_input) LOOP
        INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento);
			
        IF prog.estado_ori <> prog.estado_nue AND t_est <> prog.estado_nue THEN
            t_est := prog.estado_nue;
        END IF;
        IF prog.caracter_nue <>(
            SELECT
                valor
            FROM
                cinta
            WHERE
                cinta_id = pos) THEN
            UPDATE
                cinta
            SET
                valor = prog.caracter_nue
            WHERE
                cinta_id = pos;
        END IF;
        IF prog.desplazamiento = 'R' THEN
            pos = pos + 1;
        END IF;
        IF prog.desplazamiento = 'L' THEN
            pos = pos - 1;
        END IF;
		
        SELECT
            * INTO prog
        FROM
            programa
        WHERE
            estado_ori = t_est
            AND caracter_ori = substring(cinta_input FROM pos FOR 1)
        LIMIT 1;

    END LOOP;
	
	IF prog.estado_nue = 'f' THEN
		INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento);
	END IF;
	
END;
$$
LANGUAGE 'plpgsql';
