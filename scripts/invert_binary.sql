DELETE FROM programa;
DELETE FROM traza_ejecucion;
DELETE FROM alfabeto;

SELECT * FROM programa;
SELECT * FROM traza_ejecucion;
SELECT * FROM alfabeto;

INSERT INTO alfabeto VALUES ('0');
INSERT INTO alfabeto VALUES ('1');
INSERT INTO alfabeto VALUES ('_');
INSERT INTO alfabeto VALUES ('x');
INSERT INTO alfabeto VALUES ('y');

INSERT INTO programa VALUES ('q0','0','q1','0','R');
INSERT INTO programa VALUES ('q0','1','q2','1','R');
INSERT INTO programa VALUES ('q0','_','q10','_','L');
INSERT INTO programa VALUES ('q0','x','q9','x','R');
INSERT INTO programa VALUES ('q0','y','q9','y','R');

INSERT INTO programa VALUES ('q1','0','q1','0','R');
INSERT INTO programa VALUES ('q1','1','q1','1','R');
INSERT INTO programa VALUES ('q1','_','q3','_','L');
INSERT INTO programa VALUES ('q1','x','q3','x','L');
INSERT INTO programa VALUES ('q1','y','q3','y','L');

INSERT INTO programa VALUES ('q2','0','q2','0','R');
INSERT INTO programa VALUES ('q2','1','q2','1','R');
INSERT INTO programa VALUES ('q2','_','q4','_','L');
INSERT INTO programa VALUES ('q2','x','q4','x','L');
INSERT INTO programa VALUES ('q2','y','q4','y','L');

INSERT INTO programa VALUES ('q3','0','q5','x','L');
INSERT INTO programa VALUES ('q3','1','q6','x','L');

INSERT INTO programa VALUES ('q4','0','q5','y','L');
INSERT INTO programa VALUES ('q4','1','q6','y','L');

INSERT INTO programa VALUES ('q5','0','q5','0','L');
INSERT INTO programa VALUES ('q5','1','q5','1','L');
INSERT INTO programa VALUES ('q5','_','q7','_','R');
INSERT INTO programa VALUES ('q5','x','q7','x','R');
INSERT INTO programa VALUES ('q5','y','q7','y','R');

INSERT INTO programa VALUES ('q6','0','q6','0','L');
INSERT INTO programa VALUES ('q6','1','q6','1','L');
INSERT INTO programa VALUES ('q6','_','q8','_','R');
INSERT INTO programa VALUES ('q6','x','q8','x','R');
INSERT INTO programa VALUES ('q6','y','q8','y','R');

INSERT INTO programa VALUES ('q7','x','q9','x','R');
INSERT INTO programa VALUES ('q7','y','q9','y','R');
INSERT INTO programa VALUES ('q7','0','q0','x','R');
INSERT INTO programa VALUES ('q7','1','q0','x','R');

INSERT INTO programa VALUES ('q8','x','q9','x','R');
INSERT INTO programa VALUES ('q8','y','q9','y','R');
INSERT INTO programa VALUES ('q8','0','q0','y','R');
INSERT INTO programa VALUES ('q8','1','q0','y','R');

INSERT INTO programa VALUES ('q9','x','q9','x','R');
INSERT INTO programa VALUES ('q9','y','q9','y','R');
INSERT INTO programa VALUES ('q9','_','q10','_','L');

INSERT INTO programa VALUES ('q10','x','q10','0','L');
INSERT INTO programa VALUES ('q10','y','q10','1','L');
INSERT INTO programa VALUES ('q10','_','f','_','R');



SELECT simuladorMT('1010001');
SELECT * FROM traza_ejecucion;