INSERT INTO course_application_employees (application_id, employee_id, application_status)
SELECT (SELECT id
        FROM course_applications
        WHERE course_id = (SELECT id FROM courses WHERE title = 'Курс 1')
          AND submitted_by = (SELECT id FROM users WHERE email = 'org1@manas.kg')),
       (SELECT id FROM users WHERE email = 'student11@manas.kg'),
       'PENDING' WHERE NOT EXISTS (
    SELECT 1 FROM course_application_employees
    WHERE employee_id = (SELECT id FROM users WHERE email = 'student11@manas.kg')
);

INSERT INTO course_application_employees (application_id, employee_id, application_status)
SELECT (SELECT id
        FROM course_applications
        WHERE course_id = (SELECT id FROM courses WHERE title = 'Курс 1')
          AND submitted_by = (SELECT id FROM users WHERE email = 'org1@manas.kg')),
       (SELECT id FROM users WHERE email = 'student12@manas.kg'),
       'PENDING' WHERE NOT EXISTS (
    SELECT 1 FROM course_application_employees
    WHERE employee_id = (SELECT id FROM users WHERE email = 'student12@manas.kg')
);

INSERT INTO course_application_employees (application_id, employee_id, application_status)
SELECT (SELECT id
        FROM course_applications
        WHERE course_id = (SELECT id FROM courses WHERE title = 'Курс 1')
          AND submitted_by = (SELECT id FROM users WHERE email = 'org1@manas.kg')),
       (SELECT id FROM users WHERE email = 'student13@manas.kg'),
       'PENDING' WHERE NOT EXISTS (
    SELECT 1 FROM course_application_employees
    WHERE employee_id = (SELECT id FROM users WHERE email = 'student13@manas.kg')
);