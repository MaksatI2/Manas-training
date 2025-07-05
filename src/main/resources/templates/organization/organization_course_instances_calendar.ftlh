<#import "../layout.ftlh" as layout>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js" defer></script>

<@layout.page title="Календарь потоков курсов">
    <div class="container-fluid px-4 mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="page-title mb-0 text-primary">
                <i class="fas fa-calendar-alt me-2"></i>
                Календарь потоков курсов
            </h2>
        </div>

        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-4">
                <div id="calendar"></div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="courseModal" tabindex="-1" aria-labelledby="courseModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-primary" id="courseModalLabel">Детали потока курса</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <dl class="row">
                        <dt class="col-sm-4">Название потока:</dt>
                        <dd class="col-sm-8" id="modalInstanceTitle"></dd>

                        <dt class="col-sm-4">Курс:</dt>
                        <dd class="col-sm-8" id="modalCourseTitle"></dd>

                        <dt class="col-sm-4">Категория:</dt>
                        <dd class="col-sm-8" id="modalCategory"></dd>

                        <dt class="col-sm-4">Дата начала:</dt>
                        <dd class="col-sm-8" id="modalStartDate"></dd>

                        <dt class="col-sm-4">Дата окончания:</dt>
                        <dd class="col-sm-8" id="modalEndDate"></dd>

                        <dt class="col-sm-4">Статус:</dt>
                        <dd class="col-sm-8" id="modalStatus"></dd>
                    </dl>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const calendarEl = document.getElementById('calendar');
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ru',
                moreLinkText: function(n) {
                    return `+${'$'}{n} ещё`;
                },
                themeSystem: 'bootstrap5',
                height: 'auto',
                dayMaxEvents: 3,
                displayEventTime: false,
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,dayGridWeek'
                },
                buttonText: {
                    today: 'Сегодня',
                    month: 'Месяц',
                    week: 'Неделя'
                },
                events: [
                    <#list calendarItems as item>
                    {
                        title: "${item.courseInstanceTitle?js_string}",
                        start: "${item.startDate}",
                        end: "${item.endDate}",
                        color: "${item.color!'#3f51b5'}",
                        extendedProps: {
                            courseTitle: "${item.courseTitle?js_string}",
                            category: "${item.category?js_string}",
                            status: "${item.status?js_string}",
                            startDate: "${item.startDate}",
                            endDate: "${item.endDate}"
                        }
                    }<#if item_has_next>,</#if>
                    </#list>
                ],
                eventClick: function(info) {
                    const props = info.event.extendedProps;

                    document.getElementById('modalInstanceTitle').innerText = info.event.title;
                    document.getElementById('modalCourseTitle').innerText = props.courseTitle;
                    document.getElementById('modalCategory').innerText = props.category;
                    document.getElementById('modalStartDate').innerText = props.startDate;
                    document.getElementById('modalEndDate').innerText = props.endDate;
                    document.getElementById('modalStatus').innerText = props.status;

                    const existingModal = document.querySelector('.modal.show');
                    if (existingModal) {
                        const modalInstance = bootstrap.Modal.getInstance(existingModal);
                        if (modalInstance) {
                            modalInstance.hide();
                        }
                    }
                    const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('courseModal'));
                    modal.show();
                }

            });

            calendar.render();
            setTimeout(() => {
                calendar.updateSize();
            }, 5);
        });
    </script>
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .page-title {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--primary-blue);
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }
        }

        #calendar {
            background: var(--white);
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .fc-event {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)) !important;
            color: var(--white) !important;
            border-radius: 6px !important;
            font-size: 0.9rem;
            font-weight: 500;
            padding: 2px 6px !important;
            border: none !important;
        }

        .fc-event:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .fc-daygrid-more-link {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--primary-blue);
        }

        .fc .fc-button {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border: none;
            border-radius: 25px;
            padding: 0.5rem 1rem;
            color: white;
            font-weight: 600;
        }

        .fc .fc-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .fc-toolbar-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .modal-header {
            background: #f5f7ff;
            border-bottom: none;
            border-radius: 15px 15px 0 0;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-blue);
        }

        dt {
            font-weight: 600;
            color: var(--text-dark);
        }

        dd {
            color: #444;
        }
    </style>

</@layout.page>
