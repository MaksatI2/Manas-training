-- changeset Maksat:060 create database indexes

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_role_active ON users(role_id, is_active);

CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

CREATE INDEX IF NOT EXISTS idx_organizations_code ON organizations(code);
CREATE INDEX IF NOT EXISTS idx_organizations_user_id ON organizations(user_id);

CREATE INDEX IF NOT EXISTS idx_student_profiles_user_id ON student_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_organization_id ON student_profiles(organization_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_specialization ON student_profiles(specialization);
CREATE INDEX IF NOT EXISTS idx_student_profiles_org_spec ON student_profiles(organization_id, specialization);
CREATE INDEX IF NOT EXISTS idx_teacher_profiles_user_id ON teacher_profiles(user_id);

CREATE INDEX IF NOT EXISTS idx_teacher_profiles_department ON teacher_profiles(department);

CREATE INDEX IF NOT EXISTS idx_courses_code ON courses(code);
CREATE INDEX IF NOT EXISTS idx_courses_category_id ON courses(category_id);
CREATE INDEX IF NOT EXISTS idx_courses_is_active ON courses(is_active);
CREATE INDEX IF NOT EXISTS idx_courses_is_individual ON courses(is_individual);
CREATE INDEX IF NOT EXISTS idx_courses_created_at ON courses(created_at);
CREATE INDEX IF NOT EXISTS idx_courses_updated_at ON courses(updated_at);
CREATE INDEX IF NOT EXISTS idx_courses_category_active ON courses(category_id, is_active);
CREATE INDEX IF NOT EXISTS idx_courses_individual_active ON courses(is_individual, is_active);

CREATE INDEX IF NOT EXISTS idx_course_applications_course_id ON course_applications(course_id);
CREATE INDEX IF NOT EXISTS idx_course_applications_organization_id ON course_applications(organization_id);
CREATE INDEX IF NOT EXISTS idx_course_applications_submitted_by ON course_applications(submitted_by);
CREATE INDEX IF NOT EXISTS idx_course_applications_preferred_teacher_id ON course_applications(preferred_teacher_id);
CREATE INDEX IF NOT EXISTS idx_course_applications_processed_by ON course_applications(processed_by);
CREATE INDEX IF NOT EXISTS idx_course_applications_status ON course_applications(status);
CREATE INDEX IF NOT EXISTS idx_course_applications_submitted_at ON course_applications(submitted_at);
CREATE INDEX IF NOT EXISTS idx_course_applications_processed_at ON course_applications(processed_at);
CREATE INDEX IF NOT EXISTS idx_course_applications_preferred_start_date ON course_applications(preferred_start_date);
CREATE INDEX IF NOT EXISTS idx_course_applications_preferred_end_date ON course_applications(preferred_end_date);
CREATE INDEX IF NOT EXISTS idx_course_applications_status_submitted ON course_applications(status, submitted_at);
CREATE INDEX IF NOT EXISTS idx_course_applications_course_status ON course_applications(course_id, status);
CREATE INDEX IF NOT EXISTS idx_course_applications_org_status ON course_applications(organization_id, status);

CREATE INDEX IF NOT EXISTS idx_course_modules_course_instance_id ON course_modules(course_instance_id);
CREATE INDEX IF NOT EXISTS idx_course_modules_order_index ON course_modules(order_index);
CREATE INDEX IF NOT EXISTS idx_course_modules_is_active ON course_modules(is_active);
CREATE INDEX IF NOT EXISTS idx_course_modules_duration_hours ON course_modules(duration_hours);
CREATE INDEX IF NOT EXISTS idx_course_modules_instance_order ON course_modules(course_instance_id, order_index);
CREATE INDEX IF NOT EXISTS idx_course_modules_instance_active ON course_modules(course_instance_id, is_active);

CREATE INDEX IF NOT EXISTS idx_lessons_module_id ON lessons(module_id);
