CREATE OR REPLACE FUNCTION simuladorMT(cinta_input varchar(200))
    RETURNS VOID
    AS $$
DECLARE
    prog programa%ROWTYPE;
    t_est varchar(50)
    DEFAULT 'q0';
    cin_long integer;
    i integer := 1;
    pos integer := 2;
    caracter char(1);
BEGIN
    DELETE FROM traza_ejecucion;
    -- add blanks at borders
    cinta_input = CONCAT(cinta_input, '_');
    cinta_input = CONCAT('_', cinta_input);
    cin_long := length(cinta_input);
    -- check if characters belong to language
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
    -- select initial state
    SELECT
        * INTO prog
    FROM
        programa
    WHERE
        estado_ori = 'q0'
        AND caracter_ori = substring(cinta_input FROM pos FOR 1)
    LIMIT 1;
    -- iterate until final state is reached
    WHILE t_est <> 'f' LOOP
        -- add to traza_ejecucion every step run by the machine
        INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento, cadena)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento, cinta_input);
        -- check that is in a valid state
        IF prog.estado_ori IS NULL AND prog.caracter_ori IS NULL AND prog.estado_nue IS NULL AND prog.caracter_nue IS NULL THEN
            exit;
        END IF;
        -- if the character given by the program is different from the actual one, that represents a change in the string so we need to change it
        IF prog.caracter_ori <> prog.caracter_nue THEN
            cinta_input = CONCAT(SUBSTRING(cinta_input FROM 1 FOR pos - 1), prog.caracter_nue, SUBSTRING(cinta_input FROM pos + 1));
            RAISE NOTICE 'Cambio en la cinta: %', cinta_input;
            -- save the new string in traza_ejecucion
            UPDATE
                traza_ejecucion
            SET
                cadena = cinta_input
            WHERE
                traza_id =(
                    SELECT
                        max(traza_ejecucion.traza_id)
                    FROM
                        traza_ejecucion);
        END IF;
        -- update the state for the next step
        IF prog.estado_ori <> prog.estado_nue AND t_est <> prog.estado_nue THEN
            t_est := prog.estado_nue;
        END IF;
        --move left or right
        IF prog.desplazamiento = 'R' THEN
            pos = pos + 1;
        END IF;
        IF prog.desplazamiento = 'L' THEN
            pos = pos - 1;
        END IF;

        -- select the function for the next step
        SELECT
            * INTO prog
        FROM
            programa
        WHERE
            estado_ori = t_est
            AND caracter_ori = substring(cinta_input FROM pos FOR 1)
        LIMIT 1;
    END LOOP;
    RAISE NOTICE 'estado final string %', cinta_input;

    -- check if final state is present in traza_ejecucion. This means that the final state has been reached.
    IF t_est = 'f' THEN
        INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento, cadena)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento, cinta_input);
        RAISE NOTICE 'El string SI pertenece al lenguaje';
    ELSE
        RAISE NOTICE 'El string NO pertenece al lenguaje';
    END IF;
END;
$$
LANGUAGE 'plpgsql';

