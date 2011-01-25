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

-- 6. Visualizar, por cada departamento, el nombre del profesor más cercano a la jubilación (de mayor edad).

-- 7. Listar aquellos profesores que tienen algún compañero que imparte exactamente las mismas asignaturas.

-- 8. Visualizar el departamento con mayor número de asignaturas a su cargo.

-- 9. Por cada número de despacho, indicar el total de créditos impartidos por profesores ubicados en ellos.

-- 10. Listar los profesores que tienen una carga de créditos superior a la media.

-- 11. Visualizar el profesor con mayor carga de créditos. Considere la carga de créditos como la suma de los créditos de las asignaturas que imparte dicho profesor. Nota: Tenga en cuenta que un profesor puede impartir sólo una parte de una asignatura, por lo que se debe utilizar los créditos de la tabla impartir.

-- 12. Visualizar la asignatura de mayor número de créditos en que se ha matriculado cada alumno.

-- 13. Mostrar las parejas de profesores que no tienen ningún alumno en común

-- 14. Mostrar el listado de profesores que no comparten ninguna de sus asignaturas (dos profesores comparten asignatura aunque la impartan en grupos diferentes)

-- 15. Visualizar el profesor más antiguo de cada departamento.

-- 16. Listar los alumnos matriculados en alguna asignatura impartida por el profesor de mayor antigüedad.

-- 17. Visualizar el nombre y apellidos de aquellos profesores que tienen una carga de créditos superior a la media.

-- 18. De los alumnos que están matriculados en alguna asignatura que no es de 'Matematica Aplicada', visualizar sólo aquéllos que tienen a algún profesor con una carga total de créditos entre 3 y 7, pero cuya antigüedad no sea la mayor de su departamento.

-- 19. Visualizar aquellos alumnos matriculados en más de dos asignaturas a los que no les dé clase ningún profesor del departamento de 'Matematica Aplicada'.

-- 20. Visualizar las asignatura de más créditos de cada departamento entre aquellas no impartidas por un profesor con una antigüedad superior a 1990.

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
