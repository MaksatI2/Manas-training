<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<@layout.page>
    <#assign bcHome><@spring.message code='student.myTests.breadcrumb.home'/></#assign>
    <#assign bcMyTests><@spring.message code='student.myTests.breadcrumb.myTests'/></#assign>
    <#assign pageTitle><@spring.message code='student.myTests.title'/></#assign>
    <#assign tabActive><@spring.message code='student.myTests.tab.active'/></#assign>
    <#assign tabPast><@spring.message code='student.myTests.tab.past'/></#assign>
    <#assign emptyActive><@spring.message code='student.myTests.empty.active'/></#assign>
    <#assign emptyPast><@spring.message code='student.myTests.empty.past'/></#assign>

    <div class="container py-4">
        <@roadmap.breadcrumbs items=[
        {"label": bcHome, "url": "/"},
        {"label": bcMyTests, "url": ""}
        ] />

        <div class="card shadow mb-4">
            <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <h5 class="m-0 font-weight-bold text-white">
                        <i class="fa-solid fa-clipboard-list me-2"></i>${pageTitle}
                    </h5>
                </div>
            </div>

            <div class="card-body">
                <ul class="nav nav-tabs mb-3" id="testsTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="active-tab" data-bs-toggle="tab"
                                data-bs-target="#active-tests" type="button" role="tab"
                                aria-controls="active-tests" aria-selected="true">
                            ${tabActive}
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="past-tab" data-bs-toggle="tab"
                                data-bs-target="#past-tests" type="button" role="tab"
                                aria-controls="past-tests" aria-selected="false">
                            ${tabPast}
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="testsTabsContent">
                    <div class="tab-pane fade show active" id="active-tests" role="tabpanel"
                         aria-labelledby="active-tab">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                                <tr>
                                    <th><@spring.message code="student.myTests.table.course"/></th>
                                    <th><@spring.message code="student.myTests.table.test"/></th>
                                    <th><@spring.message code="student.myTests.table.time"/></th>
                                    <th><@spring.message code="student.myTests.table.status"/></th>
                                    <th class="text-center"><@spring.message code="student.myTests.table.action"/></th>
                                </tr>
                                </thead>
                                <tbody>
                                <#if activeTests?has_content>
                                    <#list activeTests as item>
                                        <tr>
                                            <td>
                                                <div class="fw-semibold">${item.courseTitle}</div>
                                                <div class="text-muted small">${item.courseInstanceTitle}</div>
                                            </td>
                                            <td>${item.testTitle}</td>
                                            <td>${item.timeRange}</td>
                                            <td>
                                                <#if !item.isActive>
                                                    <span class="badge bg-secondary"><@spring.message code="student.myTests.status.inactive"/></span>
                                                <#elseif item.isAvailable>
                                                    <span class="badge bg-primary">
                                                        <@spring.message code="student.myTests.status.available"/>
                                                        <#if item.attemptCount gt 0>
                                                            (${item.attemptCount}/2)
                                                        </#if>
                                                    </span>
                                                <#else>
                                                    <span class="badge bg-warning text-dark"><@spring.message code="student.myTests.status.upcoming"/></span>
                                                </#if>
                                            </td>
                                            <td class="text-center">
                                                <#if item.canStart>
                                                    <button type="button" class="btn btn-primary btn-sm js-start-test"
                                                            data-bs-toggle="modal" data-bs-target="#startTestModal"
                                                            data-url="/test/${item.testInstanceId}/passing"
                                                            data-title="${item.testTitle}"
                                                            data-attempt="${item.attemptCount + 1}">
                                                        <i class="fas fa-play me-1"></i>
                                                        <#if item.attemptCount == 0>
                                                            <@spring.message code="student.myTests.action.start"/>
                                                        <#else>
                                                            <@spring.message code="student.myTests.action.retry"/>
                                                        </#if>
                                                    </button>
                                                <#else>
                                                    <button type="button" class="btn btn-outline-secondary btn-sm" disabled>
                                                        <@spring.message code="student.myTests.action.unavailable"/>
                                                    </button>
                                                </#if>
                                            </td>
                                        </tr>
                                    </#list>
                                <#else>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="fas fa-clipboard-check fa-2x mb-2" style="color: #0066cc;"></i>
                                            <p class="mb-0">${emptyActive}</p>
                                        </td>
                                    </tr>
                                </#if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="past-tests" role="tabpanel" aria-labelledby="past-tab">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                                <tr>
                                    <th><@spring.message code="student.myTests.table.course"/></th>
                                    <th><@spring.message code="student.myTests.table.test"/></th>
                                    <th><@spring.message code="student.myTests.table.time"/></th>
                                    <th><@spring.message code="student.myTests.table.status"/></th>
                                    <th class="text-center"><@spring.message code="student.myTests.table.action"/></th>
                                </tr>
                                </thead>
                                <tbody>
                                <#if pastTests?has_content>
                                    <#list pastTests as item>
                                        <tr>
                                            <td>
                                                <div class="fw-semibold">${item.courseTitle}</div>
                                                <div class="text-muted small">${item.courseInstanceTitle}</div>
                                            </td>
                                            <td>${item.testTitle}</td>
                                            <td>${item.timeRange}</td>
                                            <td>
                                                <#if item.hasPassedAttempt>
                                                    <span class="badge bg-success"><@spring.message code="student.myTests.status.passed"/></span>
                                                <#elseif item.attemptCount == 2>
                                                    <span class="badge bg-danger"><@spring.message code="student.myTests.status.failed"/></span>
                                                <#else>
                                                    <span class="badge bg-secondary"><@spring.message code="student.myTests.status.closed"/></span>
                                                </#if>
                                            </td>
                                            <td class="text-center">
                                                <#if item.hasPassedAttempt>
                                                    <a href="/test/${item.testInstanceId}/result/details" class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-info-circle me-1"></i><@spring.message code="student.myTests.action.result"/>
                                                    </a>
                                                <#else>
                                                    <span class="text-muted small">
                                                        <@spring.message code="student.myTests.attempts"/> ${item.attemptCount}/2
                                                    </span>
                                                </#if>
                                            </td>
                                        </tr>
                                    </#list>
                                <#else>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="fas fa-history fa-2x mb-2" style="color: #0066cc;"></i>
                                            <p class="mb-0">${emptyPast}</p>
                                        </td>
                                    </tr>
                                </#if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="startTestModal" tabindex="-1" aria-labelledby="startTestModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="startTestModalLabel"><@spring.message code="student.myTests.modal.title"/></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p><@spring.message code="student.myTests.modal.body"/></p>
                    <div class="fw-semibold mb-2" id="startTestTitle"></div>
                    <div class="text-muted small" id="startTestAttempt"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <@spring.message code="student.myTests.modal.cancel"/>
                    </button>
                    <a href="#" class="btn btn-primary" id="confirmStartTest">
                        <@spring.message code="student.myTests.modal.confirm"/>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <style>
        #testsTabs .nav-link{
            color: #003d7a;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            margin-right: .25rem;
        }

        #testsTabs .nav-link:hover,
        #testsTabs .nav-link:focus{
            color: #003d7a;
            background-color: #e9ecef;
        }

        #testsTabs .nav-link::before{
            background: none !important;
        }

        #testsTabs .nav-link.active{
            color: #ffffff;
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #003d7a;
        }

        #testsTabsContent{
            border: 1px solid #dee2e6;
            border-top: none;
            border-radius: 0 0 .375rem .375rem;
            padding: 1rem;
            background: #fff;
        }
    </style>


    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const confirmBtn = document.getElementById('confirmStartTest');
            const titleEl = document.getElementById('startTestTitle');
            const attemptEl = document.getElementById('startTestAttempt');

            document.querySelectorAll('.js-start-test').forEach(btn => {
                btn.addEventListener('click', function () {
                    const url = this.getAttribute('data-url');
                    const title = this.getAttribute('data-title');
                    const attempt = this.getAttribute('data-attempt');
                    confirmBtn.setAttribute('href', url);
                    titleEl.textContent = title || '';
                    if (attempt) {
                        attemptEl.textContent = '<@spring.message code="student.myTests.modal.attempt"/> ' + attempt + '/2';
                    } else {
                        attemptEl.textContent = '';
                    }
                });
            });
        });
    </script>
</@layout.page>
