-- Relación DML 2 - Reuniones y Operaciones de Conjuntos

-- 1. Nombre y apellidos de los profesores del departamento de Lenguajes.

-- 2. Nombre y apellidos de parejas de profesores cuya diferencia de antigüedad sea inferior a dos años y pertenezcan al mismo departamento. Muestre la antigüedad de cada uno de ellos en años.

-- 3. Muestre el nombre y apellidos de cada profesor junto con su director de tesis y el número de sexenios del director. Los nombres de cada profesor y su director deben aparecer con el siguiente formato: 'El Director de Angel Mora Bonilla es Manuel Enciso Garcia-Oliveros'

-- 4. Usando la función NVL extraiga un listado con el código y el nombre de las asignaturas de las que está matriculado 'Nicolas Bersabe Alba'. Proporcione además el número de créditos prácticos, pero caso de ser nulo, debe salir "no tiene" en el listado. Indicación: advierta que practicos es NUMBER y el literal 'No tiene' es VARCHAR2.

-- 5. Muestre el nombre, apellidos, nombre de la asignatura y las notas obtenidas por todos lo alumnos con más de 22 años. Utilice la función DECODE para mostrar la nota como (Matricula de Honor, Sobresaliente, Notable, Aprobado, Suspenso o No Presentado). Ordene por apellidos y nombre del alumno.

-- 6. Para cada profesor, proporcione el número de semanas completas que lleva trabajando en el departamento y diga que día se cumple un ciclo de semana completa. Use las funciones TO_CHAR y NEXT_DAY.

-- 7. Utilice las operaciones de conjuntos para extraer los códigos de las asignaturas que no son impartidas por ningún profesor.

-- 8. Extraiga un listado único donde aparezca el NRP de los profesores, su nombre y apellidos así como el código de las asignaturas que imparte y su nombre.

-- 9. Muestre todos los email almacenados en la base de datos. Si un email aparece repetido en dos tablas distintas también deberá aparecer repetido en la consulta. Evite los NULL.

-- 10. Utilice las operaciones de conjuntos para buscar alumnos que puedan ser familia de algún profesor, es decir, su primer o segundo apellido es el mismo que el primer o segundo apellido de un profesor aunque no necesariamente en el mismo orden. Muestre simplemente los apellidos comunes.

-- 11. Nombre y apellidos de todos los alumnos a los que les de clase Enrique Soler. Cada alumno debe aparecer una sola vez. Ordénelos por apellidos, nombre.

-- 12. Busque una incongruencia en la base de datos, es decir, asignaturas en las que el número de créditos teóricos + prácticos no sea igual al número de créditos totales. Muestre también los profesores que imparten esas asignaturas.

-- 13. Nombre y apellidos de 2 alumnas matriculadas de la asignatura de código 115.

-- 14. Muestre todos los datos de los profesores que no son directores de tesis.

-- 15. Muestre en orden alfabético los nombres completos de todos los profesores y a su lado el de sus directores si es el caso (si no tenemos constancia de su director de tesis dejaremos este espacio en blanco, pero el profesor debe aparecer en el listado).

-- 16. Apellidos que contienen la letra elle ( 'll' ) tanto de alumnos como de profesores.

-- 17. Idem que la anterior pero sustituya la 'll' por una 'y'. Utilice REPLACE.

-- 18. Nombre y apellidos de los alumnos matriculados en asignaturas impartidas por profesores del departamento de 'Lenguajes y Ciencias de la Computación'. El listado debe estar ordenado alfabéticamente

-- 19. Alumnos que tengan aprobada la asignatura 'Bases de Datos'

-- 20. Construya un listado en el que se muestran todas las posibles emparejamientos heterosexuales que se pueden formar entre los alunos matriculados en la asignatura de código 112 donde la nota de la mujer es mayor que la del hombre y ambos se matricularon en la misma semana. En el listado muestre primero el nombre de la mujer y a continuación el del hombre. Etiquete las columnas como "Ella" y "El" respectivamente. Para el cálculo de la semana use la función de conversión TO_CHAR.

-- 21. Liste el nombre y código de las asignaturas que tienen en su mismo curso otra con más créditos que ella.

-- 22. Use las operaciones de conjuntos y la consulta anterior para mostrar las asignaturas que tienen el máximo número de créditos de su curso.

-- 23. Liste el nombre de todos los alumnos ordenados alfabéticamente. Si dicho alumno tuviese otro alumno que se ha matriculado exactamente a la vez que él, muestre el nombre de este segundo alumno a su lado.
