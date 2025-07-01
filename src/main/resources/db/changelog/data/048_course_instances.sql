-- Создание потоков курса
INSERT INTO course_instances (course_id, title, start_date, end_date, is_active, created_at, updated_at)
VALUES
    ((SELECT id FROM courses WHERE code = 'C-001'), 'Курс 1 - Июль 2025', '2025-07-01 09:00:00', '2025-07-15 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-001'), 'Курс 1 - Август 2025', '2025-08-01 09:00:00', '2025-08-15 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-002'), 'Курс 2 - Июль 2025', '2025-07-02 09:00:00', '2025-07-12 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-002'), 'Курс 2 - Август 2025', '2025-08-02 09:00:00', '2025-08-12 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-003'), 'Курс 3 - Июль 2025', '2025-07-03 09:00:00', '2025-07-10 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-003'), 'Курс 3 - Август 2025', '2025-08-03 09:00:00', '2025-08-10 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-004'), 'Курс 4 - Июль 2025', '2025-07-04 09:00:00', '2025-07-20 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-004'), 'Курс 4 - Август 2025', '2025-08-04 09:00:00', '2025-08-20 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-005'), 'Курс 5 - Июль 2025', '2025-07-05 09:00:00', '2025-07-18 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-005'), 'Курс 5 - Август 2025', '2025-08-05 09:00:00', '2025-08-18 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-006'), 'Курс 6 - Июль 2025', '2025-07-06 09:00:00', '2025-07-12 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-006'), 'Курс 6 - Август 2025', '2025-08-06 09:00:00', '2025-08-12 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-007'), 'Курс 7 - Июль 2025', '2025-07-07 09:00:00', '2025-07-22 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-007'), 'Курс 7 - Август 2025', '2025-08-07 09:00:00', '2025-08-22 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-008'), 'Курс 8 - Июль 2025', '2025-07-08 09:00:00', '2025-07-25 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-008'), 'Курс 8 - Август 2025', '2025-08-08 09:00:00', '2025-08-25 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-009'), 'Курс 9 - Июль 2025', '2025-07-09 09:00:00', '2025-07-14 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-009'), 'Курс 9 - Август 2025', '2025-08-09 09:00:00', '2025-08-14 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

    ((SELECT id FROM courses WHERE code = 'C-010'), 'Курс 10 - Июль 2025', '2025-07-10 09:00:00', '2025-07-14 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ((SELECT id FROM courses WHERE code = 'C-010'), 'Курс 10 - Август 2025', '2025-08-10 09:00:00', '2025-08-14 17:00:00', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);