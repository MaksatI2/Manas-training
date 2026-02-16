-- changeset Maksat:074-insert-teacher-profiles
INSERT INTO teacher_profiles (user_id, department, qualifications, bio)
VALUES
    ((SELECT id FROM users WHERE email = 'teacher@1manas.kg'), 'Aviation', 'Master', 'Senior instructor');
