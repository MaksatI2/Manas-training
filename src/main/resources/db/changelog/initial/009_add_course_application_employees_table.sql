-- changeset Maksat: 009 create course_application_employees table

CREATE TABLE course_application_employees
(
    id             SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    employee_id    INTEGER NOT NULL,
    FOREIGN KEY (application_id) REFERENCES course_applications (id),
    FOREIGN KEY (employee_id) REFERENCES users (id)
);