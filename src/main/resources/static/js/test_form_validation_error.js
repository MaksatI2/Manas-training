function errorMessage(field, text, labelId){
    let error = document.createElement("label")
    error.setAttribute("for", field)
    error.setAttribute("class", "text-danger error-message")
    if(labelId){
        error.setAttribute("id", labelId)
    }
    error.innerText = text
    return error;
}

function isInvalid(id){
    let input = document.getElementById(id)
    input.classList.add("is-invalid")
    return input;
}