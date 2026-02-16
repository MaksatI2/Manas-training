document.addEventListener("DOMContentLoaded", function () {
    const container = document.getElementById("flash-message-container");
    const animateCSS = (element, animation, prefix = 'animate__') => {
        return new Promise((resolve) => {
            const animationName = `${prefix}${animation}`;

            element.classList.add(`${prefix}animated`, animationName);

            function handleAnimationEnd() {
                element.classList.remove(`${prefix}animated`, animationName);
                element.removeEventListener('animationend', handleAnimationEnd);
                resolve();
            }

            element.addEventListener('animationend', handleAnimationEnd);
        });
    };

    const showFlash = async (type, message, options = {}) => {
        const {
            autoClose = true,
            duration = 4000,
            position = 'top-right',
            action = null
        } = options;

        const alert = document.createElement("div");
        alert.className = `alert alert-${type} alert-dismissible animate__animated animate__fadeInRight`;
        alert.setAttribute("role", "alert");

        Object.assign(alert.style, {
            minWidth: "280px",
            boxShadow: "0 4px 20px rgba(0,0,0,0.15)",
            borderRadius: "12px",
            margin: "0.5rem",
            cursor: "pointer",
            transition: "transform 0.2s, opacity 0.3s",
            display: "flex",
            alignItems: "center",
            position: "relative"
        });

        const icons = {
            success: '<i class="fas fa-check-circle me-3" style="color: #2ecc71;"></i>',
            danger: '<i class="fas fa-exclamation-circle me-3" style="color: #e74c3c;"></i>',
            info: '<i class="fas fa-info-circle me-3" style="color: #3498db;"></i>',
            warning: '<i class="fas fa-exclamation-triangle me-3" style="color: #f39c12;"></i>'
        };

        const actionBtn = action ?
            `<button class="btn btn-sm btn-outline-${type} ms-2 action-btn">${action.text}</button>` : '';

        alert.innerHTML = `
            ${icons[type] || icons.info}
            <div style="flex-grow: 1;">${message}</div>
            ${actionBtn}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="margin-left: 1rem;"></button>
        `;

        container.appendChild(alert);

        container.style.position = 'fixed';
        container.style[position.includes('top') ? 'top' : 'bottom'] = '20px';
        container.style[position.includes('right') ? 'right' : 'left'] = '20px';
        container.style.zIndex = '9999';
        container.style.display = 'flex';
        container.style.flexDirection = position.includes('top') ? 'column' : 'column-reverse';

        alert.addEventListener('mouseenter', () => {
            alert.style.transform = 'translateY(-2px)';
            alert.style.boxShadow = '0 6px 25px rgba(0,0,0,0.2)';
        });

        alert.addEventListener('mouseleave', () => {
            alert.style.transform = '';
            alert.style.boxShadow = '0 4px 20px rgba(0,0,0,0.15)';
        });

        if (action) {
            alert.querySelector('.action-btn')?.addEventListener('click', (e) => {
                e.stopPropagation();
                action.handler();
                removeAlert();
            });
        }

        alert.addEventListener('click', () => {
            removeAlert();
        });

        const removeAlert = async () => {
            await animateCSS(alert, 'fadeOut');
            alert.remove();
        };

        if (autoClose) {
            setTimeout(async () => {
                if (document.body.contains(alert)) {
                    await removeAlert();
                }
            }, duration);
        }
    };

    const successEl = document.getElementById("successMessage");
    const errorEl = document.getElementById("errorMessage");

    if (successEl) {
        showFlash("success", successEl.dataset.message, {
            position: successEl.dataset.position || 'top-right',
            duration: successEl.dataset.duration ? parseInt(successEl.dataset.duration) : 4000,
            action: successEl.dataset.action ? JSON.parse(successEl.dataset.action) : null
        });
    }

    if (errorEl) {
        showFlash("danger", errorEl.dataset.message, {
            position: errorEl.dataset.position || 'top-right',
            duration: errorEl.dataset.duration ? parseInt(errorEl.dataset.duration) : 6000,
            action: errorEl.dataset.action ? JSON.parse(errorEl.dataset.action) : null
        });
    }

    window.showFlashMessage = showFlash;
});