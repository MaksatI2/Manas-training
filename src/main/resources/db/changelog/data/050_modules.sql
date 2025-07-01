-- Модуля для потоков курса
INSERT INTO course_modules (course_instance_id, title, duration_hours, description, order_index, is_active)
VALUES
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-001') AND title = 'Курс 1 - Июль 2025'), 'Модуль 1: Основы ТО ВС', 15, 'Введение в техническое обслуживание воздушных судов', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-001') AND title = 'Курс 1 - Июль 2025'), 'Модуль 2: Диагностика систем', 15, 'Методы диагностики и ремонта систем ВС', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-001') AND title = 'Курс 1 - Июль 2025'), 'Модуль 3: Практика ТО', 10, 'Практические навыки обслуживания', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-001') AND title = 'Курс 1 - Август 2025'), 'Модуль 1: Основы ТО ВС', 15, 'Введение в техническое обслуживание воздушных судов', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-001') AND title = 'Курс 1 - Август 2025'), 'Модуль 2: Диагностика систем', 15, 'Методы диагностики и ремонта систем ВС', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-001') AND title = 'Курс 1 - Август 2025'), 'Модуль 3: Практика ТО', 10, 'Практические навыки обслуживания', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-002') AND title = 'Курс 2 - Июль 2025'), 'Модуль 1: Основы безопасности', 10, 'Принципы авиационной безопасности', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-002') AND title = 'Курс 2 - Июль 2025'), 'Модуль 2: Управление рисками', 10, 'Методы оценки и управления рисками', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-002') AND title = 'Курс 2 - Июль 2025'), 'Модуль 3: Процедуры ЧС', 8, 'Действия в чрезвычайных ситуациях', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-002') AND title = 'Курс 2 - Август 2025'), 'Модуль 1: Основы безопасности', 10, 'Принципы авиационной безопасности', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-002') AND title = 'Курс 2 - Август 2025'), 'Модуль 2: Управление рисками', 10, 'Методы оценки и управления рисками', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-002') AND title = 'Курс 2 - Август 2025'), 'Модуль 3: Процедуры ЧС', 8, 'Действия в чрезвычайных ситуациях', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-003') AND title = 'Курс 3 - Июль 2025'), 'Модуль 1: Обслуживание клиентов', 8, 'Основы взаимодействия с пассажирами', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-003') AND title = 'Курс 3 - Июль 2025'), 'Модуль 2: Конфликтные ситуации', 8, 'Управление конфликтами на борту', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-003') AND title = 'Курс 3 - Июль 2025'), 'Модуль 3: Сервисные стандарты', 7, 'Стандарты обслуживания в авиации', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-003') AND title = 'Курс 3 - Август 2025'), 'Модуль 1: Обслуживание клиентов', 8, 'Основы взаимодействия с пассажирами', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-003') AND title = 'Курс 3 - Август 2025'), 'Модуль 2: Конфликтные ситуации', 8, 'Управление конфликтами на борту', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-003') AND title = 'Курс 3 - Август 2025'), 'Модуль 3: Сервисные стандарты', 7, 'Стандарты обслуживания в авиации', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-004') AND title = 'Курс 4 - Июль 2025'), 'Модуль 1: Наземные операции', 18, 'Основы наземного обслуживания', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-004') AND title = 'Курс 4 - Июль 2025'), 'Модуль 2: Обработка багажа', 16, 'Процедур обработки багажа и грузов', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-004') AND title = 'Курс 4 - Июль 2025'), 'Модуль 3: Координация служб', 15, 'Координация наземных служб', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-004') AND title = 'Курс 4 - Август 2025'), 'Модуль 1: Наземные операции', 18, 'Основы наземного обслуживания', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-004') AND title = 'Курс 4 - Август 2025'), 'Модуль 2: Обработка багажа', 16, 'Процедур обработки багажа и грузов', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-004') AND title = 'Курс 4 - Август 2025'), 'Модуль 3: Координация служб', 15, 'Координация наземных служб', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-005') AND title = 'Курс 5 - Июль 2025'), 'Модуль 1: Основы навигации', 12, 'Принципы авиационной навигации', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-005') AND title = 'Курс 5 - Июль 2025'), 'Модуль 2: Навигационные системы', 12, 'Использование современных систем навигации', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-005') AND title = 'Курс 5 - Июль 2025'), 'Модуль 3: Планирование маршрутов', 10, 'Планирование полетных маршрутов', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-005') AND title = 'Курс 5 - Август 2025'), 'Модуль 1: Основы навигации', 12, 'Принципы авиационной навигации', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-005') AND title = 'Курс 5 - Август 2025'), 'Модуль 2: Навигационные системы', 12, 'Использование современных систем навигации', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-005') AND title = 'Курс 5 - Август 2025'), 'Модуль 3: Планирование маршрутов', 10, 'Планирование полетных маршрутов', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-006') AND title = 'Курс 6 - Июль 2025'), 'Модуль 1: Авиационная терминология', 10, 'Изучение терминов на английском', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-006') AND title = 'Курс 6 - Июль 2025'), 'Модуль 2: Коммуникация на борту', 10, 'Практика общения на английском', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-006') AND title = 'Курс 6 - Август 2025'), 'Модуль 1: Авиационная терминология', 10, 'Изучение терминов на английском', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-006') AND title = 'Курс 6 - Август 2025'), 'Модуль 2: Коммуникация на борту', 10, 'Практика общения на английском', 2, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-007') AND title = 'Курс 7 - Июль 2025'), 'Модуль 1: Логистика грузов', 15, 'Основы управления грузоперевозками', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-007') AND title = 'Курс 7 - Июль 2025'), 'Модуль 2: Упаковка и хранение', 15, 'Требования к упаковке и хранению грузов', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-007') AND title = 'Курс 7 - Июль 2025'), 'Модуль 3: Документация грузов', 14, 'Оформление грузовой документации', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-007') AND title = 'Курс 7 - Август 2025'), 'Модуль 1: Логистика грузов', 15, 'Основы управления грузоперевозками', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-007') AND title = 'Курс 7 - Август 2025'), 'Модуль 2: Упаковка и хранение', 15, 'Требования к упаковке и хранению грузов', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-007') AND title = 'Курс 7 - Август 2025'), 'Модуль 3: Документация грузов', 14, 'Оформление грузовой документации', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-008') AND title = 'Курс 8 - Июль 2025'), 'Модуль 1: Стандарты качества', 20, 'Принципы контроля качества в авиации', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-008') AND title = 'Курс 8 - Июль 2025'), 'Модуль 2: Аудит процессов', 20, 'Методы проведения аудита', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-008') AND title = 'Курс 8 - Июль 2025'), 'Модуль 3: Исправление несоответствий', 18, 'Устранение дефектов и несоответствий', 3, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-008') AND title = 'Курс 8 - Август 2025'), 'Модуль 1: Стандарты качества', 20, 'Принципы контроля качества в авиации', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-008') AND title = 'Курс 8 - Август 2025'), 'Модуль 2: Аудит процессов', 20, 'Методы проведения аудита', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-008') AND title = 'Курс 8 - Август 2025'), 'Модуль 3: Исправление несоответствий', 18, 'Устранение дефектов и несоответствий', 3, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-009') AND title = 'Курс 9 - Июль 2025'), 'Модуль 1: Основы метеорологии', 9, 'Введение в авиационную метеорологию', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-009') AND title = 'Курс 9 - Июль 2025'), 'Модуль 2: Прогнозирование погоды', 9, 'Методы прогнозирования погоды', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-009') AND title = 'Курс 9 - Август 2025'), 'Модуль 1: Основы метеорологии', 9, 'Введение в авиационную метеорологию', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-009') AND title = 'Курс 9 - Август 2025'), 'Модуль 2: Прогнозирование погоды', 9, 'Методы прогнозирования погоды', 2, true),

    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-010') AND title = 'Курс 10 - Июль 2025'), 'Модуль 1: Управление операциями', 8, 'Координация операций аэропорта', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-010') AND title = 'Курс 10 - Июль 2025'), 'Модуль 2: Безопасность аэропорта', 7, 'Обеспечение безопасности в аэропорту', 2, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-010') AND title = 'Курс 10 - Август 2025'), 'Модуль 1: Управление операциями', 8, 'Координация операций аэропорта', 1, true),
    ((SELECT id FROM course_instances WHERE course_id = (SELECT id FROM courses WHERE code = 'C-010') AND title = 'Курс 10 - Август 2025'), 'Модуль 2: Безопасность аэропорта', 7, 'Обеспечение безопасности в аэропорту', 2, true);