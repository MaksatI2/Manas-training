<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page title="Сертификаты">

    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Roboto:wght@400;500;700&display=swap');

            * { margin:0; padding:0; box-sizing:border-box; }
            body { font-family: 'Roboto', sans-serif; background: #e2e8f0; }

            .cert-scroll-wrapper {
                width: 100%;
                overflow-x: auto;
                /*padding: 20px;*/
                display: flex;
                justify-content: center;
            }

            .certificate-container {
                width: 1050px;
                height: 742px;
                min-width: 1050px;
                min-height: 742px;
                background: #ffffff;
                position: relative;
                box-shadow: 0 15px 40px rgba(0,0,0,0.2);
                display: flex;
                overflow: hidden;
                flex-shrink: 0;
            }

            .gold-border {
                position: absolute;
                top: 20px;
                left: 20px;
                right: 20px;
                bottom: 20px;
                border: 3px solid #dcb065;
                z-index: 10;
                pointer-events: none;
            }

            .left-panel {
                width: 400px;
                height: 100%;
                background-color: #074c85;
                position: relative;
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding-left: 50px;
                z-index: 1;
            }

            .left-pattern {
                position: absolute;
                top: 0; left: 0; right: 0; bottom: 0;
                background-image:
                        radial-gradient(ellipse at -20% 80%, rgba(255,255,255,0.1) 0%, transparent 60%),
                        radial-gradient(ellipse at -10% 20%, rgba(255,255,255,0.08) 0%, transparent 50%);
                z-index: 1;
            }
            .left-pattern::after {
                content: "";
                position: absolute;
                top: 50%; left: -50px; width: 400px; height: 400px;
                background: radial-gradient(circle, rgba(255,255,255,0.05) 0%, transparent 70%);
                border-radius: 50%;
                box-shadow: 100px -100px 0 0 rgba(255,255,255,0.03);
            }

            .logo-container {
                position: absolute;
                top: 50px;
                left: 30px;
                width: 400px;
                height: 75px;
                z-index: 5;
                display: flex;
                align-items: center;
            }
            .logo-container img {
                max-width: 90%;
                max-height: 100%;
                object-fit: contain;
            }

            .cert-titles {
                position: relative;
                z-index: 5;
            }
            .cert-title-ru {
                font-family: 'Playfair Display', serif;
                font-size: 40px;
                color: #ffffff;
                font-weight: 700;
                letter-spacing: 2px;
                margin-bottom: 5px;
            }
            .cert-title-en {
                font-family: 'Playfair Display', serif;
                font-size: 38px;
                color: #ffffff;
                font-weight: 600;
                letter-spacing: 1.5px;
            }

            .right-panel {
                flex-grow: 1;
                padding: 40px 50px 30px 40px;
                position: relative;
                display: flex;
                flex-direction: column;
                z-index: 1;
                background-color: #fff;
            }

            .right-pattern {
                position: absolute;
                top: 0; right: 0; bottom: 0; width: 300px;
                background: radial-gradient(circle at 100% 50%, rgba(220, 176, 101, 0.15) 0%, transparent 70%);
                z-index: -1;
                pointer-events: none;
            }

            .form-row {
                display: flex;
                align-items: flex-end;
                margin-bottom: 18px;
                width: 100%;
            }
            .form-row.header-row {
                justify-content: space-between;
                margin-bottom: 35px;
                margin-top: 10px;
            }

            .bilingual-label {
                font-size: 14px;
                font-weight: 700;
                color: #000;
                line-height: 1.2;
                white-space: nowrap;
            }
            .bilingual-label span.eng {
                display: block;
                font-size: 14px;
            }

            .input-wrapper {
                flex-grow: 1;
                margin-left: 10px;
                display: flex;
                flex-direction: column;
                position: relative;
            }
            .input-line {
                border-bottom: 1px solid #000;
                text-align: center;
                font-size: 16px;
                font-weight: 700;
                color: #000;
                padding-bottom: 2px;
                min-height: 22px;
            }
            .input-subtext {
                font-size: 9px;
                color: #333;
                text-align: center;
                margin-top: 2px;
            }

            .footer-row {
                display: flex;
                justify-content: space-between;
                margin-top: 25px;
            }

            .small-print {
                font-size: 7.5px;
                line-height: 1.3;
                color: #000000;
                margin-top: 25px;
                font-weight: 700;
            }
            .print-button-wrapper {
                width: 1050px;
                margin: 20px auto 10px;
                display: flex;
                justify-content: flex-end;
            }
            .print-button-wrapper button {
                padding: 10px 20px;
                font-size: 15px;
                font-weight: 600;
                background: #074c85;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background 0.3s;
            }
            .print-button-wrapper button:hover { background: #053b69; }



            @media print {
                body { background: #fff !important; }
                .cert-scroll-wrapper { padding: 0; }
                .no-print { display: none !important; }
                .certificate-container { box-shadow: none !important; border-radius: 0 !important; }
            }
        </style>
    </head>

    <body>

    <#--    <div id="languageModal" class="no-print" style="display: none !important; position: fixed; inset: 0; background: rgba(0, 0, 0, 0.5); z-index: 9999; justify-content: center; align-items: center; backdrop-filter: blur(4px);">-->
    <#--        <div style="background: white; padding: 36px 48px; border-radius: 16px; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2); text-align: center; width: 320px;">-->
    <#--            <h2 style="margin-bottom: 24px; font-size: 20px; font-weight: 700;">Выберите язык</h2>-->
    <#--            <div style="display: flex; flex-direction: column; gap: 14px;">-->
    <#--                <button onclick="setLanguage('ru')" style="padding: 12px; font-size: 15px; font-weight: 600; background: #074c85; color: white; border: none; border-radius: 8px; cursor: pointer;">Русский</button>-->
    <#--                <button onclick="setLanguage('en')" style="padding: 12px; font-size: 15px; font-weight: 600; background: #10b981; color: white; border: none; border-radius: 8px; cursor: pointer;">English</button>-->
    <#--                <button onclick="setLanguage('kg')" style="padding: 12px; font-size: 15px; font-weight: 600; background: #f59e0b; color: white; border: none; border-radius: 8px; cursor: pointer;">Кыргызча</button>-->
    <#--            </div>-->
    <#--        </div>-->
    <#--    </div>-->

    <div class="print-button-wrapper no-print">
        <button id="printCert">📄 Скачать PDF</button>
    </div>

    <div class="cert-scroll-wrapper">
        <div class="certificate-container" id="certContainer">
            <div class="gold-border"></div>

            <div class="left-panel">
                <div class="left-pattern"></div>

                <div class="logo-container">
                    <img src="/static/images/manasEnglishLogo.png" alt="Manas Logo" />
                </div>

                <div class="cert-titles">
                    <div class="cert-title-ru certificate-title">СЕРТИФИКАТ</div>
                    <div class="cert-title-en certificate-subtitle">CERTIFICATE</div>
                </div>
            </div>

            <div class="right-panel">
                <div class="right-pattern"></div>

                <div class="form-row header-row">
                    <div style="display: flex; align-items: center;">
                        <div class="bilingual-label" style="margin-right: 5px;">
                            г. Бишкек<br>Bishkek city
                        </div>
                        <div class="bilingual-label" id="currentYear" style="align-self: center; line-height: 1;">
                        </div>
                    </div>
                    <div style="display: flex; align-items: flex-end;">
                        <div class="bilingual-label">
                            Регистрационный<br><span class="eng" style="text-align: right;">Registration</span>
                        </div>
                        <div style="margin-left: 5px; font-size: 14px; font-weight: 700;">№</div>
                        <div class="input-line certificateNumber" style="width: 100px; margin-left: 2px;">
                            ${certificate.certificateNumber!""}
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="bilingual-label presentation-text">
                        Настоящим подтверждается, что<br><span class="eng">This is to certify that</span>
                    </div>
                    <div class="input-wrapper">
                        <div class="input-line recipient-name">${certificate.student.name} ${certificate.student.lastName}</div>
                        <div class="input-subtext">(ФИО/full name)</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="bilingual-label">
                        прошёл(а) обучение<br><span class="eng">has successfully completed the training on</span>
                    </div>
                    <div class="bilingual-label" style="margin-left: 20px; margin-right: 5px;">
                        «__»<br><span class="eng">&nbsp;</span>
                    </div>
                    <div class="input-wrapper">
                        <div class="input-line"></div>
                        <div class="input-subtext">&nbsp;</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="bilingual-label">
                        в<br><span class="eng">at</span>
                    </div>
                    <div class="input-wrapper">
                        <div class="input-line company-mention">ООО «Манас Тренинг Центр»</div>
                        <div class="input-subtext">(название образовательного учреждения / name of educational institution)</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="bilingual-label">
                        по программе<br><span class="eng">under the program</span>
                    </div>
                    <div class="input-wrapper">
                        <div class="input-line course-title">${certificate.courseInstance.course.title}</div>
                        <div class="input-subtext">(название темы, профессиональной образовательной программы / title of theme, vocational education program)</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="bilingual-label">
                        В объёме<br><span class="eng">In total of</span>
                    </div>
                    <div class="input-wrapper" style="max-width: 100px;">
                        <div class="input-line">${certificate.courseInstance.course.durationHours!"__"}</div>
                        <div class="input-subtext">(quantity of hours)</div>
                    </div>
                    <div class="bilingual-label" style="margin-left: 10px;">
                        часов, с итоговой экзаменационной оценкой<br><span class="eng">hours, with the final examination mark</span>
                    </div>
                    <div class="input-wrapper">
                        <div class="input-line mark-value">${certificate.mark!"__"}</div>
                        <div class="input-subtext">&nbsp;</div>
                    </div>
                </div>

                <div class="form-row" style="margin-top: 15px;">
                    <div style="display: flex; width: 50%; align-items: flex-end; padding-right: 20px;">
                        <div class="bilingual-label">
                            Дата выдачи:<br><span class="eng">Date of issue:</span>
                        </div>
                        <div class="input-wrapper">
                            <div class="input-line" id="issueDate">${certificate.issueDate}</div>
                        </div>
                    </div>
                    <div style="display: flex; width: 50%; align-items: flex-end;">
                        <div class="bilingual-label">
                            Действителен до:<br><span class="eng">Valid until:</span>
                        </div>
                        <div class="input-wrapper">
                            <div class="input-line" id="expiryDate">${certificate.expiryDate!"Бессрочно"}</div>
                        </div>
                    </div>
                </div>

                <div class="footer-row">
                    <div style="display: flex; align-items: flex-end; width: 45%;">
                        <div class="bilingual-label" style="color: #074c85;">
                            Генеральный директор<br><span class="eng">General Director</span>
                        </div>
                        <div class="input-wrapper">
                            <div class="input-line"></div>
                        </div>
                    </div>
                    <div style="width: 45%; text-align: right;">
                        <div class="bilingual-label director-name" style="font-size: 15px; color: #074c85;">
                            Айылчиев Эрмек Райымадамович<br><span class="eng" style="font-size: 14px;">Aiylchiev Ermek Rayymadamovich</span>
                        </div>
                    </div>
                </div>

                <div class="small-print">
                    Сертификат соответствия учебного центра «Манас Тренинг Центр» №073 от 02 февраля 2024 года, выдан Государственным агентством гражданской<br>
                    авиации при Кабинете Министров Кыргызской Республики.<br>
                    Лицензия Министерства образования и науки Кыргызской Республики № LME70001204, регистрационный номер 170368, от 2017 года.<br><br>
                    Certificate of Conformity of the training center "Manas Training Center" No.073 dated February 2, 2024, issued by the Civil Aviation Agency<br>
                    under the Cabinet of Ministers of the Kyrgyz Republic.<br>
                    License of the Ministry of Education and Science of the Kyrgyz Republic No. LME70001204, registration number 170368, dated 2017.
                </div>

            </div>
        </div>
    </div>

    <script>
        function formatDate(dateString) {
            const yearElement = document.getElementById('currentYear');
            if (yearElement) {
                yearElement.textContent = new Date().getFullYear();
            }

            const issueDateElement = document.getElementById('issueDate');
            const expiryDateElement = document.getElementById('expiryDate');
            if (issueDateElement) issueDateElement.textContent = formatDate(issueDateElement.textContent);
            if (expiryDateElement) expiryDateElement.textContent = formatDate(expiryDateElement.textContent);
        }

        function formatDateString(dateString) {
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
            const translitMap = { 'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo', 'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya', 'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Е': 'E', 'Ё': 'Yo', 'Ж': 'Zh', 'З': 'Z', 'И': 'I', 'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M', 'Н': 'N', 'О': 'O', 'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'У': 'U', 'Ф': 'F', 'Х': 'Kh', 'Ц': 'Ts', 'Ч': 'Ch', 'Ш': 'Sh', 'Щ': 'Shch', 'Ъ': '', 'Ы': 'Y', 'Ь': '', 'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya', 'ң': 'ng', 'ө': 'ö', 'ү': 'ü', 'Ң': 'Ng', 'Ө': 'Ö', 'Ү': 'Ü' };
            return text.replace(/[а-яё\u04a3\u04e9\u04afА-ЯЁ\u04a2\u04e8\u04ae]/g, match => translitMap[match] || match);
        }

        function isCyrillic(text) { return /[а-яё\u04a3\u04e9\u04afА-ЯЁ\u04a2\u04e8\u04ae]/.test(text); }

        function transformName(originalName, targetLanguage) {
            if (!originalName) return '';
            const isCyrillicName = isCyrillic(originalName);
            if (targetLanguage === 'en') return isCyrillicName ? transliterateToLatin(originalName) : originalName;
            return originalName;
        }

        function showLoadingIndicator(show) {
            let indicator = document.getElementById('pdfLoadingIndicator');
            if (!indicator) {
                indicator = document.createElement('div');
                indicator.id = 'pdfLoadingIndicator';
                indicator.innerHTML = `
            <div style="position: fixed; inset: 0; background: rgba(0,0,0,0.7); display: flex; justify-content: center; align-items: center; z-index: 9999; backdrop-filter: blur(4px);">
                <div style="background: white; padding: 30px 40px; border-radius: 12px; text-align: center;">
                    <div style="width: 40px; height: 40px; border: 4px solid #e2e8f0; border-top: 4px solid #074c85; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                    <p style="font-weight: 600; margin: 0;">Создается PDF...</p>
                </div>
            </div>
            <style>@keyframes spin { 100% { transform: rotate(360deg); } }</style>`;
                document.body.appendChild(indicator);
            }
            indicator.style.display = show ? 'block' : 'none';
        }

        async function generatePDF(language = 'ru') {
            if (typeof html2pdf === 'undefined') {
                alert('Ошибка: html2pdf не загружена.');
                return;
            }

            showLoadingIndicator(true);
            const element = document.getElementById('certContainer');
            const fileName = `certificate.pdf`;

            const opt = {
                margin: 0,
                filename: fileName,
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: {
                    scale: 2,
                    useCORS: true,
                    allowTaint: true,
                    letterRendering: true
                },
                jsPDF: {
                    unit: 'mm',
                    format: 'a4',
                    orientation: 'landscape'
                }
            };

            html2pdf().set(opt).from(element).save().then(() => {
                showLoadingIndicator(false);
            }).catch(error => {
                showLoadingIndicator(false);
                console.error('Error generating PDF:', error);
                alert('Ошибка при создании PDF.');
            });
        }

        async function setLanguage(lang) {
            const dict = {
                ru: {
                    title: "СЕРТИФИКАТ",
                    subtitle: "CERTIFICATE",
                    logo: "/static/images/manasEnglishLogo.png"
                },
                en: {
                    title: "CERTIFICATE",
                    subtitle: "СЕРТИФИКАТ",
                    logo: "/static/images/manasEnglishLogo.png"
                },
                kg: {
                    title: "СЕРТИФИКАТ",
                    subtitle: "CERTIFICATE",
                    logo: "/static/images/manasEnglishLogo.png"
                }
            };

            const t = dict[lang];

            document.querySelector('.certificate-title').textContent = t.title;
            document.querySelector('.certificate-subtitle').textContent = t.subtitle;
            document.querySelector('.logo-container img').src = t.logo;

            const nameElement = document.querySelector('.recipient-name');
            if (nameElement) {
                if (!nameElement.dataset.originalName) nameElement.dataset.originalName = nameElement.textContent.trim();
                nameElement.textContent = transformName(nameElement.dataset.originalName, lang);
            }

            document.getElementById('languageModal').style.display = 'none';
            setTimeout(() => generatePDF(lang), 500);
        }

        document.addEventListener('DOMContentLoaded', function() {
            const yearElement = document.getElementById('currentYear');
            if (yearElement) {
                yearElement.textContent = new Date().getFullYear();
            }

            const issueDateElement = document.getElementById('issueDate');
            const expiryDateElement = document.getElementById('expiryDate');
            if (issueDateElement) {
                issueDateElement.textContent = formatDateString(issueDateElement.textContent);
            }
            if (expiryDateElement) {
                expiryDateElement.textContent = formatDateString(expiryDateElement.textContent);
            }

            const printButton = document.getElementById('printCert');
            if (printButton) {
                printButton.addEventListener('click', () => {
                    generatePDF('ru');
                });
            }
        });
    </script>
    </body>
    </html>
</@layout.page>