DELETE FROM programa;
DELETE FROM traza_ejecucion;
DELETE FROM alfabeto;

SELECT * FROM programa;
SELECT * FROM traza_ejecucion;
SELECT * FROM alfabeto;

INSERT INTO alfabeto VALUES ('0');
INSERT INTO alfabeto VALUES ('1');
INSERT INTO alfabeto VALUES ('_');

INSERT INTO programa VALUES ('q0','0','qRight0','_','R');
INSERT INTO programa VALUES ('qRight0','0','qRight0','0','R');
INSERT INTO programa VALUES ('qRight0','1','qRight0','1','R');
INSERT INTO programa VALUES ('q0','1','qRight1','_','R');
INSERT INTO programa VALUES ('qRight1','0','qRight1','0','R');
INSERT INTO programa VALUES ('qRight1','1','qRight1','1','R');
INSERT INTO programa VALUES ('qRight0','_','qSearch0L','_','L');
INSERT INTO programa VALUES ('qSearch0L','0','q1','_','L');
INSERT INTO programa VALUES ('qRight1','_','qSearch1L','_','L');
INSERT INTO programa VALUES ('qSearch1L','1','q1','_','L');
INSERT INTO programa VALUES ('q1','0','qLeft0','_','L');
INSERT INTO programa VALUES ('qLeft0','0','qLeft0','0','L');
INSERT INTO programa VALUES ('qLeft0','1','qLeft0','1','L');
INSERT INTO programa VALUES ('q1','1','qLeft1','_','L');
INSERT INTO programa VALUES ('qLeft1','0','qLeft1','0','L');
INSERT INTO programa VALUES ('qLeft1','1','qLeft1','1','L');
INSERT INTO programa VALUES ('qLeft0','_','qSearch0R','_','R');
INSERT INTO programa VALUES ('qSearch0R','0','q0','_','R');
INSERT INTO programa VALUES ('qLeft1','_','qSearch1R','_','R');
INSERT INTO programa VALUES ('qSearch1R','1','q0','_','R');
INSERT INTO programa VALUES ('qSearch0R','1','qReject','1','-');
INSERT INTO programa VALUES ('qSearch1R','0','qReject','0','-');
INSERT INTO programa VALUES ('qSearch0L','1','qReject','1','-');
INSERT INTO programa VALUES ('qSearch1L','0','qReject','0','-');
INSERT INTO programa VALUES ('q0','_','f','_','_');
INSERT INTO programa VALUES ('q1','_','f','_','_');
INSERT INTO programa VALUES ('qSearch0L','_','f','_','_');
INSERT INTO programa VALUES ('qSearch0R','_','f','_','_');
INSERT INTO programa VALUES ('qSearch1L','_','f','_','_');
INSERT INTO programa VALUES ('qSearch1R','_','f','_','_');

SELECT simuladorMT('1010101');
SELECT * FROM traza_ejecucion;
