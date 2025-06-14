document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.querySelector("input[name='search']");
    const filters = document.querySelectorAll("select[name='categoryId'], select[name='isActive'], select[name='isIndividual']");

    function applyFilters() {
        const baseUrl = "/admin/courses";
        const params = new URLSearchParams();
        const search = searchInput.value.trim();
        if (search) {
            params.append("search", search.toLowerCase());
        }
        filters.forEach(select => {
            const value = select.value;
            if (value !== "") {
                params.append(select.name, value);
            }
        });

        console.log("Отправка фильтрации:", params.toString());

        fetch(`${baseUrl}?${params.toString()}`, {
            headers: {"X-Requested-With": "XMLHttpRequest"}
        })
            .then(res => res.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                const newGridWrapper = doc.querySelector("#courses-grid-wrapper");
                const currentWrapper = document.querySelector("#courses-grid-wrapper");

                if (newGridWrapper && currentWrapper) {
                    currentWrapper.innerHTML = newGridWrapper.innerHTML;
                } else {
                    console.warn("courses-grid-wrapper не найден в ответе сервера.");
                }
            })
            .catch(err => {
                console.error("Ошибка при загрузке курсов:", err);
            });
    }
    function debounce(func, delay) {
        let timeout;
        return function (...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), delay);
        };
    }
    searchInput.addEventListener("input", debounce(applyFilters, 300));
    filters.forEach(select => {
        select.addEventListener("change", applyFilters);
    });
});
