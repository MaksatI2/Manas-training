INSERT INTO users (email, password_hash, first_name, last_name, phone, avatar_url, role_id, is_active)
VALUES ('student11@manas.kg', '$2a$12$NCu.brS1wyBZXyZz08m8weRonzZBpeCAPBJAfpdA8/6j4J8DtzrhW', 'Student4', 'Михайлов',
        '+996700000022', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
       ('student12@manas.kg', '$2a$12$NCu.brS1wyBZXyZz08m8weRonzZBpeCAPBJAfpdA8/6j4J8DtzrhW', 'Student5', 'Егоров',
        '+996700000023', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
       ('student13@manas.kg', '$2a$12$NCu.brS1wyBZXyZz08m8weRonzZBpeCAPBJAfpdA8/6j4J8DtzrhW', 'Student6', 'Федоров',
        '+996700000024', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true);

INSERT INTO student_profiles (user_id, organization_id, specialization)
VALUES ((SELECT id FROM users WHERE email = 'student11@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG001'),
        'Avionics'),
       ((SELECT id FROM users WHERE email = 'student12@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG001'),
        'Avionics'),
       ((SELECT id FROM users WHERE email = 'student13@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG001'),
        'Avionics');

INSERT INTO course_applications (course_id,
                                 organization_id,
                                 submitted_by,
                                 status,
                                 submitted_at)
SELECT (SELECT id FROM courses WHERE title = 'Курс 1'),
       (SELECT id FROM organizations WHERE code = 'ORG001'),
       (SELECT id FROM users WHERE email = 'org1@manas.kg'),
       'PENDING',
       NOW() WHERE NOT EXISTS (
    SELECT 1 FROM course_applications
    WHERE course_id = (SELECT id FROM courses WHERE title = 'Курс 1')
      AND submitted_by = (SELECT id FROM users WHERE email = 'org1@manas.kg')
);

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