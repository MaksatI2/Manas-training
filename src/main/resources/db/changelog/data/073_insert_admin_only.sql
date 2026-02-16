-- changeset Maksat:073-insert-admin-only
INSERT INTO roles (name)
VALUES ('ADMIN')
ON CONFLICT (name) DO NOTHING;

INSERT INTO roles (name)
VALUES ('TEACHER')
ON CONFLICT (name) DO NOTHING;

INSERT INTO roles (name)
VALUES ('STUDENT')
ON CONFLICT (name) DO NOTHING;

INSERT INTO roles (name)
VALUES ('ORGANIZATION')
ON CONFLICT (name) DO NOTHING;

INSERT INTO users (email, password_hash, first_name, last_name, phone, avatar_url, role_id, is_active)
VALUES (
    'admin@manas.kg',
    '$2a$14$t2xOr9/qa/8lNqxoQr4yUewrMm7.1tgijkGD..GOBsMUeJ6v4IbAG',
    'Admin',
    'System',
    '+996550898784',
    NULL,
    (SELECT id FROM roles WHERE name = 'ADMIN'),
    true
)
ON CONFLICT (email) DO NOTHING;

INSERT INTO users (email, password_hash, first_name, last_name, phone, avatar_url, role_id, is_active)
VALUES (
    'teacher@1manas.kg',
    '$2a$14$S.UAZPXOLiXNkGhQ.H9Sb.zRk84RmBSY3MSd1DMe0QgD09p.NcXxG',
    'Teacher1',
    'One',
    '+996700000001',
    NULL,
    (SELECT id FROM roles WHERE name = 'TEACHER'),
    true
)
ON CONFLICT (email) DO NOTHING;