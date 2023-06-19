-- DROP TABLE programa
CREATE TABLE programa(
    estado_ori varchar(50) NOT NULL,
    caracter_ori char(1) NOT NULL,
    estado_nue varchar(50) NOT NULL,
    caracter_nue char(1) NOT NULL,
    desplazamiento char(1) NOT NULL
);

-- DROP TABLE traza_ejecucion
CREATE TABLE traza_ejecucion(
    traza_id serial PRIMARY KEY,
    estado_ori varchar(50),
    caracter_ori char(1),
    estado_nue varchar(50),
    caracter_nue char(1),
    desplazamiento char(1) NOT NULL
);

-- DROP TABLE estado
CREATE TABLE estado (
  nombre varchar(50) PRIMARY KEY,
  indice INTEGER NOT NULL
);

-- Crear la tabla de la cinta
CREATE TABLE cinta (
  pos INTEGER PRIMARY KEY,
  caracter CHAR(1) NOT NULL
);

CREATE TABLE alfabeto(
    valor char(1) NOT NULL
);