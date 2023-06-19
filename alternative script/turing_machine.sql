-- FUNCTION: paso(character)

-- Crear la función que ejecuta casa paso de la MT
-- DROP FUNCTION IF EXISTS paso(varchar);
CREATE OR REPLACE FUNCTION paso(estado_origen varchar)
    RETURNS TABLE(estado_previo varchar, caracter_previo character, nuevo_estado varchar, simbolo_escrito character, movimiento character) 
AS $$
  DECLARE
    indice_actual INTEGER;
    caracter_actual character;
  BEGIN
    -- Obtener el índice y el símbolo actuales de la cinta
    SELECT indice INTO indice_actual FROM estado WHERE nombre = estado_origen;
    SELECT caracter INTO caracter_actual FROM cinta WHERE pos = indice_actual;
    -- Si no hay símbolo, asumir que es el blanco B
    IF caracter_actual IS NULL THEN
      caracter_actual := '_';
    END IF;
    -- Consultar la tabla de transición con el estado y el símbolo actuales
	RAISE NOTICE 'caracter_actual actual %', caracter_actual;
    RETURN QUERY SELECT estado_origen, caracter_actual, estado_nue, caracter_nue, desplazamiento FROM programa WHERE estado_ori = estado_origen AND caracter_ori = caracter_actual;
  END;
$$ LANGUAGE plpgsql;


-- Crear la función que ejecuta el bucle
-- DROP FUNCTION simuladorMT
CREATE OR REPLACE FUNCTION simuladorMT (entrada VARCHAR)
RETURNS VOID
AS $$
  DECLARE
    resultado RECORD;
    estado_actual VARCHAR;
    indice_actual INTEGER;
	nuevo_estado VARCHAR;
    simbolo_escrito CHAR(1);
    desplazamiento CHAR(1);
	estado_previo VARCHAR; 
	caracter_previo CHAR(1);
	pos_inicial INTEGER;
	aceptado BOOLEAN := TRUE;
	output_msg VARCHAR := '';
  BEGIN
    -- Borrar las tablas anteriores
    TRUNCATE cinta;
    TRUNCATE estado;
	
    -- Inicializar la cinta con la entrada
    INSERT INTO cinta SELECT generate_series(1, length(entrada)), substring(entrada from generate_series(1, length(entrada)) for 1);
	
	IF EXISTS (SELECT caracter FROM cinta WHERE caracter NOT IN (SELECT valor FROM alfabeto)) THEN 
		aceptado := FALSE;
		output_msg := 'Error: Existen uno o mas caracteres que no pertenece al lenguaje.';
	ELSE
		-- Inicializar el estado con q0
		estado_actual := 'q0';
		SELECT pos INTO pos_inicial FROM cinta ORDER BY pos LIMIT 1;
    	INSERT INTO estado VALUES ('q0', pos_inicial);
		
    	-- Mientras no sea un estado final
    	WHILE estado_actual <> 'qf' LOOP
      		-- Ejecutar la función paso y obtener el resultado			
      		SELECT * INTO resultado FROM paso(estado_actual);
      		-- Si no hay resultado, terminar con error
      		IF resultado IS NULL THEN
	  			aceptado := FALSE;
				output_msg := 'El string "' || entrada || '" NO es una cadena valida aceptada por el lenguaje';
	  			exit;
      		END IF;
      		-- Asignar el nuevo estado, el símbolo escrito y el movimiento
			estado_previo := resultado.estado_previo;
			caracter_previo := resultado.caracter_previo;
      		estado_actual := resultado.nuevo_estado;
      		simbolo_escrito := resultado.simbolo_escrito;
      		desplazamiento := resultado.movimiento;
      		-- Actualizar la tabla del estado con el nuevo estado
      		UPDATE estado SET nombre = estado_actual;
      		-- Obtener el índice actual de la cinta
      		SELECT indice INTO indice_actual FROM estado;
      		-- Actualizar la tabla de la cinta con el símbolo escrito
      		UPDATE cinta SET caracter = simbolo_escrito WHERE pos = indice_actual;
      		-- Si no hay fila en la tabla de la cinta, crearla
      		IF NOT FOUND THEN
        		INSERT INTO cinta VALUES (indice_actual, simbolo_escrito);
      		END IF;
      		-- Si el movimiento es a la derecha, incrementar el índice
      		IF desplazamiento = 'R' THEN
        		indice_actual := indice_actual + 1;
      		-- Si el movimiento es a la izquierda, decrementar el índice
      		ELSIF desplazamiento = 'L' THEN
        		indice_actual := indice_actual - 1;
      		END IF;
      		-- Actualizar la tabla del estado con el nuevo índice
      		UPDATE estado SET indice = indice_actual;
			
			INSERT INTO traza_ejecucion(estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento)
			VALUES (estado_previo, caracter_previo, estado_actual, simbolo_escrito, desplazamiento);
    	END LOOP;
		
	END IF;
		
    -- Si se alcanza un estado final o no encuentra funcion, mostrar el resultado
	IF aceptado THEN
		RAISE NOTICE 'El string "%" es un cadena aceptada por el lenguaje', entrada;	
	ELSE
		RAISE NOTICE '%', output_msg;
	END IF;
  END;
$$ LANGUAGE plpgsql;

