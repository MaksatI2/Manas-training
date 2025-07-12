<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign name = user.getFullName()>
    <#assign roles = user.getAuthorities()?join(",")>
    <#assign isAdmin = roles?contains("ADMIN")>
    <#assign isTeacher = roles?contains("TEACHER")>
    <#assign isStudent = roles?contains("STUDENT")>
    <#assign currentUserId = user.user.id>
</#if>

<@layout.page>
    <div class="container-fluid p-0">
        <div class="meeting-toolbar bg-dark text-white py-2 px-3">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <button id="leaveMeetingBtn" class="btn btn-danger btn-sm">
                        <i class="fas fa-sign-out-alt me-1"></i>
                        Покинуть
                    </button>
                </div>
            </div>
        </div>

        <div class="video-container">
            <div id="jitsiContainer" class="jitsi-meet-container"></div>
        </div>

        <div class="modal fade" id="preJoinModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-video me-2"></i>
                            Подключение к уроку
                        </h5>
                    </div>
                    <div class="modal-body text-center">
                        <div class="mb-4">
                            <div class="preview-container mb-3">
                                <video id="previewVideo" class="preview-video bg-dark rounded" muted autoplay></video>
                            </div>
                            <h6 class="fw-semibold">${name!'Участник'}</h6>
                            <small class="text-muted">Проверьте камеру и микрофон перед входом</small>
                        </div>

                        <div class="media-controls mb-4">
                            <button id="toggleCamera" class="btn btn-outline-primary me-2">
                                <i class="fas fa-video"></i>
                            </button>
                            <button id="toggleMic" class="btn btn-outline-primary">
                                <i class="fas fa-microphone"></i>
                            </button>
                        </div>

                        <div class="d-grid gap-2">
                            <button id="joinMeetingBtn" class="btn btn-success btn-lg">
                                <i class="fas fa-sign-in-alt me-2"></i>
                                Войти в урок
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="loadingIndicator" class="loading-overlay" style="display: none;">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Загрузка...</span>
            </div>
            <div class="mt-3">Подключение к конференции...</div>
        </div>
    </div>

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            background: #000;
            overflow: hidden;
        }

        .meeting-toolbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            background: rgba(0, 0, 0, 0.8) !important;
            backdrop-filter: blur(10px);
        }

        .video-container {
            position: fixed;
            top: 50px;
            left: 0;
            right: 0;
            bottom: 0;
            background: #000;
        }

        .jitsi-meet-container {
            width: 100%;
            height: 100%;
        }

        .preview-container {
            position: relative;
            width: 300px;
            height: 200px;
            margin: 0 auto;
        }

        .preview-video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border: 2px solid #dee2e6;
        }

        .media-controls button {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .media-controls button:hover {
            transform: scale(1.1);
        }

        .media-controls button.active {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #1e7e34, #155724);
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(40, 167, 69, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c82333, #a71e2a);
            transform: translateY(-2px);
        }

        .meeting-info, .meeting-time {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        #jitsiContainer iframe {
            width: 100% !important;
            height: 100% !important;
            border: none;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.8);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            z-index: 2000;
        }

        .meeting-info .badge {
            margin-left: 10px;
        }
    </style>

    <script src="/static/js/external_api.js"></script>
    <script>
        let localStream = null;
        let cameraEnabled = true;
        let micEnabled = true;
        let meetingStartTime = new Date();
        let timerInterval;
        let jitsiAPI = null;

        document.addEventListener('DOMContentLoaded', function() {
            showPreJoinModal();
        });

        function showPreJoinModal() {
            const modal = new bootstrap.Modal(document.getElementById('preJoinModal'));
            modal.show();
            initializeMediaPreview();
        }

        function initializeMediaPreview() {
            navigator.mediaDevices.getUserMedia({
                video: {
                    width: { ideal: 1280 },
                    height: { ideal: 720 }
                },
                audio: true
            })
                .then(stream => {
                    localStream = stream;
                    const previewVideo = document.getElementById('previewVideo');
                    previewVideo.srcObject = stream;
                    previewVideo.play();
                })
                .catch(error => {
                    console.error('Ошибка доступа к медиа:', error);
                    document.getElementById('previewVideo').style.display = 'none';
                    const previewContainer = document.querySelector('.preview-container');
                    previewContainer.innerHTML = '<div class="alert alert-warning">Не удается получить доступ к камере/микрофону</div>';
                });
        }

        document.getElementById('toggleCamera').addEventListener('click', function() {
            cameraEnabled = !cameraEnabled;
            if (localStream) {
                const videoTracks = localStream.getVideoTracks();
                if (videoTracks.length > 0) {
                    videoTracks[0].enabled = cameraEnabled;
                }
            }
            this.classList.toggle('active', !cameraEnabled);
            this.innerHTML = cameraEnabled ? '<i class="fas fa-video"></i>' : '<i class="fas fa-video-slash"></i>';
        });

        document.getElementById('toggleMic').addEventListener('click', function() {
            micEnabled = !micEnabled;
            if (localStream) {
                const audioTracks = localStream.getAudioTracks();
                if (audioTracks.length > 0) {
                    audioTracks[0].enabled = micEnabled;
                }
            }
            this.classList.toggle('active', !micEnabled);
            this.innerHTML = micEnabled ? '<i class="fas fa-microphone"></i>' : '<i class="fas fa-microphone-slash"></i>';
        });

        document.getElementById('joinMeetingBtn').addEventListener('click', function() {
            joinMeeting();
        });

        function joinMeeting() {
            document.getElementById('loadingIndicator').style.display = 'flex';

            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
            }

            const modal = bootstrap.Modal.getInstance(document.getElementById('preJoinModal'));
            modal.hide();

            const domain = '157.245.67.28';

            const options = {
                roomName: 'ManasTraining_Meeting_${meeting.meetingId}',
                width: '100%',
                height: '100%',
                parentNode: document.getElementById('jitsiContainer'),
                configOverwrite: {
                    startWithAudioMuted: !micEnabled,
                    startWithVideoMuted: !cameraEnabled,
                    prejoinPageEnabled: false,
                    disableDeepLinking: true,

                    bosh: '//157.245.67.28/http-bind',
                    websocket: 'wss://157.245.67.28/xmpp-websocket',

                    hosts: {
                        domain: 'meet.jitsi',
                        muc: 'conference.meet.jitsi',
                        focus: 'focus.meet.jitsi'
                    },

                    useStunTurn: true,
                    stunServers: [
                        { urls: 'stun:stun.l.google.com:19302' },
                        { urls: 'stun:stun1.l.google.com:19302' },
                        { urls: 'stun:stun2.l.google.com:19302' }
                    ],

                    resolution: 720,
                    constraints: {
                        video: {
                            height: {
                                ideal: 720,
                                max: 1080,
                                min: 240
                            },
                            width: {
                                ideal: 1280,
                                max: 1920,
                                min: 320
                            }
                        }
                    },

                    channelLastN: 20,
                    startBitrate: 800,
                    disableAudioLevels: false,
                    enableNoAudioDetection: true,
                    enableNoisyMicDetection: true,
                    defaultLanguage: 'ru',

                    disableInviteFunctions: true,
                    doNotStoreRoom: true,
                    enableWelcomePage: false,
                    enableClosePage: false,

                    pcStatsInterval: 10000,
                    enableRemb: true,
                    enableTcc: true,
                    useRoomAsSharedDocumentName: false
                },

                interfaceConfigOverwrite: {
                    SHOW_JITSI_WATERMARK: false,
                    SHOW_WATERMARK_FOR_GUESTS: false,
                    DISPLAY_WELCOME_PAGE_CONTENT: false,
                    SHOW_BRAND_WATERMARK: false,
                    BRAND_WATERMARK_LINK: '',
                    SHOW_POWERED_BY: false,
                    SHOW_PROMOTIONAL_CLOSE_PAGE: false,
                    SHOW_DEEP_LINKING_IMAGE: false,
                    MOBILE_APP_PROMO: false,
                    ENFORCE_NOTIFICATION_AUTO_DISMISS_TIMEOUT: 15000,

                    TOOLBAR_BUTTONS: [
                        'microphone', 'camera', 'desktop', 'fullscreen',
                        'fodeviceselection', 'hangup', 'profile',
                        'chat', 'settings', 'raisehand',
                        'videoquality', 'filmstrip',
                        'stats', 'shortcuts', 'tileview',
                        'videobackgroundblur', 'help', 'mute-everyone'
                    ],

                    SETTINGS_SECTIONS: ['devices', 'language', 'moderator', 'profile'],
                    VIDEO_LAYOUT_FIT: 'both',

                    HIDE_INVITE_MORE_HEADER: true,
                    DISABLE_JOIN_LEAVE_NOTIFICATIONS: false,
                    DISABLE_PRESENCE_STATUS: false,
                    GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false
                },

                userInfo: {
                    displayName: '${name!'Участник'}',
                    email: '${user.user.email!''}'
                }
            };

            try {
                jitsiAPI = new JitsiMeetExternalAPI(domain, options);

                jitsiAPI.addEventListener('videoConferenceJoined', function(event) {
                    console.log('Подключен к конференции:', event);
                    document.getElementById('loadingIndicator').style.display = 'none';
                    startMeetingTimer();
                    joinMeetingOnServer();
                });

                jitsiAPI.addEventListener('connectionFailed', function(event) {
                    console.error('Ошибка подключения:', event);
                    document.getElementById('loadingIndicator').style.display = 'none';
<<<<<<< src/main/resources/templates/jitsi/join-meeting.ftlh
                    showConnectionError('Не удалось подключиться к серверу конференций');
=======
                    showConnectionError();
>>>>>>> src/main/resources/templates/jitsi/join-meeting.ftlh
                });

                jitsiAPI.addEventListener('conferenceError', function(event) {
                    console.error('Ошибка конференции:', event);
                    document.getElementById('loadingIndicator').style.display = 'none';
<<<<<<< src/main/resources/templates/jitsi/join-meeting.ftlh
                    showConnectionError('Ошибка при создании конференции');
=======
                    showConnectionError();
>>>>>>> src/main/resources/templates/jitsi/join-meeting.ftlh
                });

                jitsiAPI.addEventListener('participantJoined', function(event) {
                    console.log('Участник подключился:', event);
                    updateParticipantCount();
                });

                jitsiAPI.addEventListener('participantLeft', function(event) {
                    console.log('Участник покинул встречу:', event);
                    updateParticipantCount();
                });

                jitsiAPI.addEventListener('videoConferenceLeft', function(event) {
                    console.log('Покинул конференцию:', event);
                    leaveMeetingOnServer();
                });

                jitsiAPI.addEventListener('readyToClose', function(event) {
                    console.log('Готов к закрытию:', event);
                    leaveMeetingOnServer();
                });

                jitsiAPI.addEventListener('apiReady', function() {
                    console.log('Jitsi API готов');
                });

                setTimeout(() => {
                    if (document.getElementById('loadingIndicator').style.display !== 'none') {
                        console.warn('Долгое подключение к конференции');
                        document.getElementById('loadingIndicator').style.display = 'none';
<<<<<<< src/main/resources/templates/jitsi/join-meeting.ftlh
                        showConnectionError('Превышено время ожидания подключения');
                    }
                }, 45000);
=======
                        showConnectionError();
                    }
                }, 30000);
>>>>>>> src/main/resources/templates/jitsi/join-meeting.ftlh

            } catch (error) {
                console.error('Ошибка создания Jitsi API:', error);
                document.getElementById('loadingIndicator').style.display = 'none';
<<<<<<< src/main/resources/templates/jitsi/join-meeting.ftlh
                showConnectionError('Ошибка инициализации API: ' + error.message);
            }
        }
=======
                showConnectionError();
            }
        }

        function showConnectionError() {
            const errorMsg = `
                Не удалось подключиться к конференции.

                Возможные причины:
                1. Сервер Jitsi Meet недоступен
                2. Проблемы с сетевым подключением
                3. Блокировка WebRTC в браузере
                4. Неправильная конфигурация сервера

                Попробуйте:
                - Обновить страницу
                - Проверить подключение к интернету
                - Использовать другой браузер
            `;
            alert(errorMsg);
>>>>>>> src/main/resources/templates/jitsi/join-meeting.ftlh

        function showConnectionError(message) {
            const errorMsg = `
        ${message || 'Не удалось подключиться к конференции.'}

        Возможные причины:
        1. Сервер Jitsi Meet недоступен (${domain})
        2. Проблемы с сетевым подключением
        3. Блокировка WebRTC в браузере
        4. Неправильная конфигурация сервера

        Попробуйте:
        - Обновить страницу
        - Проверить подключение к интернету
        - Использовать другой браузер
        - Проверить, что Jitsi Meet запущен на порту 8080
    `;
            alert(errorMsg);
        }

        function joinMeetingOnServer() {
            <#if userId??>
            fetch('/api/jitsi/meetings/join', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
                },
                body: JSON.stringify({
                    meetingId: ${meeting.meetingId},
                    userId: ${userId},
                    participantName: '${name!'Участник'}'
                })
            })
                .then(response => response.json())
                .then(data => {
                    console.log('Участник зарегистрирован:', data);
                })
                .catch(error => {
                    console.error('Ошибка регистрации участника:', error);
                });
            </#if>
        }

        function leaveMeetingOnServer() {
            <#if userId??>
            fetch(`/api/jitsi/meetings/${meeting.meetingId}/leave?userId=${userId}`, {
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
                }
            })
                .then(() => {
                    console.log('Участник покинул встречу');
                    if (timerInterval) {
                        clearInterval(timerInterval);
                    }
                    window.location.href = '/lessons/${meeting.lessonId}';
                })
                .catch(error => {
                    console.error('Ошибка при выходе:', error);
                    if (timerInterval) {
                        clearInterval(timerInterval);
                    }
                    window.location.href = '/lessons/${meeting.lessonId}';
                });
            </#if>
        }

        document.getElementById('leaveMeetingBtn').addEventListener('click', function() {
            if (confirm('Вы уверены, что хотите покинуть урок?')) {
                if (jitsiAPI) {
                    jitsiAPI.dispose();
                }
                leaveMeetingOnServer();
            }
        });

        window.addEventListener('beforeunload', function() {
            if (jitsiAPI) {
                jitsiAPI.dispose();
            }
            if (timerInterval) {
                clearInterval(timerInterval);
            }
        });

        window.addEventListener('orientationchange', function() {
            if (jitsiAPI) {
                setTimeout(() => {
                    jitsiAPI.executeCommand('resizeFilmStrip');
                }, 500);
            }
        });
    </script>
</@layout.page>