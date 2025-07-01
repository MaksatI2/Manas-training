
-- Вставка данных в таблицу course_teachers
INSERT INTO course_teachers (course_id, teacher_id, created_at)
VALUES
    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM users WHERE email = 'teacher1@manas.kg'), CURRENT_TIMESTAMP), -- Навигация
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM users WHERE email = 'teacher1@manas.kg'), CURRENT_TIMESTAMP), -- Авиаанглийский

    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM users WHERE email = 'teacher2@manas.kg'), CURRENT_TIMESTAMP), -- Безопасность
    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM users WHERE email = 'teacher2@manas.kg'), CURRENT_TIMESTAMP), -- Наземные службы
    ((SELECT id FROM courses WHERE code = 'C-008'), (SELECT id FROM users WHERE email = 'teacher2@manas.kg'), CURRENT_TIMESTAMP), -- Контроль качества

    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM users WHERE email = 'teacher3@manas.kg'), CURRENT_TIMESTAMP), -- Обслуживание пассажиров
    ((SELECT id FROM courses WHERE code = 'C-007'), (SELECT id FROM users WHERE email = 'teacher3@manas.kg'), CURRENT_TIMESTAMP), -- Грузоперевозки
    ((SELECT id FROM courses WHERE code = 'C-009'), (SELECT id FROM users WHERE email = 'teacher3@manas.kg'), CURRENT_TIMESTAMP), -- Метеорология

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM users WHERE email = 'teacher4@manas.kg'), CURRENT_TIMESTAMP), -- ТО ВС
    ((SELECT id FROM courses WHERE code = 'C-010'), (SELECT id FROM users WHERE email = 'teacher4@manas.kg'), CURRENT_TIMESTAMP), -- Управление аэропортом
    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM users WHERE email = 'teacher4@manas.kg'), CURRENT_TIMESTAMP), -- Безопасность

    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM users WHERE email = 'teacher5@manas.kg'), CURRENT_TIMESTAMP), -- Навигация
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM users WHERE email = 'teacher5@manas.kg'), CURRENT_TIMESTAMP), -- Авиаанглийский
    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM users WHERE email = 'teacher5@manas.kg'), CURRENT_TIMESTAMP), -- Наземные службы

    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM users WHERE email = 'teacher6@manas.kg'), CURRENT_TIMESTAMP), -- Безопасность
    ((SELECT id FROM courses WHERE code = 'C-008'), (SELECT id FROM users WHERE email = 'teacher6@manas.kg'), CURRENT_TIMESTAMP), -- Контроль качества
    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM users WHERE email = 'teacher6@manas.kg'), CURRENT_TIMESTAMP), -- Обслуживание пассажиров

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM users WHERE email = 'teacher7@manas.kg'), CURRENT_TIMESTAMP), -- ТО ВС
    ((SELECT id FROM courses WHERE code = 'C-007'), (SELECT id FROM users WHERE email = 'teacher7@manas.kg'), CURRENT_TIMESTAMP), -- Грузоперевозки
    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM users WHERE email = 'teacher7@manas.kg'), CURRENT_TIMESTAMP), -- Наземные службы

    ((SELECT id FROM courses WHERE code = 'C-007'), (SELECT id FROM users WHERE email = 'teacher8@manas.kg'), CURRENT_TIMESTAMP), -- Грузоперевозки
    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM users WHERE email = 'teacher8@manas.kg'), CURRENT_TIMESTAMP), -- Обслуживание пассажиров
    ((SELECT id FROM courses WHERE code = 'C-010'), (SELECT id FROM users WHERE email = 'teacher8@manas.kg'), CURRENT_TIMESTAMP), -- Управление аэропортом

    ((SELECT id FROM courses WHERE code = 'C-004'), (SELECT id FROM users WHERE email = 'teacher9@manas.kg'), CURRENT_TIMESTAMP), -- Наземные службы
    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM users WHERE email = 'teacher9@manas.kg'), CURRENT_TIMESTAMP), -- Безопасность
    ((SELECT id FROM courses WHERE code = 'C-009'), (SELECT id FROM users WHERE email = 'teacher9@manas.kg'), CURRENT_TIMESTAMP), -- Метеорология

    ((SELECT id FROM courses WHERE code = 'C-003'), (SELECT id FROM users WHERE email = 'teacher10@manas.kg'), CURRENT_TIMESTAMP), -- Обслуживание пассажиров
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM users WHERE email = 'teacher10@manas.kg'), CURRENT_TIMESTAMP), -- Авиаанглийский
    ((SELECT id FROM courses WHERE code = 'C-008'), (SELECT id FROM users WHERE email = 'teacher10@manas.kg'), CURRENT_TIMESTAMP), -- Контроль качества

    ((SELECT id FROM courses WHERE code = 'C-001'), (SELECT id FROM users WHERE email = 'teacher11@manas.kg'), CURRENT_TIMESTAMP), -- ТО ВС
    ((SELECT id FROM courses WHERE code = 'C-005'), (SELECT id FROM users WHERE email = 'teacher11@manas.kg'), CURRENT_TIMESTAMP), -- Навигация
    ((SELECT id FROM courses WHERE code = 'C-006'), (SELECT id FROM users WHERE email = 'teacher11@manas.kg'), CURRENT_TIMESTAMP), -- Авиаанглийский

    ((SELECT id FROM courses WHERE code = 'C-009'), (SELECT id FROM users WHERE email = 'teacher12@manas.kg'), CURRENT_TIMESTAMP), -- Метеорология
    ((SELECT id FROM courses WHERE code = 'C-002'), (SELECT id FROM users WHERE email = 'teacher12@manas.kg'), CURRENT_TIMESTAMP), -- Безопасность
    ((SELECT id FROM courses WHERE code = 'C-010'), (SELECT id FROM users WHERE email = 'teacher12@manas.kg'), CURRENT_TIMESTAMP); -- Управление аэропортом