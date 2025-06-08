-- changeset Aislan: 025 add insert_test_data table

-- Роли пользователей
INSERT INTO roles (name)
VALUES ('ADMIN'),
       ('TEACHER'),
       ('STUDENT');

-- Пользователи
-- Пароль для админа: qwerty12345
-- Пароль для остальных: qwerty1234Q
INSERT INTO users (email, password_hash, first_name, last_name, phone, avatar_url, role_id, is_active)
VALUES
    ('admin@manas.kg',   '$2a$12$TH2gXNw.3eyUuK7uTwqCq.sbAnKDtOnacS6bEB9.v8vjIMQJDIN06', 'Admin',    'System', '+996700000001', NULL, (SELECT id FROM roles WHERE name = 'ADMIN'), true),
    ('teacher1@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Teacher1', 'One',    '+996700000002', NULL, (SELECT id FROM roles WHERE name = 'TEACHER'), true),
    ('teacher2@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Teacher2', 'Two',    '+996700000003', NULL, (SELECT id FROM roles WHERE name = 'TEACHER'), true),
    ('student1@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student1', 'Викторов',      '+996700000004', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
    ('student2@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student2', 'Менторов',      '+996700000005', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
    ('student3@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student3', 'Сидоров',      '+996700000006', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
    ('student4@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student4', 'Михайлов',      '+996700000007', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
    ('student5@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student5', 'Егоров',      '+996700000008', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
    ('student6@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student6', 'Федоров',      '+996700000009', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true),
    ('student7@manas.kg','$2a$12$sla1x0XggsF73cl.Fw797uEnr1rbMu3kFxW1fBqo7kC3DDW5xTLzO', 'Student7', 'Григорьев',      '+996700000010', NULL, (SELECT id FROM roles WHERE name = 'STUDENT'), true);

-- Организации
INSERT INTO organizations (user_id, code, description)
VALUES
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG001', 'Организация 1'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG002', 'Организация 2'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG003', 'Организация 3'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG004', 'Организация 4'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG005', 'Организация 5'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG006', 'Организация 6'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG007', 'Организация 7'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG008', 'Организация 8'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG009', 'Организация 9'),
    ((SELECT id FROM users WHERE email = 'admin@manas.kg'), 'ORG010', 'Организация 10');

-- Студенты
INSERT INTO student_profiles (user_id, organization_id, specialization)
VALUES
    ((SELECT id FROM users WHERE email = 'student1@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG001'), 'Avionics'),
    ((SELECT id FROM users WHERE email = 'student2@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG002'), 'Safety'),
    ((SELECT id FROM users WHERE email = 'student3@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG003'), 'Ground Services'),
    ((SELECT id FROM users WHERE email = 'student4@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG004'), 'Mechanics'),
    ((SELECT id FROM users WHERE email = 'student5@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG005'), 'Cabin Crew'),
    ((SELECT id FROM users WHERE email = 'student6@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG006'), 'Cargo'),
    ((SELECT id FROM users WHERE email = 'student7@manas.kg'), (SELECT id FROM organizations WHERE code = 'ORG007'), 'Navigation');

-- Преподаватели
INSERT INTO teacher_profiles (user_id, department, qualifications, bio)
VALUES
    ((SELECT id FROM users WHERE email = 'teacher1@manas.kg'), 'Aviation', 'Master', 'Senior instructor'),
    ((SELECT id FROM users WHERE email = 'teacher2@manas.kg'), 'Engineering', 'PhD', 'Experienced engineer');

-- Категории курсов
INSERT INTO course_categories (name, description)
VALUES
    ('ТО ВС', 'Техобслуживание ВС'),
    ('Безопасность', 'Безопасность на борту'),
    ('Обслуживание пассажиров', 'Курс по сервису'),
    ('Наземные службы', 'Работа с багажом'),
    ('Навигация', 'Основы навигации'),
    ('Авиаанглийский', 'Терминология'),
    ('Грузоперевозки', 'Работа с грузами'),
    ('Контроль качества', 'QMS в авиации'),
    ('Метеорология', 'Погода и авиация'),
    ('Управление аэропортом', 'Основы управления');

-- Курсы
INSERT INTO courses (category_id, is_individual, code, title, description, duration_hours, is_active)
VALUES
    ((SELECT id FROM course_categories WHERE name = 'ТО ВС'), false, 'C-001', 'Курс 1', 'Описание курса 1', 40, true),
    ((SELECT id FROM course_categories WHERE name = 'Безопасность'), false, 'C-002', 'Курс 2', 'Описание курса 2', 30, true),
    ((SELECT id FROM course_categories WHERE name = 'Обслуживание пассажиров'), false, 'C-003', 'Курс 3', 'Описание курса 3', 25, true),
    ((SELECT id FROM course_categories WHERE name = 'Наземные службы'), false, 'C-004', 'Курс 4', 'Описание курса 4', 50, true),
    ((SELECT id FROM course_categories WHERE name = 'Навигация'), false, 'C-005', 'Курс 5', 'Описание курса 5', 35, true),
    ((SELECT id FROM course_categories WHERE name = 'Авиаанглийский'), false, 'C-006', 'Курс 6', 'Описание курса 6', 20, true),
    ((SELECT id FROM course_categories WHERE name = 'Грузоперевозки'), false, 'C-007', 'Курс 7', 'Описание курса 7', 45, true),
    ((SELECT id FROM course_categories WHERE name = 'Контроль качества'), false, 'C-008', 'Курс 8', 'Описание курса 8', 60, true),
    ((SELECT id FROM course_categories WHERE name = 'Метеорология'), false, 'C-009', 'Курс 9', 'Описание курса 9', 18, true),
    ((SELECT id FROM course_categories WHERE name = 'Управление аэропортом'), false, 'C-010', 'Курс 10', 'Описание курса 10', 15, true);

-- Записи на курсы
INSERT INTO course_enrollments (course_id, student_id, status, progress_percentage)
VALUES
    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM users WHERE email = 'student1@manas.kg'), 'enrolled', 0),
    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM users WHERE email = 'student2@manas.kg'), 'enrolled', 0),
    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM users WHERE email = 'student3@manas.kg'), 'enrolled', 0),
    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM users WHERE email = 'student4@manas.kg'), 'enrolled', 0),
    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM users WHERE email = 'student5@manas.kg'), 'enrolled', 0),
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM users WHERE email = 'student6@manas.kg'), 'enrolled', 0),
    ((SELECT id FROM courses WHERE code = 'C-007'), (SELECT id FROM users WHERE email = 'student7@manas.kg'), 'enrolled', 0);