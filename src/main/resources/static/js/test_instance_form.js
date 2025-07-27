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
    let form = event.target;
    let formData = new FormData(form)
    let data = Object.fromEntries(formData);
    console.log(data)
    if(!data.testId){
        hasError = true
        isInvalid("testId").insertAdjacentElement('afterend', errorMessage("testId", "Выберите тест для данного потока"));
    }
    if(!data.startDate){
        hasError = true
        isInvalid("startDate").insertAdjacentElement('afterend', errorMessage("startDate", "Укажите дату"));
    }
    if(!data.endDate){
        hasError = true
        isInvalid("endDate").insertAdjacentElement('afterend', errorMessage("endDate", "Укажите дату"));
    }
    if(!data.startTime){
        hasError = true
        isInvalid("startTime").insertAdjacentElement('afterend', errorMessage("startTime", "Укажите время"));
    }
    if(!data.endTime){
        hasError = true
        isInvalid("endTime").insertAdjacentElement('afterend', errorMessage("endTime", "Укажите время"));
    }

    if(hasError){
        event.preventDefault();
    }
})

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".input-date").forEach(input => {
        input.setAttribute("type", "date");
        const today = new Date().toISOString().split("T")[0];
        input.setAttribute("min", today);
    });
    document.querySelectorAll(".input-time").forEach(input => {
        input.setAttribute("type", "time");
    });
});
