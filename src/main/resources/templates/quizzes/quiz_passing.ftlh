<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Тест #${quiz.id}", "url": ""},
    {"label": "Прохождение", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Тест по результатам урока</h1>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-10 col-md-10">
            <div class="feature-card">
                <div class="feature-card">
                    <div class="card-body">
                        <h5 class="card-title fs-3 mb-3">Тест по теме: ${quiz.title}</h5>
                        <p class="card-text fs-4">${quiz.description}</p>
                        <p class="card-text fs-5">Количество вопросов: ${quiz.questions?size}</p>
                        <div class="alert alert-warning" role="alert">
                            <p id="countdown" class="fs-4">У вас осталось: ${quiz.questionTimeLimit}:00</p>
                        </div>
                    </div>
                </div>
                <form action="/quiz/checking" method="post" id="quizForm">
                    <#if quiz.questions??>
                        <#list quiz.questions as question>
                            <div class="feature-card">
                                <div class="card-body px-4">
                                    <h4 class="card-title mb-3">Вопрос №${question?index+1}</h4>
                                    <h5 class="card-title mb-3">${question.question}</h5>
                                    <#if question.options??>
                                        <#list question.options as option>
                                            <div class="form-check">
                                                <input class="form-check-input fs-4" type="radio"
                                                       name="questionAnswers[${question?index}].answerId"
                                                       id="question-${question?index}-option-${option?index}"
                                                       value="${option.id}">
                                                <label class="form-check-label fs-4"
                                                       for="question-${question?index}-option-${option?index}">
                                                    ${option.optionText}
                                                </label>
                                                <input type="hidden"
                                                       name="questionAnswers[${question?index}].questionId"
                                                       value="${question.id}">
                                                <input type="hidden" name="questionAnswers[${question?index}].points"
                                                       value="${question.points}">
                                            </div>
                                        </#list>
                                    </#if>
                                </div>
                            </div>
                        </#list>
                    </#if>
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>
                    <input type="hidden" name="quizId" value="${result.quizId}">
                    <input type="hidden" name="passingStart" value="${result.passingStart}">
                    <div class="text-center">
                        <input type="submit" class="btn btn-primary-custom w-75" value="Отправить">
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        let timer = ${quiz.questionTimeLimit};
        let seconds = timer * 60;
        const countDown = document.getElementById("countdown")

        const interval = setInterval(() => {
            seconds--
            const mins = Math.floor(seconds / 60);
            const secs = seconds % 60;
            const formattedSecs = secs < 10 ? "0" + secs : secs;
            countDown.textContent = "У вас осталось: " + mins + ":" + formattedSecs;

            if(seconds <= 0){
                clearInterval(interval)
                window.location.href = "http://localhost:8089/";
            }
        }, 1000)
    </script>
</@page>