form.addEventListener("submit", event => {
    let hasError = false;
    if (document.querySelectorAll(".error-message")){
        let errors = document.querySelectorAll(".error-message")
        errors.forEach(er => {
            er.remove()
        })
    }
    if (document.querySelectorAll(".is-invalid")){
        let inputs = document.querySelectorAll(".is-invalid")
        inputs.forEach(i => {
            i.classList.remove("is-invalid")
        })
    }
    let form = event.target
    let formData = new FormData(form);
    let data = Object.fromEntries(formData.entries())
    console.log(data)
    const testQuestions = new Map();
    for (let [key, value] of formData.entries()) {
        const qMatch = key.match(/^questions\[(\d+)]\.question$/);
        const oMatch = key.match(/^questions\[(\d+)]\.options\[(\d+)]\.optionText$/);

        if (qMatch) {
            const qIndex = parseInt(qMatch[1]);
            if (!testQuestions.has(qIndex)) testQuestions.set(qIndex, { question: "", options: [] });
            testQuestions.get(qIndex).question = value.trim();
        }

        if (oMatch) {
            const qIndex = parseInt(oMatch[1]);
            const oIndex = parseInt(oMatch[2]);
            if (!testQuestions.has(qIndex)) testQuestions.set(qIndex, { question: "", options: [] });
            testQuestions.get(qIndex).options[oIndex] = value.trim();
        }
    }

    if(!data.title){
        hasError = true;
        isInvalid("title").insertAdjacentElement('afterend', errorMessage("title", "Заполните название теста"));
    }
    if(!data.description){
        hasError  =true;
        isInvalid("description").insertAdjacentElement('afterend', errorMessage("description", "Заполните описание теста"));
    }
    if(!data.questionTimeLimit){
        hasError = true;
        isInvalid("questionTimeLimit").insertAdjacentElement('afterend', errorMessage("questionTimeLimit", "Заполните время прохождени теста"));
    }

    const questionsArray = Array.from(testQuestions.entries())
        .map(([_, value]) => ({
            question: value.question,
            options: value.options
        }));
    console.log(questionsArray)
    const questionsCount = questionsArray.length;
    for(let i = 0; i < questionsCount; i++){
        if(!questionsArray[i].question){
            hasError = true
            let input = document.getElementById("questions"+i+".question")
            if (input){
                input.classList.add("is-invalid")
                input.parentNode.insertBefore(errorMessage("questions"+i+".question", "Заполните текст вопроса","invalid-questionId-"+i), input.nextSibling);
            }
        }
        const optionCount = questionsArray[i].options.length
        for(let a = 0; a < optionCount; a++){
            if(!questionsArray[i].options[a]){
                hasError = true
                let input = document.getElementById("questions"+i+".options"+a+".optionText")
                if (input){
                    input.classList.add("is-invalid")
                    let div = document.getElementById("questionId-"+i+"-optionId-"+a)
                    div.parentNode.insertBefore(errorMessage("questions"+i+".options"+a+".optionText", "Заполните вариант ответа", "invalid-questionId-"+i+"-optionId-"+a), div.nextSibling);
                }
            }
        }
    }
    if(hasError){
        event.preventDefault();
    }
})

timeInput.addEventListener('input', () => {
    timeInput.value = timeInput.value.replace(/[^0-9]/g, '');
    if (parseInt(timeInput.value) > 60) {
        timeInput.value = '60';
    }
});