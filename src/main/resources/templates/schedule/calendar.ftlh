<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="calendar-container">
        <div class="calendar-header">
            <h1 class="calendar-title">
                <i class="fas fa-calendar me-2"></i>
                Расписание занятий - <span id="currentMonth"></span>
            </h1>
            <div class="user-info">
                <span class="user-role-badge ${userRole}">${userRole?upper_case}</span>
                <span class="user-name">${userName}</span>
            </div>
            <div class="calendar-nav">
                <button class="nav-btn" onclick="changeMonth(-1)">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <button class="nav-btn today-btn" onclick="goToToday()">Сегодня</button>
                <button class="nav-btn" onclick="changeMonth(1)">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>

        <div class="filters-panel">
            <div class="filters-header" onclick="toggleFilters()">
                <h3><i class="fas fa-filter"></i> Фильтры</h3>
                <button class="toggle-filters-btn" id="toggleFiltersBtn">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="filters-content" id="filtersContent">
                <form class="filters-form" id="filtersForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="courseTitle">Курс:</label>
                            <select name="courseTitle" id="courseTitle" onchange="applyFilters()">
                                <option value="">Все курсы</option>
                                <#list courseTitles as course>
                                    <option value="${course}" <#if selectedCourseTitle?? && selectedCourseTitle == course>selected</#if>>
                                        ${course}
                                    </option>
                                </#list>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="courseInstanceTitle">Группа:</label>
                            <select name="courseInstanceTitle" id="courseInstanceTitle" onchange="applyFilters()">
                                <option value="">Все группы</option>
                                <#list courseInstanceTitles as instance>
                                    <option value="${instance}" <#if selectedCourseInstanceTitle?? && selectedCourseInstanceTitle == instance>selected</#if>>
                                        ${instance}
                                    </option>
                                </#list>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="teacherName">Преподаватель:</label>
                            <select name="teacherName" id="teacherName" onchange="applyFilters()">
                                <option value="">Все преподаватели</option>
                                <#list teacherNames as teacher>
                                    <option value="${teacher}" <#if selectedTeacherName?? && selectedTeacherName == teacher>selected</#if>>
                                        ${teacher}
                                    </option>
                                </#list>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label for="lessonType">Тип занятия:</label>
                            <select name="lessonType" id="lessonType" onchange="applyFilters()">
                                <option value="">Все типы</option>
                                <#list lessonTypes as type>
                                    <option value="${type}" <#if selectedLessonType?? && selectedLessonType == type>selected</#if>>
                                        <#switch type>
                                            <#case "LECTURE">Лекция<#break>
                                            <#case "PRACTICAL">Практика<#break>
                                            <#case "EXAM">Экзамен<#break>
                                            <#case "CONSULTATION">Консультация<#break>
                                            <#default>${type}
                                        </#switch>
                                    </option>
                                </#list>
                            </select>
                        </div>
                    </div>
                    <div class="filter-row">
                        <div class="filter-actions">
                            <button type="button" class="reset-filters-btn" onclick="resetFilters()">
                                <i class="fas fa-undo"></i> Сбросить
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="calendar-grid" id="calendarGrid">
            <div class="day-header">Пн</div>
            <div class="day-header">Вт</div>
            <div class="day-header">Ср</div>
            <div class="day-header">Чт</div>
            <div class="day-header">Пт</div>
            <div class="day-header">Сб</div>
            <div class="day-header">Вс</div>
        </div>
    </div>

    <div id="lessonModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title" id="modalTitle"></h2>
                <button class="close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body" id="modalBody"></div>
            <div class="modal-actions" id="modalActions" style="display: none;">
                <button class="action-btn edit-btn" onclick="editLesson()">
                    <i class="fas fa-edit"></i> Редактировать
                </button>
                <button class="action-btn delete-btn" onclick="deleteLesson()">
                    <i class="fas fa-trash"></i> Удалить
                </button>
            </div>
        </div>
    </div>

    <script>
        let schedulesData;
        let originalSchedulesData;
        let filteredSchedulesData = {};

        try {
            schedulesData = ${schedulesJson?no_esc} || {};
            originalSchedulesData = JSON.parse(JSON.stringify(schedulesData));
        } catch (e) {
            console.error('Ошибка при парсинге данных расписания:', e);
            schedulesData = {};
            originalSchedulesData = {};
        }

        const currentUserRole = '${userRole}';
        const currentUserName = '${userName}';
        const todayDate = '${currentDate}';

        const canEditLessons = currentUserRole === 'admin' || currentUserRole === 'teacher';

        let currentDate = new Date();
        const monthNames = [
            'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
            'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
        ];

        const lessonTypeNames = {
            'LECTURE': 'Лекция',
            'PRACTICAL': 'Практика',
            'EXAM': 'Экзамен',
            'CONSULTATION': 'Консультация'
        };

        function formatDate(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return year + '-' + month + '-' + day;
        }

        function applyFilters() {
            try {
                const courseTitle = document.getElementById('courseTitle').value;
                const courseInstanceTitle = document.getElementById('courseInstanceTitle').value;
                const teacherName = document.getElementById('teacherName').value;
                const lessonType = document.getElementById('lessonType').value;

                filteredSchedulesData = {};

                Object.keys(originalSchedulesData).forEach(dateKey => {
                    const lessons = originalSchedulesData[dateKey];
                    if (!lessons || !Array.isArray(lessons)) return;

                    let filteredLessons = lessons.filter(lesson => {
                        if (courseTitle && lesson.courseTitle !== courseTitle) return false;
                        if (courseInstanceTitle && lesson.courseInstanceTitle !== courseInstanceTitle) return false;
                        if (teacherName && lesson.teacherName !== teacherName) return false;
                        if (lessonType && lesson.lessonType !== lessonType) return false;
                        return true;
                    });

                    if (filteredLessons.length > 0) {
                        filteredSchedulesData[dateKey] = filteredLessons;
                    }
                });

                schedulesData = filteredSchedulesData;
                generateCalendar();

                showFilterStatus();

            } catch (error) {
                console.error('Ошибка при применении фильтров:', error);
            }
        }

        function resetFilters() {
            try {
                document.getElementById('courseTitle').value = '';
                document.getElementById('courseInstanceTitle').value = '';
                document.getElementById('teacherName').value = '';
                document.getElementById('lessonType').value = '';

                schedulesData = JSON.parse(JSON.stringify(originalSchedulesData));
                generateCalendar();

                showFilterStatus('Фильтры сброшены');
            } catch (error) {
                console.error('Ошибка при сбросе фильтров:', error);
            }
        }

        function showFilterStatus() {
            setTimeout(() => {
            }, 2000);
        }

        function toggleFilters() {
            const filtersContent = document.getElementById('filtersContent');
            const toggleBtn = document.getElementById('toggleFiltersBtn');

            if (filtersContent.classList.contains('expanded')) {
                filtersContent.classList.remove('expanded');
                toggleBtn.classList.remove('active');
            } else {
                filtersContent.classList.add('expanded');
                toggleBtn.classList.add('active');
            }
        }

        function generateCalendar() {
            try {
                const year = currentDate.getFullYear();
                const month = currentDate.getMonth();

                document.getElementById('currentMonth').textContent =
                    monthNames[month] + ' ' + year;

                const firstDay = new Date(year, month, 1);
                const startDate = new Date(firstDay);
                startDate.setDate(startDate.getDate() - (firstDay.getDay() || 7) + 1);

                const calendarGrid = document.getElementById('calendarGrid');
                const dayHeaders = calendarGrid.querySelectorAll('.day-header');
                calendarGrid.innerHTML = '';

                dayHeaders.forEach(header => calendarGrid.appendChild(header));

                const today = new Date();
                const todayStr = formatDate(today);

                for (let i = 0; i < 42; i++) {
                    const cellDate = new Date(startDate);
                    cellDate.setDate(startDate.getDate() + i);
                    const dateStr = formatDate(cellDate);

                    const dayCell = document.createElement('div');
                    dayCell.className = 'day-cell';

                    if (cellDate.getMonth() !== month) {
                        dayCell.classList.add('other-month');
                    }

                    if (dateStr === todayStr) {
                        dayCell.classList.add('today');
                    }

                    dayCell.innerHTML = '<div class="day-number">' + cellDate.getDate() + '</div>';

                    const dayLessons = schedulesData[dateStr] || [];

                    if (dayLessons && Array.isArray(dayLessons)) {
                        const visibleLessons = dayLessons.slice(0, 3);
                        const hiddenLessons = dayLessons.slice(3);

                        visibleLessons.forEach(lesson => {
                            try {
                                const lessonDiv = document.createElement('div');
                                const lessonTypeClass = lesson.lessonType ? lesson.lessonType.toLowerCase() : 'lecture';
                                lessonDiv.className = 'lesson-item ' + lessonTypeClass;

                                const lessonTitle = lesson.lessonTitle || 'Без названия';
                                const teacherName = lesson.teacherName || 'Преподаватель не указан';

                                lessonDiv.innerHTML = lessonTitle;
                                lessonDiv.title = lessonTitle + ' - ' + teacherName;

                                lessonDiv.onclick = function(e) {
                                    e.stopPropagation();
                                    openSingleLessonModal(lesson);
                                };

                                dayCell.appendChild(lessonDiv);
                            } catch (lessonError) {
                                console.error('Ошибка при создании элемента урока:', lessonError, lesson);
                            }
                        });

                        if (hiddenLessons.length > 0) {
                            const moreDiv = document.createElement('div');
                            moreDiv.className = 'more-lessons';
                            moreDiv.textContent = '... еще ' + hiddenLessons.length;
                            moreDiv.onclick = function(e) {
                                e.stopPropagation();
                                openDayLessonsModal(dateStr, dayLessons);
                            };
                            dayCell.appendChild(moreDiv);
                        }
                    }

                    dayCell.onclick = function() {
                        if (dayLessons && dayLessons.length > 0) {
                            openDayLessonsModal(dateStr, dayLessons);
                        }
                    };

                    calendarGrid.appendChild(dayCell);
                }
            } catch (error) {
                console.error('Ошибка при генерации календаря:', error);
                const calendarGrid = document.getElementById('calendarGrid');
                calendarGrid.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: 20px; color: #d32f2f;">Произошла ошибка при загрузке календаря. Попробуйте обновить страницу.</div>';
            }
        }

        let currentLesson;


        function openSingleLessonModal(lesson) {
            try {
                currentLesson = lesson;

                const lessonTitle = lesson.lessonTitle || 'Без названия';
                document.getElementById('modalTitle').textContent = lessonTitle;

                const modalBody = document.getElementById('modalBody');
                modalBody.innerHTML = '';

                const lessonDiv = document.createElement('div');
                lessonDiv.className = 'lesson-detail';

                const typeText = lessonTypeNames[lesson.lessonType] || lesson.lessonType || 'Занятие';
                const teacherName = lesson.teacherName || 'Преподаватель не указан';
                const courseTitle = lesson.courseTitle || 'Курс не указан';

                lessonDiv.innerHTML =
                    '<div class="lesson-title">' +
                    '<i class="fas fa-book"></i>' + lessonTitle +
                    '</div>' +
                    '<div class="lesson-info">' +
                    '<div class="lesson-info-item">' +
                    '<span class="lesson-type-badge ' + (lesson.lessonType ? lesson.lessonType.toLowerCase() : 'lecture') + '">' + typeText + '</span>' +
                    '</div>' +
                    '<div class="lesson-info-item">' +
                    '<i class="fas fa-user"></i>' +
                    '<span>' + teacherName + '</span>' +
                    '</div>' +
                    (lesson.durationHours ? '<div class="lesson-info-item">' +
                        '<i class="fas fa-hourglass-half"></i>' +
                        '<span>' + lesson.durationHours + ' ч.</span>' +
                        '</div>' : '') +
                    '</div>' +
                    '<div class="lesson-info" style="margin-top: 10px;">' +
                    '<div class="lesson-info-item">' +
                    '<i class="fas fa-graduation-cap"></i>' +
                    '<span><strong>Курс:</strong> ' + courseTitle + '</span>' +
                    '</div>' +
                    (lesson.courseInstanceTitle ? '<div class="lesson-info-item">' +
                        '<i class="fas fa-bookmark"></i>' +
                        '<span><strong>Группа:</strong> ' + lesson.courseInstanceTitle + '</span>' +
                        '</div>' : '') +
                    '</div>' +
                    (lesson.lessonDescription ? '<div class="lesson-notes">' +
                        '<strong>Описание:</strong><br>' + lesson.lessonDescription +
                        '</div>' : '') +
                    (lesson.notes ? '<div class="lesson-notes">' +
                        '<strong>Заметки:</strong><br>' + lesson.notes +
                        '</div>' : '') +
                    (lesson.meetingUrl ? '<div class="lesson-notes">' +
                        '<strong>Ссылка на конференцию:</strong><br>' +
                        '<a href="' + lesson.meetingUrl + '" target="_blank" class="meeting-link">' + lesson.meetingUrl + '</a>' +
                        '</div>' : '');

                modalBody.appendChild(lessonDiv);

                const modalActions = document.getElementById('modalActions');
                if (canEditLessons) {
                    modalActions.style.display = 'flex';
                } else {
                    modalActions.style.display = 'none';
                }

                document.getElementById('lessonModal').style.display = 'block';
            } catch (error) {
                console.error('Ошибка при открытии модального окна урока:', error);
            }
        }

        function openDayLessonsModal(dateStr, dayLessons) {
            try {
                const date = new Date(dateStr);
                const options = {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                };

                document.getElementById('modalTitle').textContent =
                    'Расписание на ' + date.toLocaleDateString('ru-RU', options);

                const modalBody = document.getElementById('modalBody');
                modalBody.innerHTML = '';

                if (!dayLessons || dayLessons.length === 0) {
                    modalBody.innerHTML = '<p style="text-align: center; color: #666; padding: 20px;">На этот день занятий не запланировано</p>';
                } else {
                    dayLessons.forEach(function(lesson) {
                        const lessonDiv = document.createElement('div');
                        lessonDiv.className = 'lesson-detail clickable-lesson';
                        lessonDiv.onclick = function() {
                            openSingleLessonModal(lesson);
                        };

                        const typeText = lessonTypeNames[lesson.lessonType] || lesson.lessonType || 'Занятие';
                        const lessonTitle = lesson.lessonTitle || 'Без названия';
                        const teacherName = lesson.teacherName || 'Преподаватель не указан';

                        lessonDiv.innerHTML =
                            '<div class="lesson-title">' +
                            '<i class="fas fa-book"></i>' + lessonTitle +
                            '</div>' +
                            '<div class="lesson-info">' +
                            '<div class="lesson-info-item">' +
                            '<span class="lesson-type-badge ' + (lesson.lessonType ? lesson.lessonType.toLowerCase() : 'lecture') + '">' + typeText + '</span>' +
                            '</div>' +
                            '<div class="lesson-info-item">' +
                            '<i class="fas fa-user"></i>' +
                            '<span>' + teacherName + '</span>' +
                            '</div>' +
                            '</div>' +
                            '<small style="color: #666; font-style: italic;">Нажмите для подробностей</small>';

                        modalBody.appendChild(lessonDiv);
                    });
                }

                document.getElementById('modalActions').style.display = 'none';

                document.getElementById('lessonModal').style.display = 'block';
            } catch (error) {
                console.error('Ошибка при открытии модального окна дня:', error);
            }
        }


        function editLesson() {
            if (!currentLesson) {
                alert('Не удалось определить урок для редактирования');
                return;
            }
            const lessonId = currentLesson.lessonId || currentLesson.id || currentLesson.scheduleId;
            if (!lessonId) {
                alert('Ошибка: у урока нет идентификатора для редактирования');
                console.error('Текущий урок (нет ID):', currentLesson);
                return;
            }
            window.location.href = "/schedules/lessons/" + lessonId;
        }

        async function deleteLesson() {
            if (!currentLesson) {
                alert('Не удалось определить урок для удаления');
                return;
            }
            if (!confirm('Вы уверены, что хотите удалить этот урок из расписания?')) {
                return;
            }
            const scheduleId = currentLesson.id || currentLesson.lessonId || currentLesson.scheduleId;
            if (!scheduleId) {
                alert('Не удалось определить ID расписания для удаления');
                console.error('currentLesson:', currentLesson);
                return;
            }
            let csrfToken = '';
            const meta = document.querySelector('meta[name="_csrf"]');
            if (meta) {
                csrfToken = meta.getAttribute('content');
            }
            try {
                const response = await fetch("/schedules/" + scheduleId, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest',
                        ...(csrfToken ? { 'X-CSRF-TOKEN': csrfToken } : {})
                    },
                });
                const result = await response.json();
                if (response.ok && result.success) {
                    alert('Расписание успешно удалено');
                    closeModal();
                    location.reload();
                } else {
                    throw new Error(result.message || 'Ошибка при удалении расписания');
                }
            } catch (error) {
                console.error('Ошибка при удалении расписания:', error);
                alert('Произошла ошибка при удалении расписания: ' + error.message);
            }
        }

        function closeModal() {
            document.getElementById('lessonModal').style.display = 'none';
        }

        function changeMonth(direction) {
            currentDate.setMonth(currentDate.getMonth() + direction);
            generateCalendar();
        }

        function goToToday() {
            currentDate = new Date();
            generateCalendar();
        }

        window.onclick = function(event) {
            const modal = document.getElementById('lessonModal');
            if (event.target === modal) {
                closeModal();
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            console.log('Инициализация календаря с данными:', schedulesData);
            console.log('Права пользователя - может редактировать:', canEditLessons);
            generateCalendar();
        });

        window.onerror = function(msg, url, lineNo, columnNo, error) {
            console.error('JavaScript ошибка:', msg, 'в строке', lineNo);
            return false;
        };
    </script>


    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
            --bg-light: #f8f9fa;
            --border-light: #e9ecef;
            --success-green: #28a745;
            --danger-red: #dc3545;
            --warning-orange: #fd7e14;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-dark);
        }

        .calendar-container {
            max-width: 1200px;
            margin: 2rem auto;
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
            overflow: hidden;
        }

        .calendar-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            padding: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            box-shadow: 0 2px 10px rgba(0,102,204,0.3);
        }

        .calendar-title {
            font-size: 2rem;
            font-weight: 600;
            flex: 1;
            min-width: 300px;
            display: flex;
            align-items: center;
        }

        .calendar-title i {
            color: var(--light-blue);
            margin-right: 0.5rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.9rem;
        }

        .user-role-badge {
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .user-role-badge.teacher {
            background: rgba(76, 175, 80, 0.8);
        }

        .user-role-badge.student {
            background: rgba(135, 206, 235, 0.8);
        }

        .user-role-badge.admin {
            background: rgba(255, 152, 0, 0.8);
        }

        .user-role-badge.other {
            background: rgba(158, 158, 158, 0.8);
        }

        .user-name {
            font-weight: 500;
            color: var(--light-blue);
        }

        .calendar-nav {
            display: flex;
            gap: 0.5rem;
        }

        .nav-btn {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.3);
            color: var(--white);
            padding: 0.8rem 1.2rem;
            border-radius: 25px;
            cursor: pointer;
            font-family: inherit;
            font-weight: 600;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .nav-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255,255,255,0.2);
        }

        .today-btn {
            background: var(--light-blue);
            border-color: var(--light-blue);
            color: var(--dark-blue);
        }

        .today-btn:hover {
            background: var(--white);
            border-color: var(--white);
        }

        /* Стили для панели фильтров */
        .filters-panel {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-bottom: 1px solid var(--border-light);
            box-shadow: 0 2px 10px rgba(0,102,204,0.05);
        }

        .filters-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 2rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filters-header:hover {
            background: rgba(0,102,204,0.05);
        }

        .filters-header h3 {
            color: var(--primary-blue);
            font-size: 1.1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .toggle-filters-btn {
            background: none;
            border: none;
            color: var(--primary-blue);
            font-size: 1.2rem;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .toggle-filters-btn:hover {
            background: rgba(0,102,204,0.1);
            transform: scale(1.1);
        }

        .toggle-filters-btn.active {
            transform: rotate(180deg);
        }

        .filters-content {
            padding: 0 2rem 2rem;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease, padding 0.3s ease;
        }

        .filters-content.expanded {
            max-height: 500px;
            padding: 0 2rem 2rem;
        }

        .filters-form {
            background: var(--white);
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 4px 15px rgba(0,102,204,0.08);
            border: 1px solid rgba(0,102,204,0.1);
        }

        .filter-row {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            align-items: end;
        }

        .filter-row:last-child {
            margin-bottom: 0;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.9rem;
        }

        .filter-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.9rem;
            color: var(--text-dark);
            background: var(--white);
            transition: all 0.3s ease;
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 0.5rem center;
            background-repeat: no-repeat;
            background-size: 1.5em 1.5em;
            padding-right: 2.5rem;
        }

        .filter-group select:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0,102,204,0.1);
            transform: translateY(-2px);
        }

        .filter-group select:hover {
            border-color: var(--primary-blue);
            transform: translateY(-1px);
        }

        .filter-actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            align-items: center;
            min-width: 200px;
        }

        .reset-filters-btn {
            background: linear-gradient(135deg, var(--warning-orange), #e8590c);
            border: none;
            color: var(--white);
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            font-family: inherit;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(253,126,20,0.3);
        }

        .reset-filters-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(253,126,20,0.4);
        }

        .filter-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8rem;
            color: var(--success-green);
            font-weight: 500;
            padding: 0.5rem 1rem;
            background: rgba(40,167,69,0.1);
            border-radius: 15px;
            border: 1px solid rgba(40,167,69,0.2);
        }

        .filter-status i {
            font-size: 1rem;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background: var(--white);
        }

        .day-header {
            background: var(--bg-light);
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            border-bottom: 2px solid var(--primary-blue);
            color: var(--text-dark);
            font-size: 1rem;
        }

        .day-cell {
            min-height: 120px;
            border-right: 1px solid var(--border-light);
            border-bottom: 1px solid var(--border-light);
            padding: 0.75rem;
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .day-cell:hover {
            background: rgba(135, 206, 235, 0.1);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .day-cell.other-month {
            background: var(--bg-light);
            color: #aaa;
        }

        .day-cell.other-month:hover {
            background: #f0f0f0;
        }

        .day-cell.today {
            background: linear-gradient(135deg, rgba(0,102,204,0.1), rgba(135,206,235,0.1));
            border: 2px solid var(--primary-blue);
            box-shadow: 0 4px 15px rgba(0,102,204,0.2);
        }

        .day-number {
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 1rem;
            color: var(--text-dark);
        }

        .lesson-item {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            padding: 0.25rem 0.5rem;
            margin: 0.25rem 0;
            border-radius: 5px;
            font-size: 0.75rem;
            line-height: 1.2;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .lesson-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .lesson-item.lecture {
            background: linear-gradient(135deg, var(--primary-blue));
        }
        .lesson-item.practical {
            background: linear-gradient(135deg, #28a745, #28a745);
        }
        .lesson-item.exam {
            background: linear-gradient(135deg, #dc3545, #dc3545);
        }
        .lesson-item.consultation {
            background: linear-gradient(135deg, #fd7e14, #fd7e14);
        }

        .more-lessons {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: var(--white);
            padding: 0.25rem 0.5rem;
            margin: 0.25rem 0;
            border-radius: 5px;
            font-size: 0.7rem;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s ease;
        }

        .more-lessons:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: var(--white);
            margin: 5% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 4px 25px rgba(0,102,204,0.2);
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            padding: 1.5rem 2rem;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,102,204,0.3);
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
        }

        .close {
            background: rgba(255,255,255,0.2);
            border: none;
            color: var(--white);
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0.5rem;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .close:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.1);
        }

        .modal-body {
            padding: 2rem;
        }

        /* Стили для кнопок действий в модальном окне */
        .modal-actions {
            padding: 1.5rem 2rem;
            background: var(--bg-light);
            border-top: 1px solid var(--border-light);
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            border-radius: 0 0 15px 15px;
        }

        .action-btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-family: inherit;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            min-width: 120px;
            justify-content: center;
        }

        .edit-btn {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .edit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,102,204,0.4);
        }

        .delete-btn {
            background: linear-gradient(135deg, var(--danger-red), #c82333);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(220,53,69,0.3);
        }

        .delete-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220,53,69,0.4);
        }

        .lesson-detail {
            border: 1px solid var(--border-light);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background: var(--bg-light);
            transition: all 0.3s ease;
        }

        .lesson-detail:last-child {
            margin-bottom: 0;
        }

        .lesson-detail:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .lesson-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--text-dark);
            display: flex;
            align-items: center;
        }

        .lesson-title i {
            color: var(--primary-blue);
            margin-right: 0.5rem;
        }

        .lesson-info {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            font-size: 0.9rem;
            color: #666;
        }

        .lesson-info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .lesson-info-item i {
            color: var(--primary-blue);
            width: 16px;
        }

        .lesson-type-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--white);
        }

        .lesson-type-badge.lecture {
            background: linear-gradient(135deg, var(--primary-blue));
        }
        .lesson-type-badge.practical {
            background: linear-gradient(135deg, #28a745, #28a745);
        }
        .lesson-type-badge.exam {
            background: linear-gradient(135deg, #dc3545, #dc3545);
        }
        .lesson-type-badge.consultation {
            background: linear-gradient(135deg, #fd7e14, #fd7e14);
        }

        .lesson-notes {
            margin-top: 1rem;
            padding: 1rem;
            background: var(--white);
            border-radius: 5px;
            font-size: 0.9rem;
            line-height: 1.5;
            border-left: 3px solid var(--light-blue);
        }

        .clickable-lesson {
            cursor: pointer;
        }

        .clickable-lesson:hover {
            background: rgba(135, 206, 235, 0.1);
        }

        .meeting-link {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .meeting-link:hover {
            color: var(--dark-blue);
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .calendar-container {
                margin: 1rem;
                border-radius: 10px;
            }

            .calendar-header {
                padding: 1.5rem;
                flex-direction: column;
                gap: 1rem;
            }

            .calendar-title {
                font-size: 1.5rem;
                min-width: auto;
                text-align: center;
                justify-content: center;
            }

            .calendar-nav {
                justify-content: center;
            }

            .nav-btn {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }

            .filters-header {
                padding: 1rem;
            }

            .filters-content {
                padding: 0 1rem 1rem;
            }

            .filters-form {
                padding: 1rem;
            }

            .filter-row {
                flex-direction: column;
                gap: 1rem;
            }

            .filter-group {
                min-width: auto;
            }

            .filter-actions {
                flex-direction: row;
                justify-content: space-between;
                min-width: auto;
                width: 100%;
            }

            .day-cell {
                min-height: 100px;
                padding: 0.5rem;
            }

            .lesson-item {
                font-size: 0.7rem;
                padding: 0.2rem 0.4rem;
            }

            .modal-content {
                margin: 10% auto;
                width: 95%;
            }

            .modal-body {
                padding: 1rem;
            }

            .modal-actions {
                padding: 1rem;
                flex-direction: column;
                gap: 0.5rem;
            }

            .action-btn {
                min-width: auto;
            }

            .lesson-detail {
                padding: 1rem;
            }
        }
    </style>
</@layout.page>