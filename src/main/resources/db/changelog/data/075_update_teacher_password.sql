-- changeset Maksat:075-update-teacher-password
UPDATE users
SET password_hash = '$2a$14$nchK/JrrY5oXky0flq3fUuUl7QNW4hNn/3.xvzz6X1KTAAh.k.gfm'
WHERE email = 'teacher@1manas.kg';
