-- Relación DML 2 - Reuniones y Operaciones de Conjuntos

-- 1. Nombre y apellidos de los profesores del departamento de Lenguajes.
SELECT P.nombre, P.apellido1, P.apellido2
FROM profesores P JOIN departamentos D ON P.departamento=D.codigo
WHERE D.codigo=1;

-- 2. Nombre y apellidos de parejas de profesores cuya diferencia de antigüedad sea inferior a dos años y pertenezcan al mismo departamento. Muestre la antigüedad de cada uno de ellos en años.
SELECT P1.nombre, P1.apellido1, P1.apellido2, TRUNC(MONTHS_BETWEEN(SYSDATE, P1.antiguedad)/12), P2.nombre, P2.apellido1, P2.apellido2, TRUNC(MONTHS_BETWEEN(SYSDATE, P2.antiguedad)/12)
FROM profesores P1, profesores P2
WHERE P1.nrp < P2.nrp
AND P1.departamento=P2.departamento
AND ABS(MONTHS_BETWEEN(P1.antiguedad, P2.antiguedad))<(12*2);

-- 3. Muestre el nombre y apellidos de cada profesor junto con su director de tesis y el número de sexenios del director. Los nombres de cada profesor y su director deben aparecer con el siguiente formato: 'El Director de Angel Mora Bonilla es Manuel Enciso Garcia-Oliveros'
SELECT 'El director de '||P1.nombre||' '||P1.apellido1||' '||P1.apellido2||' es '||P2.nombre||' '||P2.apellido1||' '||P2.apellido2, TRUNC(MONTHS_BETWEEN(SYSDATE, P2.antiguedad)/(12*6))
FROM profesores P1, profesores P2
WHERE P1.director_tesis=P2.NRP;

-- 4. Usando la función NVL extraiga un listado con el código y el nombre de las asignaturas de las que está matriculado 'Nicolas Bersabe Alba'. Proporcione además el número de créditos prácticos, pero caso de ser nulo, debe salir "no tiene" en el listado. Indicación: advierta que practicos es NUMBER y el literal 'No tiene' es VARCHAR2.
SELECT Asi.codigo, Asi.nombre, NVL(TO_CHAR(Asi.practicos), 'No tiene')
FROM asignaturas Asi, alumnos Alu, matricular M
WHERE Alu.nombre='Nicolas'
AND Alu.apellido1='Bersabe'
AND Alu.apellido2='Alba'
AND M.alumno=Alu.dni
AND M.asignatura=Asi.codigo;

-- 5. Muestre el nombre, apellidos, nombre de la asignatura y las notas obtenidas por todos lo alumnos con más de 22 años. Utilice la función DECODE para mostrar la nota como (Matricula de Honor, Sobresaliente, Notable, Aprobado, Suspenso o No Presentado). Ordene por apellidos y nombre del alumno.
SELECT Alu.nombre, Alu.apellido1, Alu.apellido2, Asi.nombre, DECODE(M.calificacion, 'SP', 'Suspenso', 'AP', 'Aprobado', 'NT', 'Notable', 'SB', 'Sobresaliente', 'MH', 'Matricula de honor')
FROM alumnos Alu, asignaturas Asi, matricular M
WHERE MONTHS_BETWEEN(SYSDATE, Alu.fecha_nacimiento)>(22*12)
AND M.alumno=Alu.dni
AND M.asignatura=Asi.codigo
ORDER BY Alu.apellido1, Alu.apellido2, Alu.nombre DESC;

-- 6. Para cada profesor, proporcione el número de semanas completas que lleva trabajando en el departamento y diga que día se cumple un ciclo de semana completa. Use las funciones TO_CHAR y NEXT_DAY.
SELECT nombre, apellido1, apellido2, TRUNC((SYSDATE-antiguedad)/7), NEXT_DAY(SYSDATE-1, TO_CHAR(antiguedad, 'Day'))
FROM profesores;

-- 7. Utilice las operaciones de conjuntos para extraer los códigos de las asignaturas que no son impartidas por ningún profesor.
SELECT codigo
FROM asignaturas
WHERE codigo NOT IN(
	SELECT asignatura
	FROM impartir)
ORDER BY codigo ASC;

-- 8. Extraiga un listado único donde aparezca el NRP de los profesores, su nombre y apellidos así como el código de las asignaturas que imparte y su nombre.
SELECT p.nrp, p.nombre, p.apellido1, p.apellido2, a.codigo, a.nombre
FROM profesores p, impartir i, asignaturas a
WHERE (i.profesor=p.nrp)
AND (i.asignatura=a.codigo);

-- 9. Muestre todos los email almacenados en la base de datos. Si un email aparece repetido en dos tablas distintas también deberá aparecer repetido en la consulta. Evite los NULL.
SELECT email
FROM alumnos
WHERE email IS NOT NULL
UNION
SELECT email
FROM profesores
WHERE email IS NOT NULL;

-- 10. Utilice las operaciones de conjuntos para buscar alumnos que puedan ser familia de algún profesor, es decir, su primer o segundo apellido es el mismo que el primer o segundo apellido de un profesor aunque no necesariamente en el mismo orden. Muestre simplemente los apellidos comunes.
(SELECT apellido1
FROM profesores
UNION
SELECT apellido2
FROM profesores)
INTERSECT
(SELECT apellido1
FROM alumnos
UNION
SELECT apellido2
FROM alumnos);

-- 11. Nombre y apellidos de todos los alumnos a los que les de clase Enrique Soler. Cada alumno debe aparecer una sola vez. Ordénelos por apellidos, nombre.
SELECT nombre, apellido1, apellido2
FROM alumnos
INTERSECT 
SELECT a.nombre, a.apellido1, a.apellido2
FROM alumnos a, profesores p, impartir i, matricular m
WHERE a.dni = m.alumno
AND m.asignatura = i.asignatura
AND i.profesor = p.nrp
AND p.nombre = 'Enrique'
AND p.apellido1 = 'Soler'
AND i.turno = m.turno
ORDER BY apellido1, apellido2, nombre;

-- 12. Busque una incongruencia en la base de datos, es decir, asignaturas en las que el número de créditos teóricos + prácticos no sea igual al número de créditos totales. Muestre también los profesores que imparten esas asignaturas.
SELECT a.nombre, i.profesor
FROM asignaturas a
LEFT OUTER JOIN impartir i
ON a.codigo = i.asignatura
WHERE a.creditos<>(a.teoricos+a.practicos);

-- 13. Nombre y apellidos de 2 alumnas matriculadas de la asignatura de código 115.
SELECT *
FROM (SELECT DISTINCT nombre, apellido1, apellido2
	FROM alumnos alu, matricular m
	WHERE alu.sexo='FEM'
	AND m.alumno=alu.dni
	AND m.asignatura=115)
WHERE ROWNUM<=2;

-- 14. Muestre todos los datos de los profesores que no son directores de tesis.
SELECT *
FROM profesores
MINUS
SELECT p1.*
FROM profesores p1, profesores p2
WHERE p1.nrp=p2.director_tesis;

-- 15. Muestre en orden alfabético los nombres completos de todos los profesores y a su lado el de sus directores si es el caso (si no tenemos constancia de su director de tesis dejaremos este espacio en blanco, pero el profesor debe aparecer en el listado).
SELECT p1.nombre, p1.apellido1, p1.apellido2, p2.nombre, p2.apellido1, p2.apellido2
FROM profesores p1
LEFT OUTER JOIN profesores p2
ON p1.director_tesis=p2.nrp;
ORDER BY apellido1, apellido2, nombre;

-- 16. Apellidos que contienen la letra elle ( 'll' ) tanto de alumnos como de profesores.
SELECT apellido1
FROM alumnos
WHERE apellido1 like '%ll%'
UNION
SELECT apellido2
FROM alumnos
WHERE apellido2 like '%ll%'
UNION
SELECT apellido1
FROM profesores
WHERE apellido1 like '%ll%'
UNION
SELECT apellido2
FROM profesores
WHERE apellido2 like '%ll%';

-- 17. Idem que la anterior pero sustituya la 'll' por una 'y'. Utilice REPLACE.
SELECT REPLACE(apellido1,'ll','y')
FROM(
	SELECT apellido1
	FROM alumnos
	WHERE apellido1 like '%ll%'
	UNION
	SELECT apellido2
	FROM alumnos
	WHERE apellido2 like '%ll%'
	UNION
	SELECT apellido1
	FROM profesores
	WHERE apellido1 like '%ll%'
	UNION
	SELECT apellido2
	FROM profesores
	WHERE apellido2 like '%ll%'
);

-- 18. Nombre y apellidos de los alumnos matriculados en asignaturas impartidas por profesores del departamento de 'Lenguajes y Ciencias de la Computación'. El listado debe estar ordenado alfabéticamente
SELECT DISTINCT alu.nombre, alu.apellido1, alu.apellido2
FROM alumnos alu, matricular m, impartir i, departamentos d, profesores p
WHERE d.nombre like 'Lenguajes y Ciencias%'
AND d.codigo=p.departamento
AND i.profesor=p.nrp
AND i.asignatura=m.asignatura
AND m.alumno=alu.dni;

-- 19. Alumnos que tengan aprobada la asignatura 'Bases de Datos'
SELECT *
FROM alumnos alu, matricular m, asignaturas asi
WHERE asi.nombre like 'Bases de Datos'
AND m.asignatura=asi.codigo
AND m.calificacion<>'SP'
AND m.alumno=alu.dni;

-- 20. Construya un listado en el que se muestran todas las posibles emparejamientos heterosexuales que se pueden formar entre los alunos matriculados en la asignatura de código 112 donde la nota de la mujer es mayor que la del hombre y ambos se matricularon en la misma semana. En el listado muestre primero el nombre de la mujer y a continuación el del hombre. Etiquete las columnas como "Ella" y "El" respectivamente. Para el cálculo de la semana use la función de conversión TO_CHAR.
SELECT ella.nombre||' '||ella.apellido1||' '||ella.apellido2 "Ella", el.nombre||' '||el.apellido1||' '||el.apellido2 "El"
FROM (alumnos ella join matricular mella on mella.alumno=ella.dni), (alumnos el join matricular mel on mel.alumno=el.dni)
WHERE ella.sexo='FEM'
AND el.sexo='MASC'
AND mella.asignatura=112
AND mel.asignatura=112
AND DECODE(mella.calificacion, 'SP',0,'AP',1,'NT',2,'SB',3,'MH',4) > DECODE(mel.calificacion, 'SP',0,'AP',1,'NT',2,'SB',3,'MH',4)
AND TO_CHAR(el.fecha_prim_matricula,'YYYY')=TO_CHAR(ella.fecha_prim_matricula,'YYYY')
AND TO_CHAR(el.fecha_prim_matricula,'IW')=TO_CHAR(ella.fecha_prim_matricula,'IW');

-- 21. Liste el nombre y código de las asignaturas que tienen en su mismo curso otra con más créditos que ella.
SELECT DISTINCT asi.nombre, asi.codigo
FROM asignaturas asi, asignaturas aux
WHERE asi.curso=aux.curso
AND aux.creditos>asi.creditos;

-- 22. Use las operaciones de conjuntos y la consulta anterior para mostrar las asignaturas que tienen el máximo número de créditos de su curso.
SELECT nombre, codigo
FROM asignaturas
MINUS
SELECT DISTINCT asi.nombre, asi.codigo
FROM asignaturas asi, asignaturas aux
WHERE asi.curso=aux.curso
AND aux.creditos>asi.creditos;

-- 23. Liste el nombre de todos los alumnos ordenados alfabéticamente. Si dicho alumno tuviese otro alumno que se ha matriculado exactamente a la vez que él, muestre el nombre de este segundo alumno a su lado.
SELECT nombre, apellido1, apellido2, null, null, null
FROM alumnos
WHERE dni NOT IN(
	SELECT alu1.dni
	FROM (alumnos alu1 join alumnos alu2 on alu1.fecha_prim_matricula=alu2.fecha_prim_matricula)
	WHERE alu1.dni<>alu2.dni)
UNION
SELECT alu1.nombre, alu1.apellido1, alu1.apellido2, alu2.nombre, alu2.apellido1, alu2.apellido2
FROM (alumnos alu1 join alumnos alu2 on alu1.fecha_prim_matricula=alu2.fecha_prim_matricula)
WHERE alu1.dni<>alu2.dni
ORDER BY apellido1, apellido2, nombre;
