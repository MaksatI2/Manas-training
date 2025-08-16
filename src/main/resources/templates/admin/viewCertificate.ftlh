<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page title="Сертификаты">

    <!DOCTYPE html>
    <html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Сертификат о достижении</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>

        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700&display=swap');

        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter', sans-serif; background: linear-gradient(135deg,#f8fafc 0%,#e2e8f0 50%,#cbd5e1 100%); }

        .certificate-container {
            width: 900px;
            min-height: 800px;
            background: #fef7ed;
            display: flex;
            box-shadow: 0 25px 80px rgba(0,0,0,0.15);
            border-radius: 16px;
            position: relative;
            margin: 10px auto 10px;
            overflow: visible;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes scaleIn {
            from { transform: scale(0.9); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }


        .print-button-wrapper {
            width: 900px;
            margin: 20px auto 0;
            display: flex;
            justify-content: flex-end;
        }

        .print-button-wrapper button {
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 600;
            background: #1d4ed8;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }


        .left-panel {
            width: 240px;
            background: #fef7ed;
            display: flex;
            flex-direction: column;
            padding: 0;
            min-height: 800px;
        }

        .geometric-pattern {
            display: grid;
            grid-template-columns: repeat(3,1fr);
            gap:8px;
            padding:20px;
            box-sizing:border-box;
        }

        .pdf-ready .certificate-title,
        .pdf-ready .recipient-name {
            color: #ad8c53 !important;
            background: none !important;
            -webkit-background-clip: unset !important;
            -webkit-text-fill-color: unset !important;
        }

        .shape { width:100%; height:100%; min-height:30px; border-radius:8px; aspect-ratio:1; }
        .shape-1 { background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius:50% 0 50% 0; }
        .shape-2 { background: linear-gradient(135deg, #f59e0b, #d97706); }
        .shape-3 { background: linear-gradient(135deg, #1e40af, #0f172a); clip-path: polygon(50% 0%,0% 100%,100% 100%); }
        .shape-4 { background: linear-gradient(135deg, #ef4444, #dc2626); border-radius:50%; }
        .shape-5 { background: linear-gradient(135deg, #3b82f6, #1e40af); }
        .shape-6 { background: linear-gradient(135deg, #f59e0b, #d97706); border-radius:0 50% 0 50%; }
        .shape-7 { background: linear-gradient(135deg, #1e40af, #0f172a); }
        .shape-8 { background: linear-gradient(135deg, #ef4444, #dc2626); clip-path: polygon(0%0%,100%50%,0%100%); }

        .right-panel {
            flex:1;
            padding:60px 50px;
            display:flex;
            flex-direction:column;
            background:#fefefe;
            position:relative;
        }

        .header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:30px; }
        .logo-container { width:220px; height:60px; display:flex; align-items:center; justify-content:center; }
        .logo-container img { max-width:100%; max-height:100%; object-fit:contain; }

        .company-info h2 { font-size:14px; font-weight:700; color:#1e293b; margin-bottom:8px; text-transform:uppercase; letter-spacing:1px; }
        .company-info p { font-size:11px; color:#64748b; line-height:1.2; margin:2px 0; }

        .certificate-title { font-size:52px; font-weight:800; background:#ad8c53; -webkit-background-clip:text; -webkit-text-fill-color:transparent; text-transform:uppercase; letter-spacing:4px; margin-bottom:6px; font-family:'Inter',sans-serif; }
        .certificate-subtitle { font-size:12px; font-weight:500; color:#64748b; text-transform:uppercase; letter-spacing:3px; margin-bottom:25px; }
        .presentation-text { font-size:12px; color:#475569; margin-bottom:15px; text-transform:uppercase; font-weight:500; letter-spacing:1px; }

        .recipient-name {
            font-family:'Playfair Display', serif;
            font-size:32px;
            font-weight:600;
            background:#ad8c53;
            -webkit-background-clip:text;
            -webkit-text-fill-color:transparent;
            margin-bottom:20px;
            line-height:1.1;
        }

        .description-text { font-size:11px; color:#475569; line-height:1.6; margin-bottom:15px; text-align:justify; }

        .course-title { font-size:14px; font-weight:700; color:#1e293b; margin:12px 0; text-transform:uppercase; letter-spacing:1px; }
        .company-mention { font-size:11px; color:#64748b; margin-bottom:15px; font-style:italic; }

        .details-grid { display:grid; grid-template-columns:1fr 1fr; gap:15px; margin:15px 0; }
        .detail-item .label { color:#64748b; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; display:block; font-size:9px; font-weight:600; }
        .detail-item .value { font-weight:700; color:#1e293b; font-size:11px; }

        .footer {
            margin-top:auto;
            display:flex;
            justify-content:space-between;
            align-items:flex-end;
            padding-top:20px;
            border-top:2px solid #e2e8f0;
            height:60px;
        }

        .signature-section { text-align:center; min-width:120px; display:flex; flex-direction:column; justify-content:flex-start; }
        .signature-section .label { font-size:9px; text-transform:uppercase; letter-spacing:1px; color:#64748b; font-weight:600; margin:0; }
        .signature-line { width:100px; height:2px; background: linear-gradient(135deg,#3b82f6,#1d4ed8); margin:15px auto 8px; border-radius:1px; }
        .signature-name { font-size:11px; color:#1e293b; font-weight:600; }

        .certificate-number {
            position:absolute;
            top:20px;
            right:20px;
            background: linear-gradient(135deg,#1e293b,#0f172a);
            color:#fff;
            padding:8px 12px;
            font-size:9px;
            font-weight:700;
            letter-spacing:1px;
            border-radius:6px;
        }

        .decorative-dots {
            position:absolute;
            top:0;
            right:0;
            width:100px;
            height:100px;
            opacity:0.1;
            background-image: radial-gradient(circle,#3b82f6 2px, transparent 2px);
            background-size:20px 20px;
        }

        @media print {
            * {
                -webkit-print-color-adjust: exact !important;
                color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            html, body {
                margin: 0;
                padding: 0;
                background: #ffffff !important;
                width: 100%;
                height: 100%;
            }

            #printCert,
            [style*="position: fixed"],
            .no-print,
            .navbar, .breadcrumbs, header, footer, .sidebar, .page-wrapper, .page-header, .page-footer {
                display: none !important;
            }

            @page {
                margin: 15mm;
            }

            .certificate-container {
                width: 267mm !important;
                height: 180mm !important;
                margin: 0 !important;
                padding: 0 !important;
                box-shadow: none !important;
                border-radius: 0 !important;
                display: flex !important;
                flex-wrap: nowrap !important;
                page-break-inside: avoid !important;
                break-inside: avoid !important;
                overflow: hidden !important;
            }
        }

    </style>


</head>


<body>
<div id="languageModal" class="no-print" style="
    display: none !important;
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 9999;
    /*display: flex;*/
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(4px);
    animation: fadeIn 0.3s ease-in-out;
">

    <div style="
        background: white;
        padding: 36px 48px;
        border-radius: 16px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
        text-align: center;
        width: 320px;
        font-family: 'Inter', sans-serif;
        animation: scaleIn 0.3s ease-out;
    ">
        <h2 style="margin-bottom: 24px; font-size: 20px; font-weight: 700; color: #1f2937;">Выберите язык</h2>

        <div style="display: flex; flex-direction: column; gap: 14px;">
            <button onclick="setLanguage('ru')" style="
                padding: 12px;
                font-size: 15px;
                font-weight: 600;
                background: #1d4ed8;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.2s;
            " onmouseover="this.style.background='#2563eb'" onmouseout="this.style.background='#1d4ed8'">
                Русский
            </button>

            <button onclick="setLanguage('en')" style="
                padding: 12px;
                font-size: 15px;
                font-weight: 600;
                background: #10b981;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.2s;
            " onmouseover="this.style.background='#059669'" onmouseout="this.style.background='#10b981'">
                English
            </button>

            <button onclick="setLanguage('kg')" style="
                padding: 12px;
                font-size: 15px;
                font-weight: 600;
                background: #f59e0b;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.2s;
            " onmouseover="this.style.background='#d97706'" onmouseout="this.style.background='#f59e0b'">
                Кыргызча
            </button>
        </div>
    </div>
</div>


<div class="print-button-wrapper no-print">
    <button id="printCert">📄 Скачать PDF</button>
</div>

<div class="certificate-container">
    <div class="decorative-dots"></div>
    <div class="left-panel">
        <div class="geometric-pattern">
            <div class="shape shape-1"></div>
            <div class="shape shape-2"></div>
            <div class="shape shape-3"></div>
            <div class="shape shape-4"></div>
            <div class="shape shape-5"></div>
            <div class="shape shape-6"></div>
            <div class="shape shape-7"></div>
            <div class="shape shape-8"></div>
            <div class="shape shape-1"></div>
            <div class="shape shape-6"></div>
            <div class="shape shape-2"></div>
            <div class="shape shape-7"></div>
            <div class="shape shape-4"></div>
            <div class="shape shape-5"></div>
            <div class="shape shape-3"></div>
            <div class="shape shape-8"></div>
            <div class="shape shape-2"></div>
            <div class="shape shape-1"></div>
            <div class="shape shape-6"></div>
            <div class="shape shape-4"></div>
            <div class="shape shape-7"></div>
            <div class="shape shape-5"></div>
            <div class="shape shape-3"></div>
            <div class="shape shape-8"></div>
            <div class="shape shape-1"></div>
            <div class="shape shape-6"></div>
            <div class="shape shape-2"></div>
            <div class="shape shape-7"></div>
            <div class="shape shape-4"></div>
            <div class="shape shape-5"></div>
            <div class="shape shape-3"></div>
            <div class="shape shape-8"></div>
            <div class="shape shape-2"></div>
        </div>
    </div>

    <div class="right-panel">
        <div class="header">
            <div class="company-info">
                <h2 class="company-name">Manas Training Center</h2>
                <p class="company-legal">ООО «Манас Тренинг Центр»</p>
                <p class="company-location">г. Бишкек, Кыргызская Республика</p>
                <p class="company-type">Центр профессионального обучения</p>
            </div>

            <div class="logo-container">
                <img src="/static/images/manasRussianLogo.jpg" alt="Manas Logo" />
            </div>
        </div>

        <div class="certificate-title">Сертификат</div>
        <div class="certificate-subtitle">об окончании</div>

        <div class="presentation-text">Настоящим свидетельствуется о том что,</div>

        <div class="recipient-name">${certificate.student.name} ${certificate.student.lastName}</div>

        <div class="description-text">
            За успешное прохождение курса профессиональной переподготовки и освоение теоретических знаний и практических навыков. Слушатель продемонстрировал высокий уровень компетенции и успешно прошел итоговую аттестацию.
        </div>

        <div class="course-title">${certificate.courseInstance.course.title}</div>

        <div class="company-mention">в ООО «Манас Тренинг Центр»</div>

        <div class="details-grid">
            <div class="detail-item">
                <span class="label">Дата выдачи</span>
                <span class="value" id="issueDate">${certificate.issueDate}</span>
            </div>
            <div class="detail-item">
                <span class="label">Действителен до</span>
                <span class="value" id="expiryDate">${certificate.expiryDate}</span>
            </div>
            <div class="detail-item">
                <span class="label">Регистрационный номер</span>
                <span class="value">${certificate.certificateNumber}</span>
            </div>
            <div class="detail-item">
                <span class="label">Итоговая оценка</span>
                <span class="value">${certificate.mark}</span>
            </div>
        </div>

        <div class="footer">
            <div class="signature-section">
                <div class="label">Генеральный директор</div>
                <div class="signature-line"></div>
                <div class="signature-name director-name">Айылчиев Э.Р.</div>
            </div>

            <div class="signature-section">
                <div class="label">Подпись</div>
                <div class="signature-line"></div>
                <div class="signature-name sgName">Студент</div>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    function formatDate(dateString) {
        if (!dateString) return '';
        const s = dateString.trim();
        if (/^\d{2}\.\d{2}\.\d{4}$/.test(s)) return s;
        let m = s.match(/^(\d{2})-(\d{2})-(\d{4})/);
        if (m) return [m[1], m[2], m[3]].join('.');
        m = s.match(/^(\d{4})-(\d{2})-(\d{2})/);
        if (m) return [m[3], m[2], m[1]].join('.');
        return s;
    }

    function transliterateToLatin(text) {
        const translitMap = {
            'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo', 'ж': 'zh',
            'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o',
            'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'ts',
            'ч': 'ch', 'ш': 'sh', 'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya',
            'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Е': 'E', 'Ё': 'Yo', 'Ж': 'Zh',
            'З': 'Z', 'И': 'I', 'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M', 'Н': 'N', 'О': 'O',
            'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'У': 'U', 'Ф': 'F', 'Х': 'Kh', 'Ц': 'Ts',
            'Ч': 'Ch', 'Ш': 'Sh', 'Щ': 'Shch', 'Ъ': '', 'Ы': 'Y', 'Ь': '', 'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya',

            'ң': 'ng', 'ө': 'ö', 'ү': 'ü',
            'Ң': 'Ng', 'Ө': 'Ö', 'Ү': 'Ü'
        };

        return text.replace(/[а-яё\u04a3\u04e9\u04afА-ЯЁ\u04a2\u04e8\u04ae]/g, match => translitMap[match] || match);
    }

    function transliterateToCyrillic(text) {
        const translitMap = {
            'a': 'а', 'b': 'б', 'v': 'в', 'g': 'г', 'd': 'д', 'e': 'е', 'yo': 'ё', 'zh': 'ж',
            'z': 'з', 'i': 'и', 'y': 'й', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н', 'o': 'о',
            'p': 'п', 'r': 'р', 's': 'с', 't': 'т', 'u': 'у', 'f': 'ф', 'kh': 'х', 'ts': 'ц',
            'ch': 'ч', 'sh': 'ш', 'shch': 'щ', 'yu': 'ю', 'ya': 'я',
            'A': 'А', 'B': 'Б', 'V': 'В', 'G': 'Г', 'D': 'Д', 'E': 'Е', 'Yo': 'Ё', 'Zh': 'Ж',
            'Z': 'З', 'I': 'И', 'Y': 'Й', 'K': 'К', 'L': 'Л', 'M': 'М', 'N': 'Н', 'O': 'О',
            'P': 'П', 'R': 'Р', 'S': 'С', 'T': 'Т', 'U': 'У', 'F': 'Ф', 'Kh': 'Х', 'Ts': 'Ц',
            'Ch': 'Ч', 'Sh': 'Ш', 'Shch': 'Щ', 'Yu': 'Ю', 'Ya': 'Я',
            'ng': 'ң', 'Ng': 'Ң'
        };

        let result = text;
        const sortedKeys = Object.keys(translitMap).sort((a, b) => b.length - a.length);

        for (const key of sortedKeys) {
            const regex = new RegExp(key.replace(/[.*+?^$()|[\]\\]/g, '\\$&'), 'g');
            result = result.replace(regex, translitMap[key]);
        }

        return result;
    }

    function isCyrillic(text) {
        return /[а-яё\u04a3\u04e9\u04afА-ЯЁ\u04a2\u04e8\u04ae]/.test(text);
    }

    function transformName(originalName, targetLanguage) {
        if (!originalName) return '';

        const isCyrillicName = isCyrillic(originalName);

        switch (targetLanguage) {
            case 'en':
                return isCyrillicName ? transliterateToLatin(originalName) : originalName;

            case 'ru':
            case 'kg':
                return !isCyrillicName ? transliterateToCyrillic(originalName) : originalName;

            default:
                return originalName;
        }
    }

    function showLoadingIndicator(show) {
        let indicator = document.getElementById('pdfLoadingIndicator');

        if (!indicator) {
            indicator = document.createElement('div');
            indicator.id = 'pdfLoadingIndicator';
            indicator.innerHTML = `
            <div style="
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.7);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
                backdrop-filter: blur(4px);
            ">
                <div style="
                    background: white;
                    padding: 30px 40px;
                    border-radius: 12px;
                    text-align: center;
                    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                ">
                    <div style="
                        width: 40px;
                        height: 40px;
                        border: 4px solid #e2e8f0;
                        border-top: 4px solid #1d4ed8;
                        border-radius: 50%;
                        animation: spin 1s linear infinite;
                        margin: 0 auto 20px;
                    "></div>
                    <p style="
                        font-family: 'Inter', sans-serif;
                        font-size: 16px;
                        font-weight: 600;
                        color: #1e293b;
                        margin: 0;
                    ">Создается PDF...</p>
                    <p style="
                        font-family: 'Inter', sans-serif;
                        font-size: 12px;
                        color: #64748b;
                        margin: 5px 0 0 0;
                    ">Пожалуйста, подождите</p>
                </div>
            </div>
            <style>
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            </style>
        `;
            document.body.appendChild(indicator);
        }

        indicator.style.display = show ? 'block' : 'none';
    }

    async function generatePDF(language = 'ru') {
        if (typeof html2pdf === 'undefined') {
            alert('Ошибка: Библиотека html2pdf не загружена. Проверьте подключение скрипта.');
            return;
        }

        showLoadingIndicator(true);

        const element = document.querySelector('.certificate-container');
        element.classList.add('pdf-ready');
        await preloadFonts();

        const studentNameElement = document.querySelector('.recipient-name');
        const courseTitleElement = document.querySelector('.course-title');
        const certificateNumberElement = document.querySelectorAll('.detail-item .value')[2];

        const studentName = studentNameElement ? studentNameElement.textContent.trim() : 'Certificate';
        const courseTitle = courseTitleElement ? courseTitleElement.textContent.trim() : '';
        const certificateNumber = certificateNumberElement ? certificateNumberElement.textContent.trim() : '';

        const fileName = `certificate.pdf`;

        const opt = {
            margin: [0, 0, 0, 0],
            filename: fileName,
            image: {
                type: 'jpeg',
                quality: 0.95
            },
            html2canvas: {
                scale: 2,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff',
                letterRendering: true,
                logging: false
            },
            jsPDF: {
                unit: 'mm',
                format: [235, 267],
                orientation: 'landscape'
            },
            pagebreak: { mode: ['avoid'] }
        };

        element.style.width = '267mm';
        element.style.height = '180mm';
        element.style.overflow = 'hidden';
        element.style.pageBreakInside = 'avoid';
        element.style.breakInside = 'avoid';
        ensureFontsReady().then(() => {
            html2pdf()
                .set(opt)
                .from(element)
                .save()
                .then(() => {
                    showLoadingIndicator(false);
                    console.log('PDF generated successfully:', fileName);
                })
                .catch(error => {
                    showLoadingIndicator(false);
                    console.error('Error generating PDF:', error);
                    alert('Ошибка при создании PDF. Попробуйте еще раз.');
                });
        });
    }

    async function preloadFonts() {
        await document.fonts.load('800 52px Inter');
        await document.fonts.load('600 32px "Playfair Display"');
        await document.fonts.ready;
    }

    async function setLanguage(lang) {
        const dict = {
            ru: {
                certificate: "Сертификат",
                subtitle: "об окончании",
                presentation: "Настоящим свидетельствуется о том что,",
                description: "За успешное прохождение курса профессиональной переподготовки и освоение теоретических знаний и практических навыков. Слушатель продемонстрировал высокий уровень компетенции и успешно прошел итоговую аттестацию.",
                org: "в ООО «Манас Тренинг Центр»",
                issued: "Дата выдачи",
                valid: "Действителен до",
                number: "Регистрационный номер",
                grade: "Итоговая оценка",
                director: "Генеральный директор",
                signature: "Подпись",
                logo: "/static/images/manasRussianLogo.jpg",
                companyName: "Manas Training Center",
                companyLegal: "ООО «Манас Тренинг Центр»",
                companyLocation: "г. Бишкек, Кыргызская Республика",
                directorName: "Айылчиев Э.Р.",
                companyType: "Центр профессионального обучения",
                sgName: "Студент"
            },
            en: {
                certificate: "Certificate",
                subtitle: "of Completion",
                presentation: "This certificate confirms that",
                description: "has successfully completed the professional training course and acquired theoretical knowledge and practical skills. The learner demonstrated a high level of competence and successfully passed the final assessment.",
                org: "at Manas Training Center LLC",
                issued: "Issue Date",
                valid: "Valid Until",
                number: "Certificate Number",
                grade: "Final Grade",
                director: "General Director",
                signature: "Signature",
                logo: "/static/images/manasEnglishLogo.jpg",
                companyName: "Manas Training Center",
                companyLegal: "Manas Training Center LLC",
                companyLocation: "Bishkek, Kyrgyz Republic",
                directorName: "E.R. Aiylchiev",
                companyType: "Professional Training Center",
                sgName: "Student"
            },
            kg: {
                certificate: "СЕРТИФИКАТ",
                subtitle: "аяктагандыгы жөнүндө",
                presentation: "Бул сертификат тастыктайт",
                description: "кесиптик даярдоо курсун ийгиликтүү аяктап, теориялык билимдерди жана практикалык көндүмдөрдү өздөштүргөн. Окуучу жогорку деңгээлдеги компетенттүүлүгүн көрсөтүп, акыркы аттестациядан ийгиликтүү өткөн.",
                org: "«Манас Тренинг Центри» ЖЧКсында",
                issued: "Берилген күнү",
                valid: "Мөөнөтү",
                number: "Каттоо номери",
                grade: "Жыйынтык баа",
                director: "Башкы директор",
                signature: "Кол тамга",
                directorName: "Айылчиев Э.Р.",
                logo: "/static/images/manasKyrgyzLogo.jpg",
                companyName: "Манас Тренинг Центри",
                companyLegal: "«Манас Тренинг Центри» ЖЧК",
                companyLocation: "Бишкек ш., Кыргыз Республикасы",
                companyType: "Кесиптик окутуу борбору"
            }
        };

        const t = dict[lang];

        const certificateTitle = document.querySelector('.certificate-title');
        const certificateSubtitle = document.querySelector('.certificate-subtitle');
        const presentationText = document.querySelector('.presentation-text');
        const descriptionText = document.querySelector('.description-text');
        const companyMention = document.querySelector('.company-mention');
        const companyName = document.querySelector('.company-name');
        const companyLegal = document.querySelector('.company-legal');
        const companyLocation = document.querySelector('.company-location');
        const companyType = document.querySelector('.company-type');
        const sgName = document.querySelector('.sgName');

        if (certificateTitle) certificateTitle.textContent = t.certificate;
        if (certificateSubtitle) certificateSubtitle.textContent = t.subtitle;
        if (presentationText) presentationText.textContent = t.presentation;
        if (descriptionText) descriptionText.textContent = t.description;
        if (companyMention) companyMention.textContent = t.org;
        if (companyName) companyName.textContent = t.companyName;
        if (companyLegal) companyLegal.textContent = t.companyLegal;
        if (companyLocation) companyLocation.textContent = t.companyLocation;
        if (companyType) companyType.textContent = t.companyType;
        if (sgName) sgName.textContent = t.sgName;

        const labels = document.querySelectorAll('.detail-item .label');
        if (labels.length >= 4) {
            labels[0].textContent = t.issued;
            labels[1].textContent = t.valid;
            labels[2].textContent = t.number;
            labels[3].textContent = t.grade;
        }

        const sigs = document.querySelectorAll('.signature-section .label');
        if (sigs.length >= 2) {
            sigs[0].textContent = t.director;
            sigs[1].textContent = t.signature;
        }

        const logoImg = document.querySelector('.logo-container img');
        const directorName = document.querySelector('.director-name');

        if (logoImg) logoImg.src = t.logo;
        if (directorName) directorName.textContent = t.directorName;

        const nameElement = document.querySelector('.recipient-name');
        if (nameElement) {
            if (!nameElement.dataset.originalName) {
                nameElement.dataset.originalName = nameElement.textContent.trim();
            }

            const originalName = nameElement.dataset.originalName;
            const transformedName = transformName(originalName, lang);
            nameElement.textContent = transformedName;
        }

        if (languageModal) {
            languageModal.style.display = 'none';
        }
        setTimeout(() => generatePDF(lang), 500);
    }

    async function ensureFontsReady() {
        if (document.fonts && document.fonts.ready) {
            await document.fonts.ready;
        }
        return new Promise(resolve => setTimeout(resolve, 100));
    }

    document.addEventListener('DOMContentLoaded', function() {
        const issueDateElement = document.getElementById('issueDate');
        const expiryDateElement = document.getElementById('expiryDate');

        if (issueDateElement) {
            issueDateElement.textContent = formatDate(issueDateElement.textContent);
        }

        if (expiryDateElement) {
            expiryDateElement.textContent = formatDate(expiryDateElement.textContent);
        }

        const nameElement = document.querySelector('.recipient-name');
        if (nameElement && nameElement.textContent.trim()) {
            nameElement.dataset.originalName = nameElement.textContent.trim();
        }
    });
    document.addEventListener('DOMContentLoaded', function() {
        const printButton = document.getElementById('printCert');
        if (printButton) {
            printButton.addEventListener('click', () => {
                const languageModal = document.getElementById('languageModal');
                if (languageModal) {
                    languageModal.style.display = 'flex';
                }
            });
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        if (typeof html2pdf === 'undefined') {
            console.error('html2pdf не загружен!');
            alert('Ошибка: Библиотека html2pdf не загрузилась. Проверьте интернет соединение.');
        } else {
            console.log('html2pdf успешно загружен');
        }
    });
</script>
</@layout.page>