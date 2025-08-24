<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>ManasTraining - Видеоконференция</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="/static/css/jitsi.css" rel="stylesheet">
</head>
<body>

<div id="user-data" style="display: none;">
    <span id="user-id">${userId}</span>
    <span id="user-name">${userName}</span>
    <span id="user-role">${userRole}</span>
    <span id="meeting-id">${meeting.meetingId}</span>
    <span id="room-name">${meeting.roomName}</span>
</div>

<div id="jitsi-container" style="height: 100vh; width: 100vw;"></div>

<div id="custom-controls" style="position: fixed; bottom: 20px; right: 20px; z-index: 9999; display: none;">
    <div class="btn-group" role="group">
        <button type="button" class="btn btn-danger" onclick="leaveMeeting()">
            <i class="fas fa-phone-slash"></i> Покинуть
        </button>
        <button type="button" class="btn btn-warning" onclick="completeCall()" id="complete-btn" style="display: none;">
            <i class="fas fa-check-circle"></i> Завершить урок
        </button>
    </div>
</div>

<div class="loading-overlay" id="loading-overlay">
    <div class="loading-content">
        <div class="spinner"></div>
        <div id="loading-text">Подключение к видеоконференции...</div>
    </div>
</div>

<script src='/static/js/external_api.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    let jitsiApi = null;
    let userData = {
        id: document.getElementById('user-id')?.textContent?.trim() || null,
        name: document.getElementById('user-name')?.textContent?.trim() || 'Гость',
        role: document.getElementById('user-role')?.textContent?.trim() || 'STUDENT'
    };

    let meetingData = {
        id: document.getElementById('meeting-id')?.textContent?.trim() || null,
        roomName: document.getElementById('room-name')?.textContent?.trim() || null
    };

    let participantId = null;
    let hasJoinedMeeting = false;
    let pingInterval = null;
    let stompClient = null;
    let isMeetingEnding = false; // Флаг для предотвращения дублирующих действий

    function connectWs() {
        try {
            const socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;
            stompClient.connect({}, function () {
                console.log('WS connected');
                if (meetingData.id) {
                    stompClient.subscribe('/topic/meetings/' + meetingData.id, function (message) {
                        const body = message.body || '';
                        console.log('WS message received:', body);

                        // Обработка разных типов сообщений
                        switch(body) {
                            case 'MEETING_ENDING':
                                console.log('Meeting is ending...');
                                showLoading('Урок завершается...');
                                isMeetingEnding = true;
                                // Подготавливаем к завершению, но не закрываем сразу
                                break;

                            case 'ENDED':
                                console.log('Meeting ended by teacher');
                                handleMeetingEnded('Урок завершен преподавателем');
                                break;

                            case 'FORCE_DISCONNECT':
                                console.log('Force disconnect received');
                                handleMeetingEnded('Соединение принудительно завершено');
                                break;

                            default:
                                console.log('Unknown WS message:', body);
                        }
                    });
                }
            }, function(error) {
                console.error('WS connection failed:', error);
                // Переподключение через 5 секунд
                setTimeout(connectWs, 5000);
            });
        } catch (e) {
            console.warn('WS connect error', e);
            setTimeout(connectWs, 5000);
        }
    }

    function handleMeetingEnded(message) {
        if (isMeetingEnding) {
            return; // Избегаем дублирующих действий
        }

        isMeetingEnding = true;
        showLoading('Завершение соединения...');

        // Принудительно закрываем Jitsi
        if (jitsiApi) {
            try {
                // Попробуем мягко завершить
                jitsiApi.executeCommand('hangup');

                // Если через 2 секунды не сработало - принудительно
                setTimeout(() => {
                    try {
                        jitsiApi.dispose();
                    } catch (e) {
                        console.log('Jitsi dispose error (expected):', e);
                    }

                    // Показываем уведомление и перенаправляем
                    alert(message);
                    cleanupAndRedirect();
                }, 2000);

            } catch (e) {
                console.log('Jitsi hangup error:', e);
                try {
                    jitsiApi.dispose();
                } catch (disposeError) {
                    console.log('Jitsi dispose error:', disposeError);
                }
                alert(message);
                cleanupAndRedirect();
            }
        } else {
            alert(message);
            cleanupAndRedirect();
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log('Инициализация с данными:', { userData, meetingData });

        if (!meetingData.roomName) {
            console.error('Отсутствует название комнаты');
            showError('Ошибка: не удалось получить данные комнаты');
            return;
        }

        showLoading('Подключение к видеоконференции...');
        initializeJitsiMeet();
        connectWs();
    });

    function initializeJitsiMeet() {
        const domain = window.location.host;
        const roomName = meetingData.roomName;

        const options = {
            roomName: roomName,
            width: '100%',
            height: '100%',
            parentNode: document.querySelector('#jitsi-container'),
            configOverwrite: {
                prejoinPageEnabled: false,
                startWithAudioMuted: false,
                startWithVideoMuted: false,
                enableWelcomePage: false,
                enableClosePage: false,
                defaultLanguage: 'ru',
                disableDeepLinking: true,
                resolution: 720,
                constraints: {
                    video: {
                        height: { ideal: 720, max: 1080, min: 180 }
                    }
                },
                channelLastN: 20,
                enableLayerSuspension: true,
                p2p: {
                    enabled: false,
                    stunServers: [
                        { urls: 'stun:stun.l.google.com:19302' },
                        { urls: 'stun:stun1.l.google.com:19302' }
                    ]
                }
            },
            interfaceConfigOverwrite: {
                TOOLBAR_BUTTONS: [
                    'microphone', 'camera', 'closedcaptions', 'desktop',
                    'fullscreen', 'fodeviceselection', 'hangup', 'profile',
                    'chat', 'raisehand', 'videoquality', 'filmstrip',
                    'invite', 'settings', 'tileview', 'select-background',
                    'mute-everyone', 'security'
                ],
                SETTINGS_SECTIONS: [
                    'devices', 'language', 'moderator', 'profile', 'calendar'
                ],
                SHOW_JITSI_WATERMARK: false,
                SHOW_WATERMARK_FOR_GUESTS: false,
                SHOW_BRAND_WATERMARK: false,
                BRAND_WATERMARK_LINK: '',
                SHOW_POWERED_BY: false,
                GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false,
                DISPLAY_WELCOME_PAGE_CONTENT: false,
                LANG_DETECTION: false,
                DEFAULT_LANGUAGE: 'ru'
            },
            userInfo: {
                displayName: userData.name,
                email: userData.id ? ('user' + userData.id + '@manastraining.kg') : undefined
            }
        };

        console.log('Создание Jitsi API с опциями:', options);

        try {
            jitsiApi = new JitsiMeetExternalAPI(domain, options);
            setupJitsiEvents();
            joinMeetingAutomatically();
        } catch (error) {
            console.error('Ошибка создания Jitsi API:', error);
            hideLoading();
            showError('Ошибка подключения к видеоконференции: ' + error.message);
        }
    }

    function setupJitsiEvents() {
        jitsiApi.addEventListener('apiReady', () => {
            console.log('Jitsi API готов');
            hideLoading();
        });

        jitsiApi.addEventListener('videoConferenceJoined', (event) => {
            console.log('Присоединились к конференции:', event);
            hideLoading();
            hasJoinedMeeting = true;

            if (userData.role === 'TEACHER') {
                document.getElementById('complete-btn').style.display = 'block';
            }

            initializePing();
        });

        jitsiApi.addEventListener('participantJoined', (event) => {
            console.log('Участник присоединился:', event);
        });

        jitsiApi.addEventListener('participantLeft', (event) => {
            console.log('Участник покинул встречу:', event);
        });

        jitsiApi.addEventListener('videoConferenceLeft', async () => {
            console.log('Пользователь вышел из конференции (videoConferenceLeft)');

            // Если это не преднамеренное завершение, отправляем уведомление на бэк
            if (!isMeetingEnding) {
                await sendLeaveNotification();
            }

            cleanupAndRedirect();
        });

        jitsiApi.addEventListener('readyToClose', () => {
            console.log('Готовность к закрытию');
            cleanupAndRedirect();
        });

        jitsiApi.addEventListener('error', (error) => {
            console.error('Ошибка Jitsi:', error);
            showError('Ошибка видеоконференции: ' + error.message);
        });
    }

    async function sendLeaveNotification() {
        try {
            if (participantId && meetingData.id) {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const header = document.querySelector('meta[name="_csrf_header"]').content;

                const headers = new Headers();
                if (header && token) {
                    headers.append(header, token);
                }
                headers.append('Content-Type', 'application/x-www-form-urlencoded');

                const data = new URLSearchParams();
                data.append('participantId', participantId);

                await fetch('/api/jitsi/meetings/' + meetingData.id + '/leave-by-participant', {
                    method: 'POST',
                    headers: headers,
                    body: data
                });
            }
        } catch (e) {
            console.warn('Не удалось отправить leave notification');
        }
    }

    async function joinMeetingAutomatically() {
        if (!userData.id || !meetingData.id) {
            console.error('Недостаточно данных для присоединения к встрече');
            return;
        }

        try {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const response = await fetch('/api/jitsi/meetings/join', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    ...(token && header ? { [header]: token } : {})
                },
                body: JSON.stringify({
                    meetingId: parseInt(meetingData.id),
                    userId: parseInt(userData.id),
                    participantName: userData.name
                })
            });

            if (response.ok) {
                const participantData = await response.json();
                participantId = participantData.participantId;
                console.log('Backend: успешно присоединились к встрече, participantId:', participantId);
                initializePing();
            } else {
                console.error('Backend: ошибка присоединения к встрече:', response.status);
            }
        } catch (error) {
            console.error('Ошибка при присоединении к встрече на backend:', error);
        }
    }

    function initializePing() {
        if (!participantId || !meetingData.id) {
            console.log('Ping: ожидаю participantId/meetingId...');
            return;
        }
        if (!pingInterval) {
            pingInterval = setInterval(sendPing, 60000);
            console.log('Ping таймер запущен (60s) для участника:', participantId);
        }
        sendPing();
    }

    async function sendPing() {
        if (!participantId || !meetingData.id || isMeetingEnding) {
            return;
        }

        try {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const response = await fetch('/api/jitsi/ping/heartbeat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    ...(token && header ? { [header]: token } : {})
                },
                body: new URLSearchParams({
                    participantId: participantId,
                    meetingId: meetingData.id
                })
            });

            if (response.ok) {
                console.log('Ping отправлен успешно');
            } else {
                console.warn('Ошибка ping:', response.status);
            }
        } catch (error) {
            console.error('Ошибка отправки ping:', error);
        }
    }

    function stopPing() {
        if (pingInterval) {
            clearInterval(pingInterval);
            pingInterval = null;
            console.log('Ping остановлен');
        }
    }

    async function completeCall() {
        if (!userData.id || !meetingData.id) {
            showError('Ошибка: недостаточно данных для завершения встречи');
            return;
        }

        if (userData.role !== 'TEACHER') {
            showError('Только преподаватель может завершить урок');
            return;
        }

        if (!confirm('Вы уверены, что хотите завершить урок для всех участников?')) {
            return;
        }

        isMeetingEnding = true;
        showLoading('Завершение встречи для всех участников...');
        stopPing();

        try {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            // Отправляем запрос на завершение встречи
            const response = await fetch('/api/jitsi/meetings/end', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    ...(token && header ? { [header]: token } : {})
                },
                body: JSON.stringify({
                    meetingId: parseInt(meetingData.id),
                    teacherId: parseInt(userData.id)
                })
            });

            if (response.ok) {
                console.log('Встреча успешно завершена на сервере');

                // Дополнительно отправляем команду принудительного завершения
                setTimeout(async () => {
                    try {
                        await fetch('/api/jitsi/meetings/' + meetingData.id + '/force-end-all', {
                            method: 'POST',
                            headers: {
                                ...(token && header ? { [header]: token } : {})
                            }
                        });
                    } catch (e) {
                        console.warn('Ошибка отправки force-end-all:', e);
                    }
                }, 500);

                // Закрываем соединение учителя
                if (jitsiApi) {
                    try {
                        jitsiApi.executeCommand('hangup');
                        setTimeout(() => {
                            try {
                                jitsiApi.dispose();
                            } catch (e) {}
                        }, 1000);
                    } catch (e) {
                        try {
                            jitsiApi.dispose();
                        } catch (e2) {}
                    }
                }

                alert('Урок завершен для всех участников');
                setTimeout(() => {
                    window.location.href = '/schedules';
                }, 2000);

            } else {
                isMeetingEnding = false;
                hideLoading();
                const errorText = await response.text();
                showError('Ошибка завершения встречи: ' + errorText);
            }
        } catch (error) {
            isMeetingEnding = false;
            hideLoading();
            console.error('Ошибка при завершении встречи:', error);
            showError('Ошибка сети при завершении встречи');
        }
    }

    async function leaveMeeting() {
        if (isMeetingEnding) {
            return; // Предотвращаем дублирующие действия
        }

        if (!confirm('Вы уверены, что хотите покинуть встречу?')) {
            return;
        }

        isMeetingEnding = true;
        showLoading('Покидание встречи...');
        stopPing();

        try {
            if (userData.id && meetingData.id) {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const header = document.querySelector('meta[name="_csrf_header"]').content;

                const headers = new Headers();
                if (header && token) {
                    headers.append(header, token);
                }
                headers.append('Content-Type', 'application/x-www-form-urlencoded');

                const body = new URLSearchParams();
                body.append('userId', String(parseInt(userData.id)));

                await fetch('/api/jitsi/meetings/' + meetingData.id + '/leave', {
                    method: 'POST',
                    headers: headers,
                    body: body
                });

                console.log('Успешно покинули встречу на backend');
            }
        } catch (error) {
            console.error('Ошибка при покидании встречи:', error);
        } finally {
            // Закрываем Jitsi и перенаправляем
            if (jitsiApi) {
                try {
                    jitsiApi.dispose();
                } catch (e) {}
            }
            cleanupAndRedirect();
        }
    }

    function cleanupAndRedirect() {
        stopPing();
        hideLoading();

        try {
            if (stompClient && stompClient.connected) {
                stompClient.disconnect(() => console.log('WS disconnected'));
            }
        } catch (e) {
            console.log('WS disconnect error:', e);
        }

        setTimeout(() => {
            window.location.href = '/schedules';
        }, 1000);
    }

    function showLoading(text) {
        const overlay = document.getElementById('loading-overlay');
        const loadingText = document.getElementById('loading-text');
        loadingText.textContent = text || 'Обработка запроса...';
        overlay.style.display = 'flex';
    }

    function hideLoading() {
        const overlay = document.getElementById('loading-overlay');
        overlay.style.display = 'none';
    }

    function showError(message) {
        alert('Ошибка: ' + message);
        console.error('Error:', message);
    }

    // Обработка закрытия окна/вкладки
    window.addEventListener('beforeunload', function(event) {
        stopPing();

        if (hasJoinedMeeting && participantId && meetingData.id && !isMeetingEnding) {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const headers = new Headers();
            if (header && token) {
                headers.append(header, token);
            }
            headers.append('Content-Type', 'application/x-www-form-urlencoded');

            const data = new URLSearchParams();
            data.append('participantId', participantId);

            // Используем sendBeacon для надежной отправки при закрытии страницы
            const blob = new Blob([data.toString()], {type: 'application/x-www-form-urlencoded'});
            navigator.sendBeacon('/api/jitsi/meetings/' + meetingData.id + '/leave-by-participant', blob);
        }
    });

    window.addEventListener('unload', function() {
        if (jitsiApi) {
            try {
                jitsiApi.dispose();
            } catch (e) {}
        }
        stopPing();
    });

    // Обработка потери фокуса (например, при переключении вкладки)
    document.addEventListener('visibilitychange', function() {
        if (document.visibilityState === 'hidden' && isMeetingEnding) {
            // Если встреча завершается и пользователь ушел с вкладки, ускоряем перенаправление
            setTimeout(() => {
                window.location.href = '/schedules';
            }, 3000);
        }
    });
</script>

<style>
    .loading-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 10000;
        justify-content: center;
        align-items: center;
    }

    .loading-content {
        text-align: center;
        color: white;
    }

    .spinner {
        border: 4px solid #f3f3f3;
        border-top: 4px solid #3498db;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    #custom-controls .btn {
        margin: 0 5px;
    }

    #jitsi-container {
        background: #000;
    }

    /* Дополнительные стили для индикации завершения встречи */
    .meeting-ending {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(255, 0, 0, 0.9);
        color: white;
        padding: 20px;
        border-radius: 10px;
        z-index: 10001;
        text-align: center;
        font-size: 18px;
        display: none;
    }
</style>

<div class="meeting-ending" id="meeting-ending-notification">
    <i class="fas fa-exclamation-triangle"></i>
    Встреча завершается...
</div>

</body>
</html>