DELETE FROM programa;
DELETE FROM traza_ejecucion;
DELETE FROM alfabeto;

SELECT * FROM programa;
SELECT * FROM traza_ejecucion;
SELECT * FROM alfabeto;

INSERT INTO alfabeto VALUES ('0');
INSERT INTO alfabeto VALUES ('1');
INSERT INTO alfabeto VALUES ('_');

INSERT INTO programa VALUES ('q0','0','q0','0','R');
INSERT INTO programa VALUES ('q0','1','q1','1','R');
INSERT INTO programa VALUES ('q1','0','q2','0','R');
INSERT INTO programa VALUES ('q1','1','q0','1','R');
INSERT INTO programa VALUES ('q2','0','q1','0','R');
INSERT INTO programa VALUES ('q2','1','q2','1','R');
INSERT INTO programa VALUES ('q0','_','f','_','_');

SELECT simuladorMT('1001');
SELECT * FROM traza_ejecucion;
