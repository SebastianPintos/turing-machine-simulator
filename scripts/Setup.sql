-- Se crea la estructura de datos

CREATE TABLE IF NOT EXISTS programa(
    estado_ori varchar(50) NOT NULL,
    caracter_ori varchar(50) NOT NULL,
    estado_nue varchar(50) NOT NULL,
    caracter_nue varchar(50) NOT NULL,
    desplazamiento varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS traza_ejecucion(
    traza_id serial PRIMARY KEY,
    estado_ori varchar(50),
    caracter_ori varchar(50),
    estado_nue varchar(50),
    caracter_nue varchar(50),
    desplazamiento varchar(50),
    cadena varchar(50)
);

CREATE TABLE IF NOT EXISTS alfabeto(
    valor char(1) NOT NULL
);

-- Se crea la funcion de simulador de Maquina de Turing

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
    Truncate traza_ejecucion;
    -- agrega espacios en blanco en los bordes
    cinta_input = CONCAT(cinta_input, '_');
    cinta_input = CONCAT('_', cinta_input);
    cin_long := length(cinta_input);
    -- verifica si los caracteres pertenecen al idioma
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
    -- selecciona estado inicial
    SELECT
        * INTO prog
    FROM
        programa
    WHERE
        estado_ori = 'q0'
        AND caracter_ori = substring(cinta_input FROM pos FOR 1)
    LIMIT 1;
    -- itera hasta alcanzar el estado final
    WHILE t_est <> 'f' LOOP
        -- comprueba que está en un estado válido
        IF prog.estado_ori IS NULL AND prog.caracter_ori IS NULL AND prog.estado_nue IS NULL AND prog.caracter_nue IS NULL THEN
            exit;
        END IF;
		
		-- añade a la traza_ejecucion cada paso realizado por la máquina
        INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento, cadena)
            VALUES (prog.estado_ori, prog.caracter_ori, prog.estado_nue, prog.caracter_nue, prog.desplazamiento, cinta_input);
		
        UPDATE
            traza_ejecucion
        SET
            cadena = substring(cinta_input FROM 2 FOR length(cinta_input) - 2)
        WHERE
            traza_id =(
                SELECT
                    max(traza_ejecucion.traza_id)
                FROM
                    traza_ejecucion);
        -- si el caracter dado por el programa es diferente del real, eso representa un cambio en la cadena, por lo que debemos actualizar el cambio
        IF prog.caracter_ori <> prog.caracter_nue THEN
            cinta_input = CONCAT(SUBSTRING(cinta_input FROM 1 FOR pos - 1), prog.caracter_nue, SUBSTRING(cinta_input FROM pos + 1));
            RAISE NOTICE 'Cambio en la cinta: %', cinta_input;
            -- guarda la nueva cadena en traza_ejecucion
        END IF;
        -- actualiza el estado para el siguiente paso
        IF prog.estado_ori <> prog.estado_nue AND t_est <> prog.estado_nue THEN
            t_est := prog.estado_nue;
        END IF;
        --mueve posición a la izquierda o a la derecha
        IF prog.desplazamiento = 'R' THEN
            pos = pos + 1;
        END IF;
        IF prog.desplazamiento = 'L' THEN
            pos = pos - 1;
        END IF;
        -- selecciona la función para el siguiente paso
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
    -- comprueba si el estado final está presente en traza_ejecucion. Esto significa que se ha alcanzado el estado final.
    IF t_est = 'f' THEN
        RAISE NOTICE 'El string SI pertenece al lenguaje';
    ELSE
        RAISE NOTICE 'El string NO pertenece al lenguaje';
    END IF;
END;
$$
LANGUAGE 'plpgsql';

-- Se crea la funcion que devuelve la descripcion instantanea del ultimo programa ejecutado

CREATE OR REPLACE FUNCTION descripcionInstantanea()
    RETURNS VOID
    AS $$
DECLARE
    i integer := 0;
    result text = '';
    traza traza_ejecucion%ROWTYPE;
BEGIN
    FOR traza IN
    SELECT
        *
    FROM
        traza_ejecucion
    ORDER BY
        traza_id LOOP
			IF i = -1 THEN	
				result = result || substring(traza.cadena FROM 0 FOR i + 2) || '(' || traza.estado_ori || ')_' || substring(traza.cadena FROM i + 2 FOR length(traza.cadena)) || ' |- ';
			ELSE
				IF i < length(traza.cadena) THEN
					result = result || substring(traza.cadena FROM 0 FOR i + 1) || '(' || traza.estado_ori || ')' || substring(traza.cadena FROM i + 1 FOR length(traza.cadena)) || ' |- ';
				ELSE
					result = result || substring(traza.cadena FROM 0 FOR i + 1) || '(' || traza.estado_ori || ')' || substring(traza.cadena FROM i + 1 FOR length(traza.cadena)) || '_ |- ';
				END IF;
			END IF;	
            
            IF traza.desplazamiento = 'R' THEN
                i = i + 1;
            END IF;
            IF traza.desplazamiento = 'L' THEN
                i = i - 1;
            END IF;
        END LOOP;
	
	select substring (result, 1, length(result)-3) INTO result;
	
    RAISE NOTICE '%', result;
END;
$$
LANGUAGE 'plpgsql';