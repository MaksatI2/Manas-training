<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome = springMacroRequestContext.getMessage("calendar.courseInstance.breadcrumb.home")>
<#assign bcApps = springMacroRequestContext.getMessage("calendar.courseInstance.breadcrumb.applications")>
<#assign bcCurr = springMacroRequestContext.getMessage("calendar.courseInstance.breadcrumb.current")>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/locales-all.global.min.js"></script>


<@layout.page title="<@spring.message code='calendar.courseInstance.title'/>">
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcApps, "url": "/applications/organization"},
    {"label": bcCurr, "url": ""}
    ] />

    <div class="container-fluid px-2 px-md-4 mt-3 mt-md-4">
        <div class="card shadow-sm border-0 rounded-3 mb-3 mb-md-4">
            <div class="card-header d-flex flex-column flex-md-row justify-content-between align-items-center text-white"
                 style="background: linear-gradient(135deg, #0066cc, #003d7a); border-top-left-radius: 0.5rem; border-top-right-radius: 0.5rem;">
                <h5 class="mb-2 mb-md-0">
                    <i class="fas fa-calendar-alt me-2"></i>
                    <@spring.message code="calendar.courseInstance.title"/>
                </h5>
                <a href="/applications/organization/create" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1"
                       style="color: #0066cc;"></i> <@spring.message code="calendar.courseInstance.backToApplication"/>
                </a>
            </div>
        </div>
        <div class="card shadow-sm border-0 rounded-3">
            <div class="my-3 mx-2 mx-md-4">
                <label for="courseFilter"
                       class="form-label fw-semibold text-dark"><@spring.message code="calendar.courseInstance.filter.label"/></label>
                <select id="courseFilter" class="form-select" style="max-width: 100%; width: 100%;">
                    <option value="all"><@spring.message code="calendar.courseInstance.filter.all"/></option>
                    <#list courseOptions as option>
                        <option value="${option.id()}">${option.title()}</option>
                    </#list>
                </select>
            </div>

            <div class="card-body p-2 p-md-4">
                <div id="calendar"></div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="courseModal" tabindex="-1" aria-labelledby="courseModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable modal-sm modal-md modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-primary"
                        id="courseModalLabel"><@spring.message code="calendar.courseInstance.modal.title"/></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body">
                    <dl class="row">
                        <dt class="col-5 col-md-4"><@spring.message code="calendar.courseInstance.modal.instanceTitle"/></dt>
                        <dd class="col-7 col-md-8" id="modalInstanceTitle"></dd>

                        <dt class="col-5 col-md-4"><@spring.message code="calendar.courseInstance.modal.courseTitle"/></dt>
                        <dd class="col-7 col-md-8" id="modalCourseTitle"></dd>

                        <dt class="col-5 col-md-4"><@spring.message code="calendar.courseInstance.modal.category"/></dt>
                        <dd class="col-7 col-md-8" id="modalCategory"></dd>

                        <dt class="col-5 col-md-4"><@spring.message code="calendar.courseInstance.modal.startDate"/></dt>
                        <dd class="col-7 col-md-8" id="modalStartDate"></dd>

                        <dt class="col-5 col-md-4"><@spring.message code="calendar.courseInstance.modal.endDate"/></dt>
                        <dd class="col-7 col-md-8" id="modalEndDate"></dd>

                        <dt class="col-5 col-md-4"><@spring.message code="calendar.courseInstance.modal.status"/></dt>
                        <dd class="col-7 col-md-8" id="modalStatus"></dd>
                    </dl>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const calendarEl = document.getElementById('calendar');

            const palette = [
                "#0066cc", "#2ca4ab", "#8e44ad", "#27ae60", "#e67e22", "#34495e",
                "#1abc9c", "#9b59b6", "#2980b9", "#f39c12", "#d35400", "#7f8c8d",
                "#16a085", "#bdc3c7", "#f1c40f", "#3498db", "#95a5a6", "#3f51b5",
                "#5d6d7e", "#45b39d", "#af7ac5", "#f8c471", "#52be80", "#dc7633",
                "#2874a6", "#85929e", "#1f618d", "#3cb371", "#5dade2", "#6c3483", "#48c9b0"
            ];

            function hashColor(key) {
                let h = 0;
                for (let i = 0; i < key.length; i++) h = (h * 31 + key.charCodeAt(i)) | 0;
                return palette[Math.abs(h) % palette.length];
            }

            const allEvents = [
                <#list calendarItems as item>
                {
                    title: "${item.courseInstanceTitle?js_string}",
                    start: "${item.startDate}",
                    end: "${item.endDate}",
                    color: hashColor("${item.courseId?js_string}"),
                    extendedProps: {
                        courseId: "${item.courseId?js_string}",
                        courseTitle: "${item.courseTitle?js_string}",
                        category: "${item.category?js_string}",
                        status: "${item.status?js_string}",
                        startDate: "${item.startDate}",
                        endDate: "${item.endDate}"
                    }
                }<#if item_has_next>, </#if>
                </#list>
            ];

            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: window.innerWidth < 768 ? 'dayGridWeek' : 'dayGridMonth',
                locale: '<#if springMacroRequestContext.locale?starts_with("ky")>ky<#elseif springMacroRequestContext.locale?starts_with("en")>en<#else>ru</#if>',
                firstDay: 1,
                moreLinkText: function (n) {
                    return '+' + n + ' ' + '<@spring.message code="calendar.courseInstance.moreLink"/>';
                },
                themeSystem: 'bootstrap5',
                height: 'auto',
                dayMaxEvents: 3,
                displayEventTime: false,
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: window.innerWidth < 768 ? 'dayGridWeek' : 'dayGridMonth,dayGridWeek'
                },
                buttonText: {
                    today: '<@spring.message code="calendar.courseInstance.button.today"/>',
                    month: '<@spring.message code="calendar.courseInstance.button.month"/>',
                    week: '<@spring.message code="calendar.courseInstance.button.week"/>'
                },
                events: allEvents,
                eventClick: function (info) {
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
                        if (modalInstance) modalInstance.hide();
                    }
                    const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('courseModal'));
                    modal.show();
                }
            });

            calendar.render();

            document.getElementById('courseFilter').addEventListener('change', function () {
                const selectedCourseId = this.value;
                const filtered = selectedCourseId === 'all'
                    ? allEvents
                    : allEvents.filter(e => e.extendedProps.courseId === selectedCourseId);
                calendar.removeAllEvents();
                calendar.addEventSource(filtered);
            });

            window.addEventListener('resize', () => {
                calendar.updateSize();
                calendar.setOption('headerToolbar', {
                    left: 'prev,next today',
                    center: 'title',
                    right: window.innerWidth < 768 ? 'dayGridWeek' : 'dayGridMonth,dayGridWeek'
                });
                calendar.setOption('initialView', window.innerWidth < 768 ? 'dayGridWeek' : 'dayGridMonth');
            });

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
            font-size: clamp(1.5rem, 5vw, 2rem);
            font-weight: 600;
            color: var(--primary-blue);
        }

        #calendar {
            background: var(--white);
            border-radius: 10px;
            padding: 1rem;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .fc-day-today {
            background: rgba(0, 102, 204, 0.08) !important;
            border-radius: 6px;
        }

        .fc-toolbar-title {
            text-transform: uppercase !important;
            font-size: clamp(1rem, 4vw, 1.25rem) !important;
            font-weight: 600 !important;
            color: var(--text-dark) !important;
            font-family: 'Segoe UI', Tahoma, sans-serif;
            display: inline-flex;
            align-items: center;
            gap: .25rem;
        }

        .fc-toolbar-title span {
            font-size: inherit !important;
            font-weight: inherit !important;
        }

        .fc-event {
            border-radius: 6px !important;
            font-size: clamp(.75rem, 2.5vw, .85rem);
            font-weight: 500;
            padding: 2px 4px !important;
            border: none !important;
            color: #fff !important;
            line-height: 1.2;
        }

        .fc-event:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, .3);
            transition: all .2s ease;
            cursor: pointer;
        }

        .fc-daygrid-more-link {
            font-size: clamp(.7rem, 2vw, .8rem);
            font-weight: 600;
            color: var(--primary-blue);
        }

        .fc .fc-button {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border: none;
            border-radius: 25px;
            padding: .4rem .8rem;
            color: #fff;
            font-weight: 600;
            font-size: clamp(.7rem, 2.5vw, .85rem);
            touch-action: manipulation;
        }

        .fc .fc-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, .3);
        }

        .modal-content {
            border-radius: 10px;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            background: #f5f7ff;
            border-bottom: none;
            border-radius: 10px 10px 0 0;
        }

        .modal-title {
            font-size: clamp(1.2rem, 4vw, 1.4rem);
            font-weight: 600;
            color: var(--primary-blue);
        }

        dt {
            font-weight: 600;
            color: var(--text-dark);
            font-size: clamp(.85rem, 2.5vw, .95rem);
        }

        dd {
            color: #444;
            font-size: clamp(.85rem, 2.5vw, .95rem);
        }

        @media (max-width: 576px) {
            .container-fluid {
                padding-left: .5rem !important;
                padding-right: .5rem !important;
            }

            .card-header {
                padding: .75rem;
            }

            .card-body {
                padding: .5rem !important;
            }

            .my-3 {
                margin: .5rem 0 !important;
            }

            .mx-2 {
                margin-left: .5rem !important;
                margin-right: .5rem !important;
            }

            .fc-event {
                padding: 1px 3px !important;
                font-size: clamp(.65rem, 2.2vw, .75rem);
            }

            .fc .fc-button {
                padding: .3rem .6rem;
            }
        }

        @media (min-width: 768px) {
            .modal-dialog {
                max-width: 90%;
            }
        }

        @media (max-width: 768px) {
            .modal-dialog {
                margin: .5rem;
                max-width: 100%;
            }

            .fc-daygrid-day {
                min-height: 80px;
            }
        }
    </style>
</@layout.page>
