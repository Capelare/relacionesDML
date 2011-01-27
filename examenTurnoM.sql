-- [1]: Para aquellos profesores que tienen una antigüedad de más de 40 años, muestre el nombre y dos apellidos junto con su fecha de nacimiento. La fecha de nacimiento debe aparecer con el formato año/Nombre_completo_del_mes (sin añadir nada entre ambos elementos).
SELECT p.nombre, p.apellido1, p.apellido2, to_char(p.fecha_nacimiento, 'YYYY/fmMonth')
FROM profesores p
WHERE MONTHS_BETWEEN(SYSDATE,p.antiguedad)>40*12;

-- [2]: Extraiga el nombre de aquellas asignaturas para aquellas asignaturas que no son impartidas nunca en turno de tarde (grupo B).
SELECT nombre
FROM asignaturas
WHERE nombre NOT IN(
	SELECT asi.nombre
	FROM asignaturas asi JOIN impartir i ON i.asignatura=asi.codigo
	WHERE i.turno='B'
);

-- [3]: Proporcione el nombre de los departamentos, el nombre de las asignaturas y el nombre completo de los profesores que las imparten en turno de mañana (su grupo es A) y donde existe al menos un alumno sin calificar en la asignatura (su nota es nula) en el mismo grupo A.
SELECT d.nombre DEPARTAMENTO, asi.nombre ASIGNATURA, p.nombre||' '||p.apellido1||' '||p.apellido2 PROFESOR
FROM (((departamentos d
JOIN asignaturas asi ON asi.departamento=d.codigo)
JOIN impartir i ON i.asignatura=asi.codigo)
JOIN profesores p ON p.nrp=i.profesor)
WHERE i.turno='A'
AND i.asignatura IN(
	SELECT m.asignatura
	FROM matricular m
	WHERE m.turno='A'
	AND m.calificacion IS NULL
);

-- [4]: Deseamos calcular para cada alumno, la suma de todos los créditos que ya ha superado. Pero daremos el número de esta suma según sea su carácter: troncales, obligatorios, optativos, etc.
SELECT DISTINCT alu.dni, (SELECT SUM(asi.creditos)
	FROM asignaturas asi, matricular m
	WHERE asi.caracter LIKE 'TR'
	AND asi.codigo = m.asignatura
	AND m.alumno = alu.dni
	AND m.calificacion NOT LIKE 'SP'
	AND m.calificacion IS NOT NULL
) "TRONCALES", (SELECT SUM(asi.creditos)
	FROM asignaturas asi, matricular m
	WHERE asi.caracter LIKE 'OB'
	AND asi.codigo = m.asignatura
	AND m.alumno = alu.dni
	AND m.calificacion NOT LIKE 'SP'
	AND m.calificacion IS NOT NULL
) "OBLIGATORIOS", (SELECT SUM(asi.creditos)
	FROM asignaturas asi, matricular m
	WHERE asi.caracter LIKE 'OP'
	AND asi.codigo = m.asignatura
	AND m.alumno = alu.dni
	AND m.calificacion NOT LIKE 'SP'
	AND m.calificacion IS NOT NULL
) "OPTATIVOS", (SELECT SUM(asi.creditos)
	FROM asignaturas asi, matricular m
	WHERE asi.caracter NOT LIKE 'O_'
	AND asi.caracter NOT LIKE 'TR'
	AND asi.codigo=m.asignatura
	AND m.alumno=alu.dni
	AND m.calificacion NOT LIKE 'SP'
	AND m.calificacion IS NOT NULL
) "RESTO"
FROM alumnos alu;

-- [5]: Asignaremos a cada calificación una nota del modo siguiente: matrícula de honor (10), sobresaliente (9), notable (8),
--		aprobado (6) y suspenso (4). Utilice la función DECODE para este cáclulo. Queremos calcular la media de notas que cada
--		profesor pone, independientemente de la asignatura. Se este modo sabremos si un profesor es dado a poner buenas notas o no.
--		Para no viciar el resultado, sólo tendremos en cuenta aquellos profesores para los que tenemos información de al menos
--		5 alumnos calificados. El valor de la media debe darse sin decimales, no haciendo redondeo sino eliminando los decimales.
-- DECODE(calificacion,'MH',10,'SB',9,'NT',8,'AP',6,'SP',4,NULL)

SELECT p.nombre||' '||p.apellido1||' '||p.apellido2 PROFESOR, TRUNC(AVG(DECODE(m.calificacion,'MH',10,'SB',9,'NT',8,'AP',6,'SP',4,NULL))) MEDIA
FROM (profesores p JOIN impartir i ON p.nrp=i.profesor) NATURAL JOIN matricular m
WHERE m.calificacion IS NOT NULL
GROUP BY p.nombre||' '||p.apellido1||' '||p.apellido2
HAVING COUNT(m.calificacion)>=5;

SELECT p.nombre||' '||p.apellido1||' '||p.apellido2 PROFESOR, COUNT(m.calificacion) NOTAS
FROM (profesores p JOIN impartir i ON p.nrp=i.profesor) NATURAL JOIN matricular m
WHERE m.calificacion IS NOT NULL
GROUP BY p.nombre||' '||p.apellido1||' '||p.apellido2
HAVING COUNT(m.calificacion)>=5;


-- [6]: Liste el nombre y dos apellidos de todos los profesores. Si dicho profesor imparte alguna asignatura, saque el nombre de dicha asignatura junto al del profesor.

SELECT DISTINCT p.nombre, p.apellido1, p.apellido2, asi.nombre
FROM (asignaturas asi JOIN impartir i ON i.asignatura=asi.codigo) RIGHT OUTER JOIN profesores p ON i.profesor=p.nrp;
