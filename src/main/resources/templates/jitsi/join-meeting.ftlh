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
</div>

<div id="meeting-container">
    <div class="top-toolbar">
        <div class="meeting-info">
            <h3 id="meeting-title">ManasTraining - Урок</h3>
            <div class="meeting-time" id="meeting-duration">00:00:00</div>
        </div>
        <div class="call-action-buttons">
            <button class="complete-call-btn" onclick="completeCall()">
                <i class="fas fa-check-circle"></i> Завершить звонок
            </button>
        </div>
        <div class="top-controls">
            <button class="btn-secondary btn-sm" onclick="toggleSettings()">
                <i class="fas fa-cog"></i> Настройки
            </button>
            <button class="btn-secondary btn-sm" onclick="toggleFullscreen()">
                <i class="fas fa-expand"></i>
            </button>
        </div>
    </div>

    <div class="video-area">
        <div class="main-video-container">
            <div class="main-video" id="main-video">
                <div class="video-placeholder" id="video-placeholder">
                    <i class="fas fa-user"></i>
                </div>
                <video id="local-video" autoplay muted playsinline style="display: none;"></video>
                <div class="participant-overlay">
                    <span id="main-participant-name">Вы</span>
                    <span id="main-participant-status">
                        <i class="fas fa-microphone-slash" style="color: #f44336;"></i>
                        <i class="fas fa-video-slash" style="color: #f44336;"></i>
                    </span>
                </div>
            </div>

            <div class="filmstrip" id="filmstrip"></div>
        </div>

        <div class="participants-panel" id="participants-panel">
            <div class="participants-header">
                <h5><i class="fas fa-users"></i> Участники (<span id="participant-count">1</span>)</h5>
                <button class="btn-secondary btn-sm" onclick="toggleParticipants()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="participants-list" id="participants-list"></div>
        </div>

        <div class="chat-panel" id="chat-panel">
            <div class="chat-header">
                <h5><i class="fas fa-comments"></i> Чат</h5>
                <button class="btn-secondary btn-sm" onclick="toggleChat()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="chat-messages" id="chat-messages">
                <div class="chat-message">
                    <div class="message-sender">Система</div>
                    <div class="message-content">Добро пожаловать в урок!</div>
                    <div class="message-time" id="welcome-time"></div>
                </div>
            </div>
            <div class="chat-input">
                <div class="chat-input-group">
                    <input type="text" id="chat-input" placeholder="Введите сообщение..." onkeypress="handleChatKeyPress(event)">
                    <button class="btn-success btn-sm" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="bottom-toolbar">
        <button class="control-btn muted" id="mute-audio" onclick="toggleAudio()" title="Микрофон">
            <i class="fas fa-microphone-slash"></i>
        </button>

        <button class="control-btn muted" id="mute-video" onclick="toggleVideo()" title="Камера">
            <i class="fas fa-video-slash"></i>
        </button>

        <button class="control-btn" id="screen-share" onclick="toggleScreenShare()" title="Демонстрация экрана">
            <i class="fas fa-desktop"></i>
        </button>

        <button class="control-btn" onclick="toggleParticipants()" title="Участники">
            <i class="fas fa-users"></i>
        </button>

        <button class="control-btn" onclick="toggleChat()" title="Чат">
            <i class="fas fa-comments"></i>
        </button>

        <button class="control-btn" onclick="raiseHand()" title="Поднять руку" id="raise-hand">
            <i class="fas fa-hand-paper"></i>
        </button>

        <button class="control-btn danger" onclick="leaveMeeting()" title="Покинуть встречу">
            <i class="fas fa-phone-slash"></i>
        </button>
    </div>
</div>

<div class="settings-modal" id="settings-modal">
    <div class="settings-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4>Настройки</h4>
            <button class="btn-secondary btn-sm" onclick="toggleSettings()">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <div class="form-group">
            <label class="form-label">Камера</label>
            <select class="form-select" id="camera-select">
                <option>Загрузка...</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">Микрофон</label>
            <select class="form-select" id="microphone-select">
                <option>Загрузка...</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">Динамики</label>
            <select class="form-select" id="speaker-select">
                <option>Загрузка...</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">Имя участника</label>
            <input type="text" class="form-control" id="display-name" value="" placeholder="Ваше имя">
        </div>

        <div class="d-flex gap-2 mt-4">
            <button class="btn-success" onclick="applySettings()">Применить</button>
            <button class="btn-secondary" onclick="toggleSettings()">Отмена</button>
        </div>
    </div>
</div>

<div class="notification" id="notification">
    <span id="notification-text"></span>
</div>

<div class="loading-overlay" id="loading-overlay">
    <div class="loading-content">
        <div class="spinner"></div>
        <div id="loading-text">Обработка запроса...</div>
    </div>
</div>

<script>
    let localStream = null;
    let audioContext = null;
    let analyser = null;
    let dataArray = null;

    let userData = {
        id: document.getElementById('user-id')?.textContent?.trim() || null,
        name: document.getElementById('user-name')?.textContent?.trim() || 'Гость',
        role: document.getElementById('user-role')?.textContent?.trim() || 'STUDENT'
    };

    let meetingData = {
        id: document.getElementById('meeting-id')?.textContent?.trim() || null
    };

    let pingInterval = null;
    let participantIdForPing = null;
    let meetingIdForPing = null;

    let localParticipant = {
        id: userData.id,
        name: userData.name,
        isAudioMuted: true,
        isVideoMuted: true,
        isHandRaised: false,
        role: userData.role
    };

    let participants = new Map();
    let meetingStartTime = new Date();
    let isRecording = false;
    let isScreenSharing = false;
    let availableDevices = {
        cameras: [],
        microphones: [],
        speakers: []
    };

    let participantId = null;
    let hasJoinedMeeting = false;

    document.addEventListener('DOMContentLoaded', function() {
        console.log('Инициализация с данными пользователя:', userData);
        console.log('Данные встречи:', meetingData);

        initializeMeeting();
        updateMeetingDuration();
        setInterval(updateMeetingDuration, 1000);
        initializeChat();

        updateParticipantDisplay();
        updateParticipantsList();
        updateParticipantCount();

        loadDevices();

        if (userData.id && meetingData.id) {
            joinMeetingAutomatically();
        }
    });

    function initializePing() {
        if (participantId && meetingData.id) {
            participantIdForPing = participantId;
            meetingIdForPing = meetingData.id;

            pingInterval = setInterval(sendPing, 600000);

            sendPing();

            console.log('Ping initialized for participant:', participantIdForPing);
        }
    }

    async function sendPing() {
        if (!participantIdForPing || !meetingIdForPing) {
            console.log('Ping skipped - no participant or meeting data');
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
                    participantId: participantIdForPing,
                    meetingId: meetingIdForPing
                })
            });

            if (response.ok) {
                console.log('Ping sent successfully');
            } else {
                console.warn('Ping failed with status:', response.status);
            }
        } catch (error) {
            console.error('Error sending ping:', error);
        }
    }

    function stopPing() {
        if (pingInterval) {
            clearInterval(pingInterval);
            pingInterval = null;
            console.log('Ping stopped');
        }
    }

    async function joinMeetingAutomatically() {
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
                hasJoinedMeeting = true;
                console.log('Успешно присоединились к встрече, participantId:', participantId);

                initializePing();
            } else {
                console.error('Ошибка присоединения к встрече:', response.statusText);
            }
        } catch (error) {
            console.error('Ошибка при присоединении к встрече:', error);
        }
    }

    async function completeCall() {
        if (!userData.id || !meetingData.id) {
            showNotification('Ошибка: недостаточно данных для завершения встречи', 'error');
            return;
        }

        if (userData.role !== 'TEACHER') {
            showNotification('Только преподаватель может завершить урок', 'error');
            return;
        }

        if (confirm('Вы уверены, что хотите завершить звонок для всех участников?')) {
            showLoading('Завершение встречи...');

            stopPing();

            try {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const header = document.querySelector('meta[name="_csrf_header"]').content;

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

                hideLoading();

                if (response.ok) {
                    if (localStream) {
                        localStream.getTracks().forEach(track => {
                            track.stop();
                        });
                    }

                    showNotification('Звонок завершен для всех участников', 'success');

                    setTimeout(() => {
                        window.location.href = '/schedules';
                    }, 2000);
                } else {
                    let errorMessage = 'Неизвестная ошибка сервера';
                    try {
                        const errorText = await response.text();
                        if (errorText.includes('<!DOCTYPE html>')) {
                            errorMessage = `Ошибка сервера . Возможно, сессия истекла.`;
                        } else {
                            errorMessage = errorText;
                        }
                    } catch (e) {
                        errorMessage = `HTTP Error `;
                    }

                    showNotification('Ошибка завершения встречи: ' + errorMessage, 'error');
                    console.error('Server response:', response.status, response.statusText);
                }
            } catch (error) {
                hideLoading();
                console.error('Ошибка при завершении встречи:', error);

                let errorMessage = 'Ошибка сети при завершении встречи';
                if (error.name === 'TypeError' && error.message.includes('fetch')) {
                    errorMessage = 'Ошибка подключения к серверу. Проверьте интернет соединение.';
                }

                showNotification(errorMessage, 'error');
            }
        }
    }

    async function leaveMeeting() {
        if (confirm('Вы уверены, что хотите покинуть встречу?')) {
            showLoading('Покидание встречи...');

            stopPing();

            try {
                const token = document.querySelector('meta[name="_csrf"]').content;
                const header = document.querySelector('meta[name="_csrf_header"]').content;

                let response;

                if (userData.id) {
                    response = await fetch(`/api/jitsi/meetings/${meeting.meetingId}/leave`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            ...(token && header ? { [header]: token } : {})
                        },
                        body: JSON.stringify({
                            userId: parseInt(userData.id)
                        })
                    });
                }

                hideLoading();

                if (response && response.ok) {
                    if (localStream) {
                        localStream.getTracks().forEach(track => track.stop());
                    }
                    showNotification('Вы покинули встречу', 'success');
                    setTimeout(() => window.location.href = '/schedules', 2000);
                } else {
                    showNotification('Ошибка при покидании встречи', 'error');
                }
            } catch (error) {
                hideLoading();
                console.error('Ошибка при покидании встречи:', error);
                showNotification('Ошибка сети при покидании встречи', 'error');
            }
        }
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

    function updateParticipantDisplay() {
        const mainParticipantName = document.getElementById('main-participant-name');
        if (mainParticipantName) {
            mainParticipantName.textContent = localParticipant.name + ' (Вы)';
        }

        const displayNameInput = document.getElementById('display-name');
        if (displayNameInput) {
            displayNameInput.value = localParticipant.name;
        }

        console.log('Обновлено отображение участника:', localParticipant);
    }

    function setupAudioAnalyzer() {
        try {
            audioContext = new (window.AudioContext || window.webkitAudioContext)();
            const source = audioContext.createMediaStreamSource(localStream);
            analyser = audioContext.createAnalyser();
            analyser.fftSize = 256;

            const bufferLength = analyser.frequencyBinCount;
            dataArray = new Uint8Array(bufferLength);

            source.connect(analyser);
            monitorAudioLevel();

        } catch (error) {
            console.error('Ошибка настройки аудио анализатора:', error);
        }
    }

    function monitorAudioLevel() {
        if (!analyser || !dataArray) return;

        analyser.getByteFrequencyData(dataArray);

        let sum = 0;
        for (let i = 0; i < dataArray.length; i++) {
            sum += dataArray[i];
        }
        const average = sum / dataArray.length;

        if (average > 30 && !localParticipant.isAudioMuted) {
            document.getElementById('main-video').style.borderColor = '#4CAF50';
        } else {
            document.getElementById('main-video').style.borderColor = 'transparent';
        }

        requestAnimationFrame(monitorAudioLevel);
    }

    async function toggleAudio() {
        try {
            if (!localStream || localStream.getAudioTracks().length === 0) {
                console.log('Запрос доступа к микрофону...');

                const audioStream = await navigator.mediaDevices.getUserMedia({
                    audio: {
                        echoCancellation: true,
                        noiseSuppression: true,
                        autoGainControl: true
                    }
                });

                if (!localStream) {
                    localStream = audioStream;
                } else {
                    const audioTrack = audioStream.getAudioTracks()[0];
                    localStream.addTrack(audioTrack);
                }

                setupAudioAnalyzer();
                showNotification('Доступ к микрофону получен', 'success');
            }

            const audioTrack = localStream.getAudioTracks()[0];
            if (!audioTrack) {
                showNotification('Микрофон не найден', 'error');
                return;
            }

            localParticipant.isAudioMuted = !localParticipant.isAudioMuted;
            const btn = document.getElementById('mute-audio');
            const icon = btn.querySelector('i');

            if (localParticipant.isAudioMuted) {
                audioTrack.enabled = false;
                btn.classList.add('muted');
                icon.className = 'fas fa-microphone-slash';
                showNotification('Микрофон выключен');
            } else {
                audioTrack.enabled = true;
                btn.classList.remove('muted');
                icon.className = 'fas fa-microphone';
                showNotification('Микрофон включен');
            }

            updateParticipantStatus();

        } catch (error) {
            console.error('Ошибка доступа к микрофону:', error);
            let errorMessage = 'Ошибка доступа к микрофону';

            if (error.name === 'NotAllowedError') {
                errorMessage = 'Доступ к микрофону запрещен. Разрешите доступ в настройках браузера';
            } else if (error.name === 'NotFoundError') {
                errorMessage = 'Микрофон не найден. Проверьте подключение устройства';
            } else if (error.name === 'NotReadableError') {
                errorMessage = 'Микрофон используется другим приложением';
            }

            showNotification(errorMessage, 'error');
        }
    }

    async function toggleVideo() {
        try {
            if (!localStream || localStream.getVideoTracks().length === 0) {
                console.log('Запрос доступа к камере...');

                const videoStream = await navigator.mediaDevices.getUserMedia({
                    video: {
                        facingMode: 'user'
                    }
                });

                if (!localStream) {
                    localStream = videoStream;
                } else {
                    const videoTrack = videoStream.getVideoTracks()[0];
                    localStream.addTrack(videoTrack);
                }

                const localVideo = document.getElementById('local-video');
                localVideo.srcObject = localStream;

                showNotification('Доступ к камере получен', 'success');
            }

            const videoTrack = localStream.getVideoTracks()[0];
            if (!videoTrack) {
                showNotification('Камера не найдена', 'error');
                return;
            }

            localParticipant.isVideoMuted = !localParticipant.isVideoMuted;
            const btn = document.getElementById('mute-video');
            const icon = btn.querySelector('i');
            const localVideo = document.getElementById('local-video');
            const placeholder = document.getElementById('video-placeholder');

            if (localParticipant.isVideoMuted) {
                videoTrack.enabled = false;
                btn.classList.add('muted');
                icon.className = 'fas fa-video-slash';
                localVideo.style.display = 'none';
                placeholder.style.display = 'block';
                showNotification('Камера выключена');
            } else {
                videoTrack.enabled = true;
                btn.classList.remove('muted');
                icon.className = 'fas fa-video';
                localVideo.style.display = 'block';
                placeholder.style.display = 'none';
                showNotification('Камера включена');
            }

            updateParticipantStatus();

        } catch (error) {
            console.error('Ошибка доступа к камере:', error);
            let errorMessage = 'Ошибка доступа к камере';

            if (error.name === 'NotAllowedError') {
                errorMessage = 'Доступ к камере запрещен. Разрешите доступ в настройках браузера';
            } else if (error.name === 'NotFoundError') {
                errorMessage = 'Камера не найдена. Проверьте подключение устройства';
            } else if (error.name === 'NotReadableError') {
                errorMessage = 'Камера используется другим приложением';
            }

            showNotification(errorMessage, 'error');
        }
    }

    async function toggleScreenShare() {
        if (!isScreenSharing) {
            try {
                const screenStream = await navigator.mediaDevices.getDisplayMedia({
                    video: true,
                    audio: true
                });

                const localVideo = document.getElementById('local-video');
                localVideo.srcObject = screenStream;
                localVideo.style.display = 'block';
                document.getElementById('video-placeholder').style.display = 'none';

                isScreenSharing = true;
                const btn = document.getElementById('screen-share');
                btn.classList.add('active');
                showNotification('Демонстрация экрана начата');

                screenStream.getVideoTracks()[0].addEventListener('ended', () => {
                    stopScreenShare();
                });

            } catch (error) {
                console.error('Ошибка демонстрации экрана:', error);
                showNotification('Ошибка демонстрации экрана: ' + error.message, 'error');
            }
        } else {
            stopScreenShare();
        }
    }

    function stopScreenShare() {
        isScreenSharing = false;
        const btn = document.getElementById('screen-share');
        btn.classList.remove('active');
        showNotification('Демонстрация экрана остановлена');

        if (localStream) {
            const localVideo = document.getElementById('local-video');
            localVideo.srcObject = localStream;
        }
    }

    function initializeMeeting() {
        showNotification('Соединение установлено', 'success');
    }

    function updateMeetingDuration() {
        const now = new Date();
        const duration = now - meetingStartTime;
        const hours = Math.floor(duration / 3600000);
        const minutes = Math.floor((duration % 3600000) / 60000);
        const seconds = Math.floor((duration % 60000) / 1000);

        document.getElementById('meeting-duration').textContent =
            hours.toString().padStart(2, '0') + ':' +
            minutes.toString().padStart(2, '0') + ':' +
            seconds.toString().padStart(2, '0');
    }

    function toggleParticipants() {
        const panel = document.getElementById('participants-panel');
        panel.classList.toggle('show');
    }

    function toggleChat() {
        const panel = document.getElementById('chat-panel');
        panel.classList.toggle('show');
    }

    function raiseHand() {
        localParticipant.isHandRaised = !localParticipant.isHandRaised;
        const btn = document.getElementById('raise-hand');

        if (localParticipant.isHandRaised) {
            btn.classList.add('active');
            showNotification('Рука поднята');
        } else {
            btn.classList.remove('active');
            showNotification('Рука опущена');
        }

        updateParticipantsList();
    }

    function toggleSettings() {
        const modal = document.getElementById('settings-modal');
        modal.style.display = modal.style.display === 'flex' ? 'none' : 'flex';

        if (modal.style.display === 'flex') {
            loadDevices();
        }
    }

    async function applySettings() {
        const displayName = document.getElementById('display-name').value;
        if (displayName && displayName !== localParticipant.name) {
            localParticipant.name = displayName;
            updateParticipantDisplay();
            updateParticipantsList();
        }

        const cameraSelect = document.getElementById('camera-select');
        const micSelect = document.getElementById('microphone-select');

        if (cameraSelect.value && localStream) {
            await switchCamera(cameraSelect.value);
        }

        if (micSelect.value && localStream) {
            await switchMicrophone(micSelect.value);
        }

        showNotification('Настройки применены');
        toggleSettings();
    }

    async function switchCamera(deviceId) {
        try {
            const videoTrack = localStream.getVideoTracks()[0];
            if (videoTrack) {
                videoTrack.stop();
                localStream.removeTrack(videoTrack);
            }

            const newVideoStream = await navigator.mediaDevices.getUserMedia({
                video: { deviceId: { exact: deviceId } }
            });

            const newVideoTrack = newVideoStream.getVideoTracks()[0];
            localStream.addTrack(newVideoTrack);

            const localVideo = document.getElementById('local-video');
            localVideo.srcObject = localStream;

            showNotification('Камера изменена');

        } catch (error) {
            console.error('Ошибка переключения камеры:', error);
            showNotification('Ошибка переключения камеры: ' + error.message, 'error');
        }
    }

    async function switchMicrophone(deviceId) {
        try {
            const audioTrack = localStream.getAudioTracks()[0];
            if (audioTrack) {
                audioTrack.stop();
                localStream.removeTrack(audioTrack);
            }

            const newAudioStream = await navigator.mediaDevices.getUserMedia({
                audio: { deviceId: { exact: deviceId } }
            });

            const newAudioTrack = newAudioStream.getAudioTracks()[0];
            localStream.addTrack(newAudioTrack);

            if (audioContext) {
                setupAudioAnalyzer();
            }

            showNotification('Микрофон изменен');

        } catch (error) {
            console.error('Ошибка переключения микрофона:', error);
            showNotification('Ошибка переключения микрофона: ' + error.message, 'error');
        }
    }

    function toggleFullscreen() {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
        } else {
            document.exitFullscreen();
        }
    }

    function showNotification(text, type) {
        type = type || 'info';
        const notification = document.getElementById('notification');
        const textElement = document.getElementById('notification-text');

        notification.classList.remove('show');

        setTimeout(() => {
            textElement.textContent = text;
            notification.className = 'notification';

            if (type === 'error') {
                notification.classList.add('error');
            }

            setTimeout(() => {
                notification.classList.add('show');
            }, 10);

            setTimeout(() => {
                notification.classList.remove('show');
            }, 3000);
        }, 300);
    }

    function initializeChat() {
        document.getElementById('welcome-time').textContent = new Date().toLocaleTimeString();
    }

    function sendMessage() {
        const input = document.getElementById('chat-input');
        const message = input.value.trim();

        if (message) {
            addChatMessage(localParticipant.name, message, new Date());
            input.value = '';
        }
    }

    function handleChatKeyPress(event) {
        if (event.key === 'Enter') {
            sendMessage();
        }
    }

    function addChatMessage(sender, message, time) {
        const messagesContainer = document.getElementById('chat-messages');
        const messageDiv = document.createElement('div');
        messageDiv.className = 'chat-message';

        messageDiv.innerHTML = '<div class="message-sender">' + sender + '</div>' +
            '<div class="message-content">' + message + '</div>' +
            '<div class="message-time">' + time.toLocaleTimeString() + '</div>';

        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    async function loadDevices() {
        try {
            await navigator.mediaDevices.getUserMedia({
                audio: true,
                video: true
            }).then(stream => {
                stream.getTracks().forEach(track => track.stop());
            }).catch(error => {
                console.log('Разрешения не получены, продолжаем загрузку устройств');
            });

            const devices = await navigator.mediaDevices.enumerateDevices();

            const cameraSelect = document.getElementById('camera-select');
            const micSelect = document.getElementById('microphone-select');
            const speakerSelect = document.getElementById('speaker-select');

            cameraSelect.innerHTML = '<option value="">Выберите камеру...</option>';
            micSelect.innerHTML = '<option value="">Выберите микрофон...</option>';
            speakerSelect.innerHTML = '<option value="">Выберите динамики...</option>';

            availableDevices.cameras = [];
            availableDevices.microphones = [];
            availableDevices.speakers = [];

            devices.forEach(device => {
                const option = document.createElement('option');
                option.value = device.deviceId;
                option.text = device.label || (device.kind + ' ' + device.deviceId.substr(0, 8));

                if (device.kind === 'videoinput') {
                    availableDevices.cameras.push(device);
                    cameraSelect.appendChild(option.cloneNode(true));
                } else if (device.kind === 'audioinput') {
                    availableDevices.microphones.push(device);
                    micSelect.appendChild(option.cloneNode(true));
                } else if (device.kind === 'audiooutput') {
                    availableDevices.speakers.push(device);
                    speakerSelect.appendChild(option.cloneNode(true));
                }
            });

            console.log('Устройства загружены:', availableDevices);

            if (availableDevices.cameras.length === 0) {
                cameraSelect.innerHTML = '<option>Камера не найдена</option>';
            }
            if (availableDevices.microphones.length === 0) {
                micSelect.innerHTML = '<option>Микрофон не найден</option>';
            }
            if (availableDevices.speakers.length === 0) {
                speakerSelect.innerHTML = '<option>Динамики не найдены</option>';
            }

        } catch (error) {
            console.error('Ошибка загрузки устройств:', error);
            showNotification('Ошибка загрузки устройств: ' + error.message, 'error');
        }
    }

    function updateParticipantStatus() {
        const statusElement = document.getElementById('main-participant-status');
        let statusHtml = '';

        if (localParticipant.isAudioMuted) {
            statusHtml += '<i class="fas fa-microphone-slash" style="color: #f44336;"></i> ';
        } else {
            statusHtml += '<i class="fas fa-microphone" style="color: #4CAF50;"></i> ';
        }

        if (localParticipant.isVideoMuted) {
            statusHtml += '<i class="fas fa-video-slash" style="color: #f44336;"></i>';
        } else {
            statusHtml += '<i class="fas fa-video" style="color: #4CAF50;"></i>';
        }

        if (localParticipant.isHandRaised) {
            statusHtml += ' <i class="fas fa-hand-paper" style="color: #FF9800;"></i>';
        }

        statusElement.innerHTML = statusHtml;
        updateParticipantsList();
    }

    function updateParticipantsList() {
        const listContainer = document.getElementById('participants-list');
        listContainer.innerHTML = '';

        const localDiv = createParticipantElement(localParticipant, true);
        listContainer.appendChild(localDiv);

        participants.forEach(participant => {
            const participantDiv = createParticipantElement(participant, false);
            listContainer.appendChild(participantDiv);
        });
    }

    function createParticipantElement(participant, isLocal) {
        const div = document.createElement('div');
        div.className = 'participant-item';
        div.id = 'participant-' + participant.id;

        const avatarBg = getAvatarColor(participant.name);
        const initials = getInitials(participant.name);

        let statusIcons = '';
        if (participant.isAudioMuted) {
            statusIcons += '<i class="fas fa-microphone-slash text-danger me-1"></i>';
        }
        if (participant.isVideoMuted) {
            statusIcons += '<i class="fas fa-video-slash text-danger me-1"></i>';
        }
        if (participant.isHandRaised) {
            statusIcons += '<i class="fas fa-hand-paper text-warning me-1"></i>';
        }

        let nameWithLabel = participant.name;
        if (isLocal) {
            nameWithLabel += ' (Вы)';
        }

        div.innerHTML = '<div class="participant-avatar" style="background: ' + avatarBg + '">' +
            initials +
            '</div>' +
            '<div class="participant-info">' +
            '<div class="participant-name">' + nameWithLabel + '</div>' +
            '<div class="participant-status">' +
            statusIcons +
            getRoleDisplayName(participant.role) +
            '</div>' +
            '</div>';

        return div;
    }

    function getRoleDisplayName(role) {
        switch(role) {
            case 'TEACHER': return 'Преподаватель';
            case 'STUDENT': return 'Студент';
            case 'ADMIN': return 'Администратор';
            default: return 'Участник';
        }
    }

    function updateParticipantCount() {
        const count = participants.size + 1;
        document.getElementById('participant-count').textContent = count;
    }

    function getAvatarColor(name) {
        const colors = [
            '#FF5722', '#E91E63', '#9C27B0', '#673AB7',
            '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4',
            '#009688', '#4CAF50', '#8BC34A', '#CDDC39',
            '#FFC107', '#FF9800', '#FF5722', '#795548'
        ];
        const index = name.charCodeAt(0) % colors.length;
        return colors[index];
    }

    function getInitials(name) {
        return name.split(' ')
            .map(word => word[0])
            .join('')
            .toUpperCase()
            .substring(0, 2);
    }

    window.addEventListener('beforeunload', function(event) {
         stopPing();

        if (hasJoinedMeeting && participantId && meetingData.id) {
            const token = document.querySelector('meta[name="_csrf"]').content;
            const header = document.querySelector('meta[name="_csrf_header"]').content;

            const headers = new Headers();
            headers.append(header, token);
            headers.append('Content-Type', 'application/x-www-form-urlencoded');

            const data = new URLSearchParams();
            data.append('participantId', participantId);

            const options = {
                method: 'POST',
                headers: headers,
                body: data,
                keepalive: true
            };

            fetch(`/api/jitsi/meetings/${meeting.meetingId}/leave-by-participant`, options);
        }
    });

    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey || event.metaKey) return;

        if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') return;

        switch(event.key.toLowerCase()) {
            case 'm':
                event.preventDefault();
                toggleAudio();
                break;
            case 'v':
                event.preventDefault();
                toggleVideo();
                break;
            case 'c':
                event.preventDefault();
                toggleChat();
                break;
            case 'p':
                event.preventDefault();
                toggleParticipants();
                break;
            case 's':
                event.preventDefault();
                toggleScreenShare();
                break;
            case 'r':
                event.preventDefault();
                raiseHand();
                break;
        }
    });

    navigator.mediaDevices.addEventListener('devicechange', () => {
        console.log('Устройства изменились, перезагружаем список...');
        loadDevices();
    });
</script>
</body>
</html>