-- Task 3.1 Show the number of lessons given per month during a specified year.
CREATE OR REPLACE VIEW monthly_lessons_summary AS
WITH lesson_data AS ( 
    SELECT 
        TO_CHAR(start_time, 'Mon') AS month, 
        EXTRACT(YEAR FROM start_time) AS year, 
        'Individual' AS lesson_type 
    FROM individual_lesson 
    UNION ALL 
    SELECT 
        TO_CHAR(start_time, 'Mon') AS month, 
        EXTRACT(YEAR FROM start_time) AS year, 
        'Group' AS lesson_type 
    FROM group_lesson 
    UNION ALL 
    SELECT 
        TO_CHAR(start_time, 'Mon') AS month, 
        EXTRACT(YEAR FROM start_time) AS year, 
        'Ensemble' AS lesson_type 
    FROM ensemble 
) 
SELECT 
    month, 
    COUNT(*) AS total, 
    SUM(CASE WHEN lesson_type = 'Individual' THEN 1 ELSE 0 END) AS individual, 
    SUM(CASE WHEN lesson_type = 'Group' THEN 1 ELSE 0 END) AS group, 
    SUM(CASE WHEN lesson_type = 'Ensemble' THEN 1 ELSE 0 END) AS ensemble 
FROM lesson_data 
WHERE year = 2024 
GROUP BY month 
ORDER BY TO_DATE(month, 'Mon');

SELECT * FROM monthly_lessons_summary;


-- Task 3.2 Show how many students there are with no sibling, with one sibling, with two siblings, etc
CREATE MATERIALIZED VIEW student_sibling_distribution AS
WITH sibling_counts AS ( 
    SELECT 
    p.person_id, 
    COUNT(ps.sibling_id) AS number_of_siblings 
    FROM person p 
    LEFT JOIN person_sibling ps ON p.person_id = ps.person_id 
    GROUP BY p.person_id 
) 
SELECT 
    number_of_siblings, 
    COUNT(person_id) AS number_of_students 
FROM sibling_counts 
GROUP BY number_of_siblings 
ORDER BY number_of_siblings;

SELECT * FROM student_sibling_distribution;


-- Task 3.3 List ids and names of all instructors who has given more than a specific number of lessons during the current month.
SELECT 
    instructor.instructor_id AS "Instructor Id", 
    person.name AS "Full Name", 
    person.address AS "Address", 
    COUNT(*) AS "No of Lessons" 
FROM 
    instructor 
JOIN 
    person ON instructor.person_id = person.person_id 
JOIN LATERAL ( 
    SELECT start_time AS lesson_date 
    FROM person_individual_lesson 
    JOIN individual_lesson ON person_individual_lesson.individual_lesson_id = individual_lesson.individual_lesson_id 
    WHERE person_individual_lesson.person_id = instructor.person_id 
    UNION ALL 
    SELECT start_time AS lesson_date 
    FROM person_group_lesson 
    JOIN group_lesson ON person_group_lesson.group_lesson_id = group_lesson.group_lesson_id 
    WHERE person_group_lesson.person_id = instructor.person_id 
    UNION ALL 
    SELECT start_time AS lesson_date 
    FROM person_ensemble 
    JOIN ensemble ON person_ensemble.ensemble_id = ensemble.ensemble_id 
    WHERE person_ensemble.person_id = instructor.person_id 
) AS all_lessons ON TRUE 
WHERE 
    EXTRACT(MONTH FROM all_lessons.lesson_date) = EXTRACT(MONTH FROM CURRENT_DATE) 
    AND EXTRACT(YEAR FROM all_lessons.lesson_date) = EXTRACT(YEAR FROM CURRENT_DATE) 
GROUP BY 
    instructor.instructor_id, person.name, person.address 
HAVING 
    COUNT(*) > 1  -- Lesson threshold variable
ORDER BY 
    "No of Lessons" DESC; 


-- Task 3.4 List all ensembles held during the next week
CREATE OR REPLACE VIEW ensemble_availability AS
SELECT 
    TO_CHAR(start_time, 'Dy') AS "Day", 
    genre AS "Genre", 
    CASE 
        WHEN max_participants - COALESCE(enrolled_participants, 0) = 0 THEN 'No Seats' 
        WHEN max_participants - COALESCE(enrolled_participants, 0) <= 2 THEN '1 or 2 Seats' 
        ELSE 'Many Seats' 
    END AS "No of Free Seats" 
FROM 
    ensemble 
LEFT JOIN ( 
    SELECT 
        ensemble_id, 
        COUNT(*) AS enrolled_participants 
    FROM 
        person_ensemble 
    GROUP BY 
        ensemble_id 
) AS enrollment ON ensemble.ensemble_id = enrollment.ensemble_id  
WHERE 
    start_time >= CURRENT_DATE  
    AND start_time < CURRENT_DATE + INTERVAL '7 days' 
ORDER BY 
    TO_CHAR(start_time, 'Dy'), 
    genre;

SELECT * FROM ensemble_availability; 
