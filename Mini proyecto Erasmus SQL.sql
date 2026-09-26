¿Cuál es la edad promedio de los estudiantes que tienen calificaciones sobresalientes? Complete la tabla con EXCELENTE si tienen un 9 o un 10, BUENO si tienen un 7 u 8, APROBADO si tienen un 5 o un 6, y REPROBADO si tienen menos de 5.

SELECT
    CASE
        WHEN g.grades >= 9 THEN 'EXCELENTE'
        WHEN g.grades >= 7 THEN 'BUENO'
        WHEN g.grades >= 5 THEN 'APROBADO'
        ELSE 'SUSPENSO'
    END AS calificacion,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, s.dob, CURDATE())), 2) AS edad_media,
    COUNT(*) AS num_notas
FROM grades g
JOIN students s ON s.student_id = g.student_id
GROUP BY calificacion
ORDER BY FIELD(calificacion, 'EXCELENTE', 'BUENO', 'APROBADO', 'SUSPENSO');

¿Cuál es la edad media de los estudiantes por universidad?

SELECT u.university_id, u.uni_name,
       ROUND(AVG(TIMESTAMPDIFF(YEAR, t.dob, CURDATE())), 2) AS edad_media,
       COUNT(*) AS num_estudiantes
FROM (SELECT DISTINCT ia.home_university, s.student_id, s.dob
      FROM international_agreement ia
      JOIN students s ON s.student_id = ia.student_id) t
JOIN university u ON u.university_id = t.home_university
GROUP BY u.university_id, u.uni_name
ORDER BY edad_media DESC;

¿Cuál es la proporción de alumnos que suspendieron cada asignatura? Indique el nombre de la asignatura, el número de alumnos que suspendieron, el número total de alumnos y la proporción de alumnos que suspendieron (en porcentaje) para cada asignatura. Muestre los resultados en orden descendente según la proporción de alumnos que suspendieron.
SELECT sb.subj_name,
       SUM(CASE WHEN g.grades < 5 THEN 1 ELSE 0 END) AS suspensos,
       COUNT(*) AS total_alumnos,
       ROUND(100 * SUM(CASE WHEN g.grades < 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_suspensos
FROM grades g
JOIN subjects sb ON sb.subject_id = g.subject_id
GROUP BY sb.subject_id, sb.subj_name
ORDER BY pct_suspensos DESC;

¿Cuál es la nota media de los estudiantes que han realizado un Erasmus en comparación con los que no lo han hecho?
SELECT CASE WHEN e.student_id IS NULL THEN 'NO Erasmus' ELSE 'Erasmus' END AS grupo,
       ROUND(AVG(g.grades), 2) AS nota_media,
       COUNT(DISTINCT s.student_id) AS num_estudiantes
FROM students s
JOIN grades g ON g.student_id = s.student_id
LEFT JOIN (SELECT DISTINCT student_id FROM international_agreement) e
       ON e.student_id = s.student_id
GROUP BY grupo;

Para cada universidad, identifique el número de títulos de licenciatura, maestría y doctorado otorgados. Proporcione la identificación y el nombre de la universidad junto con el recuento de cada tipo de título.
SELECT u.university_id, u.uni_name,
       SUM(CASE WHEN b.bachelor_id LIKE 'B%' THEN 1 ELSE 0 END) AS grados,
       SUM(CASE WHEN b.bachelor_id LIKE 'M%' THEN 1 ELSE 0 END) AS masters,
       SUM(CASE WHEN b.bachelor_id LIKE 'D%' THEN 1 ELSE 0 END) AS doctorados
FROM university u
LEFT JOIN bachelor b ON b.university_id = u.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY u.university_id;

¿Cuáles son las 5 universidades con la clasificación media más alta a lo largo de los años? Indique el ID de la universidad, el nombre de la universidad y la clasificación media.
SELECT u.university_id, u.uni_name,
       ROUND(AVG(r.intl_ranking), 2) AS ranking_medio
FROM ranking r
JOIN university u ON u.university_id = r.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY ranking_medio ASC
LIMIT 5;

Proporcione el número de identificación, el nombre, los apellidos, el nombre de la universidad de origen y el correo electrónico de los 10 estudiantes que hayan participado más veces en un acuerdo internacional.
SELECT s.student_id, s.f_name, s.l_name, u.uni_name AS universidad_origen, s.email,
       COUNT(*) AS num_acuerdos
FROM international_agreement ia
JOIN students s ON s.student_id = ia.student_id
JOIN university u ON u.university_id = ia.home_university
GROUP BY s.student_id, s.f_name, s.l_name, u.uni_name, s.email
ORDER BY num_acuerdos DESC
LIMIT 10;

Realice una consulta en la que, modificando el número de acuerdo internacional, pueda identificar el identificador y el nombre del estudiante que realizó el intercambio, el nombre de la universidad de origen y el nombre de la ciudad donde tuvo lugar el intercambio.
SET @acuerdo = 'A2B3C';
SELECT ia.agreement_code,
       s.student_id,
       CONCAT(s.f_name, ' ', s.l_name) AS estudiante,
       uh.uni_name AS universidad_origen,
       ua.uni_name AS universidad_destino,
       c.city       AS ciudad_intercambio
FROM international_agreement ia
JOIN students   s  ON s.student_id    = ia.student_id
JOIN university uh ON uh.university_id = ia.home_university
JOIN university ua ON ua.university_id = ia.away_university
JOIN campus     c  ON c.campus_id = (SELECT MIN(campus_id) FROM campus
                                     WHERE university_id = ia.away_university)
WHERE ia.agreement_code = @acuerdo;

Bonus: Ahora puede intentar utilizar procedimientos para parametrizar la consulta.
DELIMITER $
CREATE PROCEDURE sp_acuerdo(IN p_codigo VARCHAR(5))
BEGIN
    SELECT ia.agreement_code, s.student_id,
           CONCAT(s.f_name,' ',s.l_name) AS estudiante,
           uh.uni_name AS universidad_origen,
           c.city AS ciudad_intercambio
    FROM international_agreement ia
    JOIN students   s  ON s.student_id     = ia.student_id
    JOIN university uh ON uh.university_id = ia.home_university
    JOIN campus     c  ON c.campus_id = (SELECT MIN(campus_id) FROM campus
                                         WHERE university_id = ia.away_university)
    WHERE ia.agreement_code = p_codigo;
END$
DELIMITER ;
CALL sp_acuerdo('A2B3C');

Busque y muestre el número de universidades que ofrecen cada asignatura, junto con la nota media de cada asignatura.
SELECT sb.subject_id, sb.subj_name,
       (SELECT COUNT(DISTINCT us.university_id)
        FROM uni_subj us WHERE us.subject_id = sb.subject_id) AS num_universidades,
       (SELECT ROUND(AVG(g.grades), 2)
        FROM grades g WHERE g.subject_id = sb.subject_id)     AS nota_media
FROM subjects sb
ORDER BY num_universidades DESC, nota_media DESC;

Encuentre las 5 ciudades con el mayor porcentaje de estudiantes con calificaciones sobresalientes (9 o 10). Indique la ciudad, el estado y el porcentaje de estudiantes sobresalientes de cada ciudad.
SELECT s.city, s.state,
       COUNT(DISTINCT s.student_id) AS total_estudiantes,
       COUNT(DISTINCT CASE WHEN g.grades >= 9 THEN s.student_id END) AS sobresalientes,
       ROUND(100 * COUNT(DISTINCT CASE WHEN g.grades >= 9 THEN s.student_id END)
             / COUNT(DISTINCT s.student_id), 2) AS pct_sobresalientes
FROM students s
JOIN grades g ON g.student_id = s.student_id
GROUP BY s.city, s.state
ORDER BY pct_sobresalientes DESC
LIMIT 5;

Compara las universidades que envían más estudiantes con las universidades que reciben más estudiantes. Hazlo en dos consultas.
-- Envían
SELECT u.university_id, u.uni_name, COUNT(*) AS estudiantes_enviados
FROM international_agreement ia
JOIN university u ON u.university_id = ia.home_university
GROUP BY u.university_id, u.uni_name
ORDER BY estudiantes_enviados DESC;
-- Reciben
SELECT u.university_id, u.uni_name, COUNT(*) AS estudiantes_recibidos
FROM international_agreement ia
JOIN university u ON u.university_id = ia.away_university
GROUP BY u.university_id, u.uni_name
ORDER BY estudiantes_recibidos DESC;

Bonus: Ahora puede intentar unir ambas consultas utilizando el operador «UNION ALL».

SELECT 'ENVIA' AS tipo, u.uni_name, COUNT(*) AS num_estudiantes
FROM international_agreement ia
JOIN university u ON u.university_id = ia.home_university
GROUP BY u.uni_name
UNION ALL
SELECT 'RECIBE', u.uni_name, COUNT(*)
FROM international_agreement ia
JOIN university u ON u.university_id = ia.away_university
GROUP BY u.uni_name
ORDER BY tipo, num_estudiantes DESC;