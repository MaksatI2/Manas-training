INSERT INTO course_applications (course_id, organization_id, organization_application_number, submitted_by, preferred_teacher_id, preferred_start_date, preferred_end_date, status, submitted_at, processed_by, processed_at)
VALUES

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM organizations WHERE code = 'ORG001'), 'APP-ORG001-1', (SELECT id FROM users WHERE email = 'org1@manas.kg'), NULL, '2025-07-01', '2025-07-15', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM organizations WHERE code = 'ORG001'), 'APP-ORG001-2', (SELECT id FROM users WHERE email = 'org1@manas.kg'), NULL, '2025-08-01', '2025-08-12', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM organizations WHERE code = 'ORG002'), 'APP-ORG002-1', (SELECT id FROM users WHERE email = 'org2@manas.kg'), NULL, '2025-07-02', '2025-07-12', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),
    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM organizations WHERE code = 'ORG002'), 'APP-ORG002-2', (SELECT id FROM users WHERE email = 'org2@manas.kg'), NULL, '2025-08-02', '2025-08-15', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM organizations WHERE code = 'ORG003'), 'APP-ORG003-1', (SELECT id FROM users WHERE email = 'org3@manas.kg'), NULL, '2025-07-03', '2025-07-20', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),
    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM organizations WHERE code = 'ORG003'), 'APP-ORG003-2', (SELECT id FROM users WHERE email = 'org3@manas.kg'), NULL, '2025-08-03', '2025-08-10', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM organizations WHERE code = 'ORG004'), 'APP-ORG004-1', (SELECT id FROM users WHERE email = 'org4@manas.kg'), NULL, '2025-07-04', '2025-07-18', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),
    ((SELECT id FROM courses WHERE code = 'C-008'), (SELECT id FROM organizations WHERE code = 'ORG004'), 'APP-ORG004-2', (SELECT id FROM users WHERE email = 'org4@manas.kg'), NULL, '2025-08-04', '2025-08-25', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM organizations WHERE code = 'ORG005'), 'APP-ORG005-1', (SELECT id FROM users WHERE email = 'org5@manas.kg'), NULL, '2025-07-05', '2025-07-12', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM organizations WHERE code = 'ORG005'), 'APP-ORG005-2', (SELECT id FROM users WHERE email = 'org5@manas.kg'), NULL, '2025-08-05', '2025-08-12', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-007'), (SELECT id FROM organizations WHERE code = 'ORG006'), 'APP-ORG006-1', (SELECT id FROM users WHERE email = 'org6@manas.kg'), NULL, '2025-07-06', '2025-07-22', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM organizations WHERE code = 'ORG007'), 'APP-ORG007-1', (SELECT id FROM users WHERE email = 'org7@manas.kg'), NULL, '2025-07-07', '2025-07-20', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM organizations WHERE code = 'ORG008'), 'APP-ORG008-1', (SELECT id FROM users WHERE email = 'org8@manas.kg'), NULL, '2025-07-08', '2025-07-22', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM organizations WHERE code = 'ORG009'), 'APP-ORG009-1', (SELECT id FROM users WHERE email = 'org9@manas.kg'), NULL, '2025-07-09', '2025-07-19', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM organizations WHERE code = 'ORG010'), 'APP-ORG010-1', (SELECT id FROM users WHERE email = 'org10@manas.kg'), NULL, '2025-07-10', '2025-07-27', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM organizations WHERE code = 'ORG011'), 'APP-ORG011-1', (SELECT id FROM users WHERE email = 'org11@manas.kg'), NULL, '2025-07-11', '2025-07-18', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-007'), (SELECT id FROM organizations WHERE code = 'ORG012'), 'APP-ORG012-1', (SELECT id FROM users WHERE email = 'org12@manas.kg'), NULL, '2025-07-12', '2025-07-28', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM organizations WHERE code = 'ORG013'), 'APP-ORG013-1', (SELECT id FROM users WHERE email = 'org13@manas.kg'), NULL, '2025-07-13', '2025-07-26', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM organizations WHERE code = 'ORG014'), 'APP-ORG014-1', (SELECT id FROM users WHERE email = 'org14@manas.kg'), NULL, '2025-07-14', '2025-07-28', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL),

    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM organizations WHERE code = 'ORG015'), 'APP-ORG015-1', (SELECT id FROM users WHERE email = 'org15@manas.kg'), NULL, '2025-07-15', '2025-07-25', 'PENDING', CURRENT_TIMESTAMP, NULL, NULL);

INSERT INTO course_application_employees (application_id, employee_id, application_status)
VALUES

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG001-1'), (SELECT id FROM users WHERE email = 'student1@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG001-1'), (SELECT id FROM users WHERE email = 'student11@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG001-1'), (SELECT id FROM users WHERE email = 'student12@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG001-2'), (SELECT id FROM users WHERE email = 'student13@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG001-2'), (SELECT id FROM users WHERE email = 'student16@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG002-1'), (SELECT id FROM users WHERE email = 'student2@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG002-1'), (SELECT id FROM users WHERE email = 'student17@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG002-1'), (SELECT id FROM users WHERE email = 'student32@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG002-2'), (SELECT id FROM users WHERE email = 'student47@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG002-2'), (SELECT id FROM users WHERE email = 'student62@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG003-1'), (SELECT id FROM users WHERE email = 'student3@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG003-1'), (SELECT id FROM users WHERE email = 'student18@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG003-1'), (SELECT id FROM users WHERE email = 'student33@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG003-2'), (SELECT id FROM users WHERE email = 'student48@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG003-2'), (SELECT id FROM users WHERE email = 'student63@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG004-1'), (SELECT id FROM users WHERE email = 'student4@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG004-1'), (SELECT id FROM users WHERE email = 'student19@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG004-1'), (SELECT id FROM users WHERE email = 'student34@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG004-2'), (SELECT id FROM users WHERE email = 'student49@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG004-2'), (SELECT id FROM users WHERE email = 'student64@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG005-1'), (SELECT id FROM users WHERE email = 'student5@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG005-1'), (SELECT id FROM users WHERE email = 'student20@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG005-1'), (SELECT id FROM users WHERE email = 'student35@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG005-2'), (SELECT id FROM users WHERE email = 'student50@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications where organization_application_number = 'APP-ORG005-2'), (SELECT id FROM users WHERE email = 'student65@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG006-1'), (SELECT id FROM users WHERE email = 'student6@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG006-1'), (SELECT id FROM users WHERE email = 'student21@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG006-1'), (SELECT id FROM users WHERE email = 'student36@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG007-1'), (SELECT id FROM users WHERE email = 'student7@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG007-1'), (SELECT id FROM users WHERE email = 'student22@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG007-1'), (SELECT id FROM users WHERE email = 'student37@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG008-1'), (SELECT id FROM users WHERE email = 'student8@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG008-1'), (SELECT id FROM users WHERE email = 'student23@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG009-1'), (SELECT id FROM users WHERE email = 'student9@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG009-1'), (SELECT id FROM users WHERE email = 'student24@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG010-1'), (SELECT id FROM users WHERE email = 'student10@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG010-1'), (SELECT id FROM users WHERE email = 'student25@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG011-1'), (SELECT id FROM users WHERE email = 'student26@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG011-1'), (SELECT id FROM users WHERE email = 'student41@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG012-1'), (SELECT id FROM users WHERE email = 'student27@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG012-1'), (SELECT id FROM users WHERE email = 'student42@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG013-1'), (SELECT id FROM users WHERE email = 'student43@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG013-1'), (SELECT id FROM users WHERE email = 'student58@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG014-1'), (SELECT id FROM users WHERE email = 'student14@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG014-1'), (SELECT id FROM users WHERE email = 'student58@manas.kg'), 'PENDING'),

    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG015-1'), (SELECT id FROM users WHERE email = 'student15@manas.kg'), 'PENDING'),
    ((SELECT id FROM course_applications WHERE organization_application_number = 'APP-ORG015-1'), (SELECT id FROM users WHERE email = 'student30@manas.kg'), 'PENDING');