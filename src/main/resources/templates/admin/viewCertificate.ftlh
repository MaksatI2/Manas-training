<#import "../layout.ftlh" as layout>
<@layout.page title="Сертификат">

    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <!-- PDF from HTML -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

        <style>
            /* ====== PAGE PRINT SETTINGS ====== */
            @page { size: A4 landscape; margin: 0; }
            @media print {
                body { margin: 0; }
                .no-print { display: none !important; }
                .preview-wrap { padding: 0 !important; }
                .cert-sheet { box-shadow: none !important; margin: 0 !important; }
            }

            /* ====== PREVIEW WRAPPER ====== */
            body {
                margin: 0;
                background: #f3f4f6;
                font-family: Arial, sans-serif;
            }
            .preview-wrap {
                padding: 24px;
                display: flex;
                justify-content: center;
            }
            .toolbar {
                position: sticky;
                top: 0;
                z-index: 50;
                display: flex;
                gap: 10px;
                justify-content: center;
                padding: 12px;
                background: rgba(255,255,255,.9);
                backdrop-filter: blur(6px);
                border-bottom: 1px solid #e5e7eb;
            }
            .btn {
                border: 0;
                cursor: pointer;
                padding: 10px 14px;
                border-radius: 10px;
                font-weight: 700;
                background: #074c85;
                color: #fff;
            }
            .btn.secondary { background: #111827; }
            .btn.light { background: #10b981; }
            .hint {
                text-align: center;
                font-size: 13px;
                color: #6b7280;
                margin: 0 0 12px;
            }

            /* ====== CERTIFICATE SHEET ======
               A4 landscape = 297mm x 210mm
               РАЗМЕРЫ НЕ ТРОГАЙ, если хочешь точную печать.
            */
            .cert-sheet {
                position: relative;
                width: 297mm;
                height: 210mm;
                background: #fff;
                overflow: hidden;
                box-shadow: 0 16px 40px rgba(0,0,0,.18);
            }

            /* Подложка (оригинальный дизайн) */
            .cert-bg {
                position: absolute;
                inset: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
                user-select: none;
                pointer-events: none;
                z-index: 0;
            }

            /* ====== FIELDS ====== */
            .field {
                position: absolute;
                color: #111;
                font-family: "Times New Roman", serif;  /* поменяешь, если надо */
                font-size: 14pt;
                line-height: 1.12;
                letter-spacing: 0.1px;
                white-space: nowrap;
                z-index: 2;
            }
            .field.multiline { white-space: normal; }

            /* Тонкая “отладочная” рамка — включи если нужно */
            .debug .field { outline: 1px dashed rgba(255,0,0,.35); }

            /* ====== STAMP / SIGNATURE ====== */
            .stamp, .sign {
                position: absolute;
                user-select: none;
                pointer-events: none;
                z-index: 2;
            }
            .stamp {
                opacity: .92;
                transform: rotate(-8deg);
                filter: saturate(1.05);
            }
            .sign {
                opacity: .95;
            }

            /* ====== POSITIONS (двигаешь тут) ======
               Ниже примерные значения — ты их подгонишь под свою подложку.
               Единицы: mm (миллиметры)
            */

            /* год 20__ */
            .f-year {
                left: 146mm;
                top: 16mm;
                font-size: 11.5pt;
                font-weight: 600;
            }

            /* регистрационный номер */
            .f-regno   { left: 265mm; top: 15mm; font-weight: 700; font-size: 13pt; width: 38mm; text-align: left; }

            /* ФИО */
            .f-fullname{ left: 195mm; top: 31mm; width: 155mm; font-size: 16pt; font-weight: 700; }
            .f-fullname.multiline { }

            .f-company {
                left: 175mm;
                top: 59mm;
                width: 160mm;
                font-size: 15pt;
                font-weight: 700;
            }


            /* дата обучения (если надо) */
            .f-dateTraining { left: 150mm; top: 74mm; width: 70mm; font-size: 13pt; text-align: center; }

            /* программа / курс */
            .f-course  { left: 170mm; top: 75mm; width: 170mm; font-size: 15pt; }
            .f-course.multiline { }

            /* часы */
            .f-hours   { left: 136mm; top: 122.5mm; width: 24mm; font-size: 14pt; text-align: center; }

            /* оценка */
            .f-mark    { left: 252mm; top: 123mm; width: 32mm; font-size: 14pt; text-align: center; font-weight: 700; }

            /* дата выдачи */
            .f-issue   { left: 155mm; top: 137mm; width: 45mm; font-size: 13pt; }

            /* действителен до */
            .f-expiry  { left: 245mm; top: 137mm; width: 45mm; font-size: 13pt; }

            /* печать */
            .stamp {
                left: 170mm;
                top: 140mm;
                width: 46mm;
            }

            /* подпись */
            .sign {
                left: 167mm;
                top: 147mm;
                width: 55mm;
            }

        </style>
    </head>

    <body>

<#--    <div class="toolbar no-print">-->
<#--        <button class="btn" id="btnPdf">📄 Скачать PDF</button>-->
<#--        <button class="btn secondary" id="btnPrint">🖨️ Печать</button>-->
<#--        <button class="btn light" id="btnDebug">🐞 Debug рамки</button>-->
<#--    </div>-->

    <div class="preview-wrap">
        <div id="certRoot" class="cert-sheet">

            <div class="field f-year" id="issueYear"></div>

            <!-- 1) Подложка (обязательно локально, чтобы CORS не ломал PDF) -->
            <img class="cert-bg" src="/static/images/certificate.jpeg" alt="certificate template"/>

            <!-- 2) Поля -->
            <div class="field f-regno">${certificate.certificateNumber!""}</div>

            <div class="field f-fullname multiline">
                ${certificate.student.name!""} ${certificate.student.lastName!""}
            </div>

            <div class="field f-company">
                ООО «Манас Тренинг Центр»
            </div>

            <!-- если у тебя есть дата прохождения обучения - подставь -->
<#--             <div class="field f-dateTraining">${certificate.courseInstance.startDate!""}</div>-->

            <div class="field f-course multiline">
                ${certificate.courseInstance.course.title!""}
            </div>

            <div class="field f-hours">
                ${certificate.courseInstance.course.durationHours!"__"}
            </div>

            <div class="field f-mark">
                ${certificate.mark!"__"}
            </div>

            <div class="field f-issue" id="issueDate">
                ${certificate.issueDate!""}
            </div>

            <div class="field f-expiry" id="expiryDate">
                ${certificate.expiryDate!"Бессрочно"}
            </div>

            <!-- 3) Печать / подпись (если нет — можешь удалить) -->
            <img class="stamp" src="/static/images/stamp.png" alt="stamp"/>
            <img class="sign" src="/static/images/sign.png" alt="signature"/>

        </div>
    </div>

    <script>
        const yearEl = document.getElementById('issueYear');
        const issueEl = document.getElementById('issueDate');

        if (yearEl && issueEl) {
            const raw = issueEl.textContent.trim();

            let year = '';

            let m = raw.match(/\d{2}\.\d{2}\.(\d{4})/);
            if (m) year = m[1];

            if (!year) {
                m = raw.match(/(\d{4})-\d{2}-\d{2}/);
                if (m) year = m[1];
            }

            if (!year) year = new Date().getFullYear();

            yearEl.textContent = year.slice(-2);
        }
        function formatDateString(dateString) {
            if (!dateString) return '';
            const s = String(dateString).trim();
            // already dd.mm.yyyy
            if (/^\d{2}\.\d{2}\.\d{4}$/.test(s)) return s;

            // dd-mm-yyyy
            let m = s.match(/^(\d{2})-(\d{2})-(\d{4})/);
            if (m) return [m[1], m[2], m[3]].join('.');

            // yyyy-mm-dd
            m = s.match(/^(\d{4})-(\d{2})-(\d{2})/);
            if (m) return [m[3], m[2], m[1]].join('.');

            return s;
        }

        function showLoading(show) {
            let el = document.getElementById('pdfLoading');
            if (!el) {
                el = document.createElement('div');
                el.id = 'pdfLoading';
                el.innerHTML = `
          <div style="position:fixed;inset:0;background:rgba(0,0,0,.65);display:flex;align-items:center;justify-content:center;z-index:9999">
            <div style="background:#fff;padding:26px 34px;border-radius:14px;text-align:center;min-width:240px">
              <div style="width:42px;height:42px;border:4px solid #e5e7eb;border-top:4px solid #074c85;border-radius:50%;margin:0 auto 16px;animation:spin 1s linear infinite"></div>
              <div style="font-weight:800">Генерация PDF…</div>
            </div>
          </div>
          <style>@keyframes spin{to{transform:rotate(360deg)}}</style>
        `;
                document.body.appendChild(el);
            }
            el.style.display = show ? 'block' : 'none';
        }

        async function generatePDF() {
            if (typeof html2pdf === 'undefined') {
                alert('Ошибка: html2pdf не загружена.');
                return;
            }

            const element = document.getElementById('certRoot');
            showLoading(true);

            const opt = {
                margin: 0,
                filename: 'certificate.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: {
                    scale: 3,              // качество
                    useCORS: true,
                    allowTaint: true,
                    backgroundColor: '#ffffff'
                },
                jsPDF: {
                    unit: 'mm',
                    format: 'a4',
                    orientation: 'landscape'
                }
            };

            try {
                await html2pdf().set(opt).from(element).save();
            } catch (e) {
                console.error(e);
                alert('Ошибка при создании PDF (проверь доступность картинок и CORS).');
            } finally {
                showLoading(false);
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            // format dates visually (не обязательно)
            const issue = document.getElementById('issueDate');
            const exp = document.getElementById('expiryDate');
            if (issue) issue.textContent = formatDateString(issue.textContent);
            if (exp) exp.textContent = formatDateString(exp.textContent);

            document.getElementById('btnPdf')?.addEventListener('click', generatePDF);
            document.getElementById('btnPrint')?.addEventListener('click', () => window.print());

            // debug dashed borders
            document.getElementById('btnDebug')?.addEventListener('click', () => {
                document.getElementById('certRoot')?.classList.toggle('debug');
            });
        });
    </script>

    </body>
    </html>

</@layout.page>