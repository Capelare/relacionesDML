-- Relación DML 1 - SELECT simples

-- 1. Hallar el nombre y dos apellidos de los profesores del departamento de código 1.
SELECT nombre, apellido1, apellido2
FROM profesores
WHERE departamento = 1;

-- 2. Hallar el nombre y dos apellidos de los profesores de todos los departamentos salvo el de código 3.
SELECT nombre, apellido1, apellido2
FROM profesores
WHERE departamento != 3;

-- 3. Hallar el nombre y dos apellidos de los profesores cuyo correo está en el servidor lcc.uma.es 
SELECT nombre, apellido1, apellido2 
FROM profesores
WHERE email like '%lcc.uma.es';

-- 4. Hallar el nombre y dos apellidos de los profesores que ingresaran antes de 1990.
SELECT nombre, apellido1, apellido2
FROM profesores
WHERE antiguedad < TO_DATE('1990','YYYY');

-- 5. Hallar el nombre y dos apellidos de los profesores que tengan menos de 30 años (use la fecha del sistema).
SELECT nombre, apellido1, apellido2
FROM profesores
WHERE MONTHS_BETWEEN(SYSDATE, fecha_nacimiento)/12 < 30;

-- 6. Liste en mayúsculas el nombre y dos apellidos de los profesores que tienen más de 3 trienios. Muestre el número de trienios acumulados también. Use la función TRUNC para un cálculo correcto de los trienios. 
SELECT UPPER(nombre), UPPER(apellido1), UPPER(apellido2), TRUNC(MONTHS_BETWEEN(SYSDATE, antiguedad)/36)
FROM profesores
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, antiguedad)/36) > 3;

-- 7. Mostrar la lista de alumnos que no disponen de correo electrónico.
SELECT * 
FROM alumnos
WHERE email IS NULL;

-- 8. Haga la consulta anterior pero muestre la lista como: El alumno ...... no dispone de Correo.
SELECT DECODE(sexo, 'MASC','El alumno ', 'FEM', 'La alumna ')||nombre||' '||apellido1||' '||apellido2||' no dispone de correo'
FROM alumnos
WHERE email IS NULL;

-- 9. Muestre la lista de las notas de la asignatura 112. Liste el código del alumno junto a su nota ordenado por el primero.
SELECT alumno, calificacion
FROM matricular
WHERE asignatura=112 ORDER BY alumno;

-- 10. Liste el nombre de todas las asignaturas que contienen en su nombre las palabras 'Bases de Datos'. Renombre dicha cadena en el listado como 'Almacenes de Datos'. Use la función REPLACE.
SELECT REPLACE(nombre, 'Bases', 'Almacenes')
FROM asignaturas
WHERE nombre LIKE '%Bases de Datos%';

-- 11. Muestre el nombre y créditos de todas las asignaturas obligatorias y optativas. Las asignaturas que no tienen asignado el valor de créditos debe poner NO ASIGNADO. Aproveche que obligatorias y optativas comienzan ambas por el mismo carácter para simplificar la consulta. 
SELECT nombre, NVL(to_char(creditos),'NO ASIGNADO')
FROM asignaturas WHERE caracter LIKE 'O_';

-- 12. Liste el nombre de las asignaturas de tercero, informando del total de créditos, de la proporción de teoría y de prácticas.
SELECT nombre, creditos, round(teoricos/creditos*100,2), round(practicos/creditos*100,2)
FROM asignaturas
WHERE curso=3;

-- 13. Muestre el nombre de los alumnos que se matricularon en las primeras dos horas de abrirse el plazo de matrícula. Considere que el plazo se abre todos los años el primer lunes del mes de septiembre a las 9:00am.
SELECT nombre
FROM alumnos
WHERE fecha_prim_matricula BETWEEN NEXT_DAY(TO_DATE('31-08-'||TO_CHAR(fecha_prim_matricula,'YYYY')|| '09:00','DD-MM-YYYY HH24:MI'),'lunes')
AND NEXT_DAY(TO_DATE('31-08-'||TO_CHAR(fecha_prim_matricula,'YYYY')|| '11:00','DD-MM-YYYY HH24:MI'),'lunes');

-- 14. Informe de los alumnos que se han matriculado hace menos de dos meses.
SELECT nombre
FROM alumnos
WHERE MONTHS_BETWEEN(SYSDATE, fecha_prim_matricula)<2;

-- 15. Informe de los alumnos que entraron en la Universidad con menos de 18 años.
SELECT nombre
FROM alumnos
WHERE MONTHS_BETWEEN(fecha_prim_matricula, fecha_nacimiento)/12 < 18;

-- 16. Informe de los alumnos que se matricularon en la universidad un lunes.
SELECT nombre
FROM alumnos
WHERE to_char(fecha_prim_matricula,'D')=1;

-- 17. Informe de los alumnos cuyo cumpleaños el próximo año cae en martes.
SELECT nombre
FROM alumnos
WHERE to_char(to_date(to_char(fecha_nacimiento,'DD-MM-')||(to_char(SYSDATE,'YYYY')+1), 'DD-MM-YYYY'),'D'=2;

-- 18. Informe de los alumnos que cumplen años esta misma semana.
SELECT nombre
FROM alumnos
WHERE to_date(to_char(fecha_nacimiento,'DD-MM'),'DD-MM') BETWEEN NEXT_DAY(SYSDATE-7, 'lunes') AND NEXT_DAY(SYSDATE,'lunes'); 

-- 19. Liste el nombre y apellidos de los profesores cuya antigüedad en la jubilación será de menos de 25 años de servicio.

-- 20. Informe de quienes no alcanzan esa antigüedad por tan solo 6 meses.

-- 21. Liste la información del nombre de las asignaturas troncales de segundo curso ordenadas por los créditos descendentemente. Muestre el valor de este atributo gráficamente, donde cada crédito se representa con tres repeticiones del caracter '#'. Use la función LPAD.

-- 22. Para cada asignatura muestre el nombre, el curso, los créditos totales y el valor de créditos mayor entre los teóricos o prácticos. Use la funión GREATEST.
