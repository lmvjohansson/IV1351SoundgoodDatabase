CREATE TABLE historical_lessons (
    lesson_type VARCHAR(50) NOT NULL,
    genre VARCHAR(100),
    instrument VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    student_name VARCHAR(500) NOT NULL,
    student_email VARCHAR(500)
);

INSERT INTO historical_lessons (lesson_type, instrument, price, student_name, student_email)
SELECT 'Individual', it.instrument_type, ps.price, p.name, p.email
FROM individual_lesson il
JOIN person_individual_lesson pil ON il.individual_lesson_id = pil.individual_lesson_id
JOIN person p ON pil.person_id = p.person_id
JOIN pricing_scheme ps ON il.pricing_scheme_id = ps.pricing_scheme_id
JOIN instrument_type it ON il.instrument_type_id = it.instrument_type_id
WHERE p.person_id NOT IN (SELECT person_id FROM instructor);

INSERT INTO historical_lessons (lesson_type, instrument, price, student_name, student_email)
SELECT 'Group', it.instrument_type, ps.price, p.name, p.email
FROM group_lesson gl
JOIN person_group_lesson pgl ON gl.group_lesson_id = pgl.group_lesson_id
JOIN person p ON pgl.person_id = p.person_id
JOIN pricing_scheme ps ON gl.pricing_scheme_id = ps.pricing_scheme_id
JOIN instrument_type it ON gl.instrument_type_id = it.instrument_type_id
WHERE p.person_id NOT IN (SELECT person_id FROM instructor);

INSERT INTO historical_lessons (lesson_type, genre, price, student_name, student_email)
SELECT 'Ensemble', e.genre, ps.price, p.name, p.email
FROM ensemble e
JOIN person_ensemble pe ON e.ensemble_id = pe.ensemble_id
JOIN person p ON pe.person_id = p.person_id
JOIN pricing_scheme ps ON e.pricing_scheme_id = ps.pricing_scheme_id
WHERE p.person_id NOT IN (SELECT person_id FROM instructor);

SELECT * FROM historical_lessons;
