\c turingmachine

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
    valor char(1) NOT NULL
);