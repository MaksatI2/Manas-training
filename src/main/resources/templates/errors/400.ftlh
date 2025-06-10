<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Некорректный запрос | JobSearch</title>
    <style>
        :root {
            --primary-color: #4f46e5;
            --error-color: #f59e0b;
            --text-color: #374151;
            --bg-color: #f9fafb;
            --overlay-color: rgba(0, 0, 0, 0.6);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        .bg-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: var(--overlay-color);
            z-index: -1;
        }

        .bg-image {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            z-index: -2;
            background-image: url('/static/images/error.webp');
        }

        .error-container {
            max-width: 700px;
            padding: 3rem 2rem;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
            animation: fadeIn 0.8s ease-out;
        }

        .error-icon {
            font-size: 6rem;
            color: var(--error-color);
            margin-bottom: 2rem;
            animation: bounce 2s infinite;
        }

        h1 {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            color: white;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        p {
            font-size: 1.3rem;
            margin-bottom: 2.5rem;
            max-width: 80%;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
        }

        .error-code {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-family: monospace;
            font-size: 1rem;
            color: white;
            margin-bottom: 2rem;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .home-link {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            text-decoration: none;
            padding: 1rem 2.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            margin-top: 1rem;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
            position: relative;
            overflow: hidden;
        }

        .home-link:hover {
            background-color: #4338ca;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
        }

        .home-link:active {
            transform: translateY(1px);
        }

        .home-link::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent 25%, rgba(255,255,255,0.1) 50%, transparent 75%);
            background-size: 400% 400%;
            opacity: 0;
            transition: all 0.5s ease;
        }

        .home-link:hover::after {
            opacity: 1;
            animation: shine 1.5s infinite;
        }

        .error-details {
            margin-top: 3rem;
            padding: 1.5rem;
            background-color: rgba(0, 0, 0, 0.4);
            border-radius: 10px;
            font-size: 1rem;
            text-align: left;
            width: 100%;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: slideUp 0.6s ease-out;
        }

        .error-details p {
            font-size: 1rem;
            margin-bottom: 1rem;
            max-width: 100%;
        }

        .field-errors {
            margin-top: 1.5rem;
        }

        .field-error {
            color: #ffb347;
            margin-bottom: 0.8rem;
            padding-left: 1rem;
            border-left: 3px solid #ffb347;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-20px); }
            60% { transform: translateY(-10px); }
        }

        @keyframes shine {
            0% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
    </style>
</head>
<body>
<div class="bg-image"></div>
<div class="bg-overlay"></div>

<div class="error-container">
    <div class="error-icon">⚠️</div>
    <h1>Некорректный запрос</h1>
    <p>Пожалуйста, проверьте введенные данные и попробуйте снова.</p>
    <div class="error-code">Ошибка 400</div>

    <a href="/" class="home-link">Вернуться на главную</a>

    <#if error??>
        <div class="error-details">
            <p><strong>Дополнительная информация:</strong></p>
            <p>${error}</p>

            <#if fieldErrors??>
                <div class="field-errors">
                    <#list fieldErrors as field, message>
                        <div class="field-error"><strong>${field}:</strong> ${message}</div>
                    </#list>
                </div>
            </#if>
        </div>
    </#if>
</div>

<script>
    document.body.style.opacity = 0;
    window.addEventListener('DOMContentLoaded', () => {
        setTimeout(() => {
            document.body.style.transition = 'opacity 0.8s ease';
            document.body.style.opacity = 1;
        }, 100);
    });
</script>
</body>
</html>