INSERT INTO course_teachers (course_id, teacher_id)
VALUES (
        (SELECT id FROM courses WHERE title = 'Курс 1' LIMIT 1),
       (SELECT id FROM users WHERE email = 'teacher1@manas.kg' LIMIT 1)
    ),
(
        (SELECT id FROM courses WHERE title = 'Курс 1' LIMIT 1),
       (SELECT id FROM users WHERE email = 'teacher2@manas.kg' LIMIT 1)
    );
