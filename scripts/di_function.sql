
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
            result = result || substring(traza.cadena FROM 0 FOR i + 1) || '(' || traza.estado_ori || ')' || substring(traza.cadena FROM i + 1 FOR length(traza.cadena)) || ' |- ';
            IF traza.desplazamiento = 'R' THEN
                i = i + 1;
            END IF;
            IF traza.desplazamiento = 'L' THEN
                i = i - 1;
            END IF;
        END LOOP;
    RAISE NOTICE '%', result;
END;
$$
LANGUAGE 'plpgsql';