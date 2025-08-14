<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <#assign bcHome><@spring.message code='quiz.breadcrumb.home'/></#assign>
    <#assign bcMyCourses><@spring.message code='quiz.student.myCourses.title'/></#assign>
    <#assign bcLessonPrefix><@spring.message code='lesson.prefix'/></#assign>
    <#assign bcQuizPrefix><@spring.message code='quiz.prefix'/></#assign>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyCourses, "url": "/student/my-courses"},
    {"label": "${lesson.courseModule.courseInstance.title}", "url": "/student/course/${lesson.courseModule.courseInstance.id}"},
    {"label": bcLessonPrefix + " ${lesson.title}", "url": "/lessons/${lesson.id}"},
    {"label": bcQuizPrefix + " ${quiz.title}", "url": ""}
    ] />

    <div class="hero-section">
        <h1 class="hero-title"><i
                    class="fa-solid fa-list-check"></i> <@spring.message code="student.quiz.take.title.prefix" />
            "${quiz.lesson.title}"</h1>
        <p class="hero-subtitle fs-4"><@spring.message code="student.quiz.take.timeLeft" /> <span class="fw-bold"
                                                                                                  id="countdown">${quiz.questionTimeLimit}:00</span>
        </p>
    </div>
    <div class="row justify-content-center">
        <div class="col-12 col-md-10 col-lg-8 mx-auto">
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3 text-break">${quiz.title}</h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3 text-break">${quiz.description}</p>
                    <p class="card-text fs-5 text-break"><span
                                class="fw-bold"><@spring.message code="student.quiz.take.questionsCount" /> </span> ${quiz.questions?size}
                    </p>
                </div>
            </div>
            <form action="/quiz/checking" method="post" id="quizForm">
                <#if quiz.questions??>
                    <#assign bindingResult = .globals["org.springframework.validation.BindingResult.result"]>
                    <#list quiz.questions as question>
                        <#if result.questionAnswers?has_content>
                            <#assign userAnswer = result.questionAnswers?filter(a -> a.questionId == question.id)?first>
                        </#if>
                        <div class="feature-card">
                            <div class="card-body px-4">
                                <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3"><@spring.message code="student.quiz.take.questionNumber" />${question?index+1}
                                    <#if bindingResult?? && bindingResult.hasFieldErrors("questionAnswers[" + question?index + "].answerId")>
                                        <#list bindingResult.getFieldErrors("questionAnswers[" + question?index + "].answerId") as error>
                                            <span class="text-danger">${error.defaultMessage}</span>
                                        </#list>
                                    </#if>
                                </h4>
                                <h5 class="card-title mb-3 fs-4 text-break">${question.question}</h5>
                                <#if question.options??>
                                    <ul class="list-group">
                                        <#list question.options as option>
                                            <li class="list-group-item border-primary-subtle fs-5">
                                                <input class="form-check-input me-1 fs-4" type="radio"
                                                       name="questionAnswers[${question?index}].answerId"
                                                       id="question-${question?index}-option-${option?index}"
                                                       value="${option.id}" <#if userAnswer?? && userAnswer.answerId?? && userAnswer.answerId == option.id> checked </#if>>
                                                <label class="form-check-label fs-4 text-break"
                                                       for="question-${question?index}-option-${option?index}">
                                                    ${option.optionText}
                                                </label>
                                            </li>
                                        </#list>
                                    </ul>
                                </#if>
                            </div>
                        </div>
                        <input type="hidden" name="questionAnswers[${question?index}].questionId"
                               value="${question.id}">
                    </#list>
                </#if>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>
                <input type="hidden" name="quizId" value="${result.quizId}">
                <input type="hidden" name="passingStart" value="${result.passingStart}">
                <div class="text-center">
                    <input type="submit" class="btn btn-primary-custom w-75"
                           value="<@spring.message code='student.quiz.take.submit'/>">
                </div>
            </form>
        </div>
    </div>
    <script>
        let startTime = new Date("${startTime}")
        let duration = ${timer} * 60 * 1000;
        let endTime = new Date(startTime.getTime() + duration);
        const countDown = document.getElementById("countdown")

        function updateTimer() {
            let now = new Date();
            let timer = endTime - now;
            const min = Math.floor(timer / 1000 / 60);
            const sec = Math.floor((timer / 1000) % 60);
            countDown.textContent = min.toString().padStart(2, "0") + ":" + sec.toString().padStart(2, "0");
            if (timer <= 0) {
                countDown.textContent = "00:00"
                window.location.href = "http://localhost:8089/quiz/${quiz.id}/time-is-over";
            }
        }

        setInterval(updateTimer, 100);
        updateTimer();
    </script>
</@page>
