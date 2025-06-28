document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.only-digits').forEach(function (input) {
        input.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, '');
        });

        input.addEventListener('keypress', function (e) {
            if (!/\d/.test(e.key)) {
                e.preventDefault();
            }
        });

        input.addEventListener('paste', function (e) {
            const pasted = (e.clipboardData || window.clipboardData).getData('text');
            if (/\D/.test(pasted)) {
                e.preventDefault();
            }
        });
    });
});
