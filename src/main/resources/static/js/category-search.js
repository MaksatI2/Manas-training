document.addEventListener("DOMContentLoaded", () => {
    const input = document.querySelector("input[name='search']");
    const wrapper = document.getElementById("category-grid-wrapper");

    function fetchCategories() {
        const searchValue = input.value.trim().toLowerCase();
        const params = new URLSearchParams();
        if (searchValue) {
            params.append("search", searchValue);
        }

        fetch(`/admin/categories?${params.toString()}`, {
            headers: {"X-Requested-With": "XMLHttpRequest"}
        })
            .then(res => res.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                const newContent = doc.querySelector("#category-grid-wrapper");
                if (newContent) {
                    wrapper.innerHTML = newContent.innerHTML;
                    attachPaginationLinks();
                }
            });
    }

    function debounce(func, delay) {
        let timeout;
        return function (...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), delay);
        };
    }
    input.addEventListener("input", debounce(fetchCategories, 300));
    function attachPaginationLinks() {
        document.querySelectorAll(".category-page-link").forEach(link => {
            link.addEventListener("click", function (e) {
                e.preventDefault();
                fetch(this.href, {
                    headers: {"X-Requested-With": "XMLHttpRequest"}
                })
                    .then(res => res.text())
                    .then(html => {
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, "text/html");
                        const newContent = doc.querySelector("#category-grid-wrapper");
                        if (newContent) {
                            wrapper.innerHTML = newContent.innerHTML;
                            attachPaginationLinks();
                        }
                    });
            });
        });
    }
    attachPaginationLinks();
});
