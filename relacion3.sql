-- Relación DML 3 - SELECT correlacionados y agrupaciones

-- 1. Calcular el número de profesores de cada departamento.
SELECT d.nombre, COUNT(p.nrp) "NUMERO PROFESORES"
FROM departamentos d, profesores p
WHERE p.departamento=d.codigo
GROUP BY d.nombre;

-- 2. Calcular el número de créditos asignados a cada departamento. Se consideran los créditos establecidos para cada asignatura del departamento, no si la imparten o no profesores del mismo.
SELECT d.nombre, SUM(a.creditos) "SUMA DE CREDITOS"
FROM departamentos d, asignaturas a
WHERE a.departamento=d.codigo
GROUP BY d.nombre;

-- 3. Calcular el número de alumnos matriculados por curso (cada alumno debe contar una sola vez por curso aunque esté matriculado de varias asignaturas).
SELECT asi.curso, COUNT(DISTINCT alu.dni) "NUMERO DE ALUMNOS"
FROM (asignaturas asi join matricular m on asi.codigo=m.asignatura) join alumnos alu on m.alumno=alu.dni
GROUP BY asi.curso;

-- 4. Calcular, por cada asignatura, qué porcentaje de sus alumnos son mujeres. Mostrar el código de la asignatura y el porcentaje.
SELECT m.asignatura, ROUND((COUNT(alu.dni)/(SELECT COUNT(*) FROM matricular maux WHERE maux.asignatura=m.asignatura)*100),1) "PORCENTAJE MUJERES"
FROM matricular m, alumnos alu
WHERE alu.sexo like 'FEM'
AND m.alumno=alu.dni
GROUP BY m.asignatura;

-- 5. De los alumnos varones matriculados en al menos 3 asignaturas , visualizar aquéllos que tengan al mismo profesor en, al menos dos asignaturas.
SELECT *
FROM alumnos alu
WHERE (alu.dni, null) IN(
	SELECT m.alumno, i.profesor
	FROM ((alumnos alu JOIN matricular m ON alu.dni=m.alumno)
	JOIN asignaturas asi ON m.asignatura=asi.codigo)
	JOIN impartir i ON asi.codigo=i.asignatura
	WHERE m.alumno IN(
		SELECT alu.dni
		FROM alumnos alu JOIN matricular m ON alu.dni=m.alumno
		WHERE alu.sexo like 'MASC'
		GROUP BY alu.dni
		HAVING COUNT(m.asignatura)>=3)
	GROUP BY (i.profesor, m.alumno)
	HAVING COUNT(DISTINCT asi.codigo)>=2);
	
	--TODO este ejercicio es una locura, no sé cómo hacerlo.

-- 6. Visualizar, por cada departamento, el nombre del profesor más cercano a la jubilación (de mayor edad).
SELECT d.nombre, (p.nombre||' '||p.apellido1) profesor
FROM departamentos d JOIN profesores p ON d.codigo=p.departamento
WHERE p.fecha_nacimiento IN(
	SELECT MIN(p.fecha_nacimiento)
	FROM profesores p
	WHERE p.departamento=d.codigo);

-- 7. Listar aquellos profesores que tienen algún compañero que imparte exactamente las mismas asignaturas.
SELECT *
FROM profesores p1 JOIN impartir ip1 ON p1.nrp=ip1.profesor
WHERE i1.asignatura IN(
	SELECT i1.asignatura
	FROM (profesores pro1 JOIN impartir i1 ON pro1.nrp=i1.profesor) JOIN (profesores pro2 JOIN impartir i2 ON pro2.nrp=i2.profesor) ON i1.asignatura=i2.asignatura
	WHERE pro1.nrp<>pro2.nrp
	AND pro1.nrp=p1.nrp);
	
	--TODO otro ejercicio que no se me ocurre...

-- 8. Visualizar el departamento con mayor número de asignaturas a su cargo.
SELECT d.nombre
FROM departamentos d
WHERE (SELECT COUNT(*)
	FROM asignaturas asi
	WHERE asi.departamento=d.codigo)=
	(SELECT MAX(COUNT(*))
	FROM asignaturas
	GROUP BY departamento);

-- 9. Por cada número de despacho, indicar el total de créditos impartidos por profesores ubicados en ellos.
SELECT p.despacho, SUM(i.carga_creditos)
FROM profesores p JOIN impartir i ON i.profesor=p.nrp
GROUP BY p.despacho;

-- 10. Listar los profesores que tienen una carga de créditos superior a la media.
	--Me niego a hacer este porque la solucion que dan los profesores no tiene nada que ver.

-- 11. Visualizar el profesor con mayor carga de créditos. Considere la carga de créditos como la suma de los créditos de las asignaturas que imparte dicho profesor. Nota: Tenga en cuenta que un profesor puede impartir sólo una parte de una asignatura, por lo que se debe utilizar los créditos de la tabla impartir.
SELECT p.nombre||' '||p.apellido1 PROFESOR
FROM profesores p JOIN impartir i ON i.profesor=p.nrp
GROUP BY p.nombre||' '||p.apellido1
HAVING SUM(i.carga_creditos)=(SELECT MAX(SUM(carga_creditos))
	FROM profesores p JOIN impartir i ON i.profesor=p.nrp
	GROUP BY p.nrp);

-- 12. Visualizar la asignatura de mayor número de créditos en que se ha matriculado cada alumno.
SELECT DISTINCT alu.nombre||' '||alu.apellido1||' '||alu.apellido2 ALUMNO, asi.nombre ASIGNATURA
FROM (alumnos alu JOIN matricular m ON m.alumno=alu.dni) JOIN asignaturas asi ON m.asignatura=asi.codigo
WHERE asi.creditos=(SELECT MAX(asi1.creditos)
	FROM (alumnos alu1 JOIN matricular m1 ON m1.alumno=alu1.dni) JOIN asignaturas asi1 ON m1.asignatura=asi1.codigo
	WHERE alu.dni=alu1.dni);

-- 13. Mostrar las parejas de profesores que no tienen ningún alumno en común
SELECT p1.nombre||' '||p1.apellido1||' '||p1.apellido2 PROFESOR1, p2.nombre||' '||p2.apellido1||' '||p2.apellido2 PROFESOR2
FROM profesores p1, profesores p2
WHERE p1.nrp<p2.nrp
AND NOT EXISTS(
	SELECT m.alumno
	FROM matricular m NATURAL JOIN impartir i
	WHERE p1.nrp=i.profesor
	INTERSECT
	SELECT m.alumno
	FROM matricular m NATURAL JOIN impartir i
	WHERE p2.nrp=i.profesor);

-- 14. Mostrar el listado de profesores que no comparten ninguna de sus asignaturas (dos profesores comparten asignatura aunque la impartan en grupos diferentes)
SELECT p1.nombre||' '||p1.apellido1||' '||p1.apellido2 PROFESOR1, p2.nombre||' '||p2.apellido1||' '||p2.apellido2 PROFESOR2
FROM profesores p1, profesores p2
WHERE p1.nrp<p2.nrp
AND NOT EXISTS(
	SELECT i.asignatura
	FROM impartir i
	WHERE p1.nrp=i.profesor
	INTERSECT
	SELECT i.asignatura
	FROM impartir i
	WHERE p2.nrp=i.profesor);

-- 15. Visualizar el profesor más antiguo de cada departamento.
SELECT d.nombre DEPARTAMENTO, p.nombre||' '||p.apellido1 PROFESOR
FROM departamentos d JOIN profesores p ON p.departamento=d.codigo
WHERE p.antiguedad=(
	SELECT MIN(p1.antiguedad)
	FROM profesores p1
	WHERE d.codigo=p1.departamento
	GROUP BY (p1.departamento));

-- 16. Listar los alumnos matriculados en alguna asignatura impartida por el profesor de mayor antigüedad.
SELECT alu.nombre||' '||alu.apellido1||' '||alu.apellido2 ALUMNO
FROM ((matricular m NATURAL JOIN impartir i) JOIN alumnos alu ON m.alumno=alu.dni) JOIN profesores p ON i.profesor=p.nrp
WHERE p.antiguedad=(
	SELECT MIN(antiguedad)
	FROM profesores);

-- 17. Visualizar el nombre y apellidos de aquellos profesores que tienen una carga de créditos superior a la media.
	-- Lo mismo que el 10.

-- 18. De los alumnos que están matriculados en alguna asignatura que no es de 'Matematica Aplicada', visualizar sólo aquéllos que tienen a algún profesor con una carga total de créditos entre 3 y 7, pero cuya antigüedad no sea la mayor de su departamento.
SELECT alu.dni
FROM alumnos alu
WHERE alu.dni IN((
	SELECT alumno
	FROM (matricular m JOIN asignaturas asi ON m.asignatura=asi.codigo) JOIN departamentos d ON asi.departamento=d.codigo
	WHERE d.nombre <> 'Matem%'
	)
	INTERSECT
	SELECT m.alumno
	FROM matricular m NATURAL JOIN impartir i
	WHERE i.profesor IN(
		SELECT nrp
		FROM profesores
		MINUS(
		(SELECT p.nrp
		FROM profesores p
		WHERE p.antiguedad=(
			SELECT MIN(p1.antiguedad)
			FROM profesores p1
			WHERE p.departamento=p1.departamento
			GROUP BY(p1.departamento))
		)UNION(
			SELECT p.nrp
			FROM profesores p JOIN impartir i ON i.profesor=p.nrp
			GROUP BY p.nrp
			HAVING SUM(i.carga_creditos)<3
		)UNION(
			SELECT p.nrp
			FROM profesores p JOIN impartir i ON i.profesor=p.nrp
			GROUP BY p.nrp
			HAVING SUM(i.carga_creditos)>7
		))
	));

-- 19. Visualizar aquellos alumnos matriculados en más de dos asignaturas a los que no les dé clase ningún profesor del departamento de 'Matematica Aplicada'.
SELECT DISTINCT alu.nombre, alu.apellido1, alu.apellido2
FROM alumnos alu JOIN matricular m ON m.alumno=alu.dni
MINUS
SELECT DISTINCT alu.*
FROM (((alumnos alu JOIN matricular m ON m.alumno=alu.dni) NATURAL JOIN impartir i) JOIN profesores p ON p.nrp=i.profesor) JOIN departamentos d ON d.codigo=p.departamento
WHERE d.nombre like 'Matem%';

-- 20. Visualizar las asignatura de más créditos de cada departamento entre aquellas no impartidas por un profesor con una antigüedad superior a 1990.
SELECT asi.codigo, asi.nombre
FROM asignaturas asi
WHERE asi.creditos=(
	SELECT MAX(creditos)
	FROM (asignaturas asi2 JOIN impartir i ON i.asignatura=asi2.codigo) JOIN profesores p ON i.profesor=p.nrp
	WHERE p.antiguedad > to_date(1999,'yyyy')
	AND asi.departamento=asi2.departamento
);

-- 21. Listar por orden de carga de créditos aquellos departamentos que tengan matriculados más de cinco alumnos (en cualquiera de sus asignaturas).

-- 22. Visualizar el número total de alumnos que posee cada profesor (si un alumno está matriculado en varias asignaturas de un profesor, contará varias veces), pero sólo de aquellos profesores que impartan alguna asignatura en la que el número de créditos prácticos es superior al de teóricos.

-- 23. Mostrar las parejas de alumnos que no coinciden en ninguna clase

-- 24. Visualizar, para cada profesor, la carga normalizada de trabajo por profesor (CNTP). La carga normalizada se calcula como sigue:
--     · A cada asignatura se asocia un NCN (Número de Créditos Normalizado), de la forma: 0.5 * nº de créditos prácticos + 1 * nº de créditos teóricos.
--     · El NCN de cada asignatura se multiplica por el número de alumnos matriculados, lo que da la CNTA (Carga Normalizada de Trabajo por Asignatura).
--     · Algunos profesores no imparten todos los créditos asociados a una asignatura. Por ello, la CNTAP (Carga Normalizada de Trabajo por Asignatura y Profesor), es: CNTA * carga de créditos / créditos de la asignatura.
--     · La suma de todos los CNTAP de un mismo profesor da la CNTP.

-- 25. Mostrar las parejas de profesores que comparten entre ellos dos exclusivamente todas sus asignaturas (dan clases en las mismas asignaturas y ninguno de los dos comparte asignatura con otro profesor)

-- 30. Visualizar aquellos profesores que imparten 2 o más asignaturas con una carga de créditos inferior a 6.5 en cada una de ellas.

-- 31. De las asignaturas con más de 3 alumnos, visualizar el nombre del alumno más veterano (con la fecha de la primera matrícula más antigua).

-- 32. De cada asignatura con menos de 16 alumnos matriculados e impartida por el departamento más antiguo (con la menor fecha de creación), visualizar el nombre de la asignatura y el número de profesores que la imparte.

-- 33. Visualizar por cada profesor que imparte al menos 2 asignaturas, a aquéllos que tienen a algún alumno nacido antes del año 1983.
