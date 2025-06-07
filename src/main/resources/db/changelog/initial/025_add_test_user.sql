INSERT INTO roles (name) VALUES ('ROLE_STUDENT');
INSERT INTO users (
    email,
    password_hash,
    first_name,
    last_name,
    phone,
    role_id,
    is_active
) VALUES (
             'test@student.com',
             '$2a$12$oyiEtEiLFoTMud14C3XUtutnzZEFHPdyPWZ2uvFC/qKZm29ItJY.q', -- password123
             'Test',
             'Student',
             '+996123456789',
             (SELECT id FROM roles WHERE name = 'ROLE_STUDENT'),
             true
         );