(function() {
    'use strict';

    const EVENTS = {
        API_READY: 'apiReady',
        AVATAR_CHANGED: 'avatarChanged',
        AUDIO_AVAILABILITY_CHANGED: 'audioAvailabilityChanged',
        AUDIO_MUTE_STATUS_CHANGED: 'audioMuteStatusChanged',
        CAMERA_ERROR: 'cameraError',
        DEVICE_LIST_CHANGED: 'deviceListChanged',
        DISPLAY_NAME_CHANGE: 'displayNameChange',
        DOMINANT_SPEAKER_CHANGED: 'dominantSpeakerChanged',
        EMAIL_CHANGE: 'emailChange',
        ENDPOINT_TEXT_MESSAGE_RECEIVED: 'endpointTextMessageReceived',
        ERROR: 'error',
        FEEDBACK_SUBMITTED: 'feedbackSubmitted',
        FILMSTRIP_DISPLAY_CHANGED: 'filmstripDisplayChanged',
        INCOMING_MESSAGE: 'incomingMessage',
        LARGE_VIDEO_CHANGED: 'largeVideoChanged',
        LOG: 'log',
        MIC_ERROR: 'micError',
        OUTGOING_MESSAGE: 'outgoingMessage',
        PARTICIPANT_JOINED: 'participantJoined',
        PARTICIPANT_LEFT: 'participantLeft',
        PARTICIPANT_ROLE_CHANGED: 'participantRoleChanged',
        PASSWORD_REQUIRED: 'passwordRequired',
        PROXY_CONNECTION_EVENT: 'proxyConnectionEvent',
        RECORDING_LINK_AVAILABLE: 'recordingLinkAvailable',
        RECORDING_STATUS_CHANGED: 'recordingStatusChanged',
        SUBJECT_CHANGE: 'subjectChange',
        TILE_VIEW_CHANGED: 'tileViewChanged',
        VIDEO_AVAILABILITY_CHANGED: 'videoAvailabilityChanged',
        VIDEO_CONFERENCE_JOINED: 'videoConferenceJoined',
        VIDEO_CONFERENCE_LEFT: 'videoConferenceLeft',
        VIDEO_MUTE_STATUS_CHANGED: 'videoMuteStatusChanged',
        VIDEO_QUALITY_CHANGED: 'videoQualityChanged',
        CONNECTION_FAILED: 'connectionFailed',
        CONFERENCE_ERROR: 'conferenceError',
        VIDEO_CONFERENCE_ERROR: 'videoConferenceError',
        READY_TO_CLOSE: 'readyToClose'
    };

    const COMMANDS = {
        DISPLAY_NAME: 'displayName',
        PASSWORD: 'password',
        SEND_ENDPOINT_TEXT_MESSAGE: 'sendEndpointTextMessage',
        SEND_CHAT_MESSAGE: 'sendChatMessage',
        SET_LARGE_VIDEO_PARTICIPANT: 'setLargeVideoParticipant',
        SET_VIDEO_QUALITY: 'setVideoQuality',
        MUTE_AUDIO: 'muteAudio',
        UNMUTE_AUDIO: 'unmuteAudio',
        MUTE_VIDEO: 'muteVideo',
        UNMUTE_VIDEO: 'unmuteVideo',
        FILM_STRIP: 'filmStrip',
        SUBMIT_FEEDBACK: 'submitFeedback',
        TOGGLE_AUDIO: 'toggleAudio',
        TOGGLE_VIDEO: 'toggleVideo',
        TOGGLE_FILM_STRIP: 'toggleFilmStrip',
        TOGGLE_CHAT: 'toggleChat',
        TOGGLE_SHARE_SCREEN: 'toggleShareScreen',
        TOGGLE_TILE_VIEW: 'toggleTileView',
        HANG_UP: 'hangup',
        EMAIL: 'email',
        AVATAR_URL: 'avatarUrl',
        RESIZE_FILM_STRIP: 'resizeFilmStrip'
    };

    function JitsiMeetExternalAPI(domain, options = {}) {
        this.domain = domain;
        this.roomName = options.roomName || 'JitsiMeetAPIExample';
        this.width = options.width || 700;
        this.height = options.height || 700;
        this.parentNode = options.parentNode || document.body;
        this.configOverwrite = options.configOverwrite || {};
        this.interfaceConfigOverwrite = options.interfaceConfigOverwrite || {};
        this.userInfo = options.userInfo || {};
        this.jwt = options.jwt || null;
        this.lang = options.lang || 'en';
        this.devices = options.devices || {};
        this.onload = options.onload || null;

        this.iframe = null;
        this.eventHandlers = {};
        this.isReady = false;
        this.participantCount = 0;
        this.participants = {};

        this.initialize();
    }

    JitsiMeetExternalAPI.prototype.initialize = function() {
        this.createIframe();
        this.setupEventListeners();
        this.setupMessageHandling();
    };

    JitsiMeetExternalAPI.prototype.createIframe = function() {
        this.iframe = document.createElement('iframe');
        this.iframe.style.width = this.width + (typeof this.width === 'number' ? 'px' : '');
        this.iframe.style.height = this.height + (typeof this.height === 'number' ? 'px' : '');
        this.iframe.style.border = '0';
        this.iframe.setAttribute('allow', 'camera; microphone; display-capture; fullscreen; clipboard-read; clipboard-write; autoplay');

        const url = this.buildUrl();
        console.log('JitsiMeetExternalAPI: Creating iframe with URL:', url);
        this.iframe.src = url;

        this.parentNode.appendChild(this.iframe);
    };

    JitsiMeetExternalAPI.prototype.buildUrl = function() {
        const protocol = location.protocol;
        let url = `${protocol}//${this.domain}/meet/${this.roomName}`;

        const params = new URLSearchParams();

        if (this.jwt) {
            params.append('jwt', this.jwt);
        }

        if (this.lang) {
            params.append('lang', this.lang);
        }

        if (this.userInfo.displayName) {
            params.append('displayName', this.userInfo.displayName);
        }

        if (this.userInfo.email) {
            params.append('email', this.userInfo.email);
        }

        if (Object.keys(this.configOverwrite).length > 0) {
            if (this.configOverwrite.startWithAudioMuted !== undefined) {
                params.append('config.startWithAudioMuted', this.configOverwrite.startWithAudioMuted);
            }
            if (this.configOverwrite.startWithVideoMuted !== undefined) {
                params.append('config.startWithVideoMuted', this.configOverwrite.startWithVideoMuted);
            }
            if (this.configOverwrite.prejoinPageEnabled !== undefined) {
                params.append('config.prejoinPageEnabled', this.configOverwrite.prejoinPageEnabled);
            }
            if (this.configOverwrite.defaultLanguage) {
                params.append('config.defaultLanguage', this.configOverwrite.defaultLanguage);
            }
        }

        if (Object.keys(this.interfaceConfigOverwrite).length > 0) {
            if (this.interfaceConfigOverwrite.SHOW_JITSI_WATERMARK !== undefined) {
                params.append('interfaceConfig.SHOW_JITSI_WATERMARK', this.interfaceConfigOverwrite.SHOW_JITSI_WATERMARK);
            }
            if (this.interfaceConfigOverwrite.SHOW_WATERMARK_FOR_GUESTS !== undefined) {
                params.append('interfaceConfig.SHOW_WATERMARK_FOR_GUESTS', this.interfaceConfigOverwrite.SHOW_WATERMARK_FOR_GUESTS);
            }
        }

        if (this.devices.audioInput) {
            params.append('audioInput', this.devices.audioInput);
        }
        if (this.devices.audioOutput) {
            params.append('audioOutput', this.devices.audioOutput);
        }
        if (this.devices.videoInput) {
            params.append('videoInput', this.devices.videoInput);
        }

        const paramString = params.toString();
        if (paramString) {
            url += `?${paramString}`;
        }

        return url;
    };

    JitsiMeetExternalAPI.prototype.setupEventListeners = function() {
        const self = this;

        this.iframe.addEventListener('load', function() {
            console.log('JitsiMeetExternalAPI: Iframe loaded successfully');
            self.isReady = true;
            self.triggerEvent(EVENTS.API_READY);

            if (self.onload) {
                self.onload();
            }
        });

        this.iframe.addEventListener('error', function(error) {
            console.error('JitsiMeetExternalAPI: Iframe load error:', error);
            self.triggerEvent(EVENTS.ERROR, { error: 'Failed to load Jitsi Meet' });
        });
    };

    JitsiMeetExternalAPI.prototype.setupMessageHandling = function() {
        const self = this;

        window.addEventListener('message', function(event) {
            const expectedOrigin = `${location.protocol}//${self.domain}`;
            if (event.origin !== expectedOrigin && !event.origin.includes(self.domain)) {
                return;
            }

            const data = event.data;
            if (!data || !data.type) {
                return;
            }

            self.handleMessage(data);
        });

        setTimeout(function() {
            if (self.iframe && self.iframe.contentWindow) {
                self.sendMessage({
                    type: 'init',
                    parentOrigin: location.origin
                });
            }
        }, 2000);
    };

    JitsiMeetExternalAPI.prototype.handleMessage = function(data) {
        console.log('JitsiMeetExternalAPI: Received message:', data.type, data.payload);

        switch (data.type) {
            case 'videoConferenceJoined':
                this.triggerEvent(EVENTS.VIDEO_CONFERENCE_JOINED, data.payload);
                break;
            case 'videoConferenceLeft':
                this.triggerEvent(EVENTS.VIDEO_CONFERENCE_LEFT, data.payload);
                break;
            case 'participantJoined':
                if (data.payload && data.payload.id) {
                    this.participants[data.payload.id] = data.payload;
                    this.participantCount++;
                }
                this.triggerEvent(EVENTS.PARTICIPANT_JOINED, data.payload);
                break;
            case 'participantLeft':
                if (data.payload && data.payload.id && this.participants[data.payload.id]) {
                    delete this.participants[data.payload.id];
                    this.participantCount--;
                }
                this.triggerEvent(EVENTS.PARTICIPANT_LEFT, data.payload);
                break;
            case 'displayNameChange':
                this.triggerEvent(EVENTS.DISPLAY_NAME_CHANGE, data.payload);
                break;
            case 'incomingMessage':
                this.triggerEvent(EVENTS.INCOMING_MESSAGE, data.payload);
                break;
            case 'outgoingMessage':
                this.triggerEvent(EVENTS.OUTGOING_MESSAGE, data.payload);
                break;
            case 'audioMuteStatusChanged':
                this.triggerEvent(EVENTS.AUDIO_MUTE_STATUS_CHANGED, data.payload);
                break;
            case 'videoMuteStatusChanged':
                this.triggerEvent(EVENTS.VIDEO_MUTE_STATUS_CHANGED, data.payload);
                break;
            case 'connectionFailed':
                this.triggerEvent(EVENTS.CONNECTION_FAILED, data.payload);
                break;
            case 'conferenceError':
                this.triggerEvent(EVENTS.CONFERENCE_ERROR, data.payload);
                break;
            case 'videoConferenceError':
                this.triggerEvent(EVENTS.VIDEO_CONFERENCE_ERROR, data.payload);
                break;
            case 'readyToClose':
                this.triggerEvent(EVENTS.READY_TO_CLOSE, data.payload);
                break;
            case 'error':
                this.triggerEvent(EVENTS.ERROR, data.payload);
                break;
            default:
                if (Object.values(EVENTS).includes(data.type)) {
                    this.triggerEvent(data.type, data.payload);
                }
                break;
        }
    };

    JitsiMeetExternalAPI.prototype.sendMessage = function(message) {
        if (this.iframe && this.iframe.contentWindow) {
            const targetOrigin = `${location.protocol}//${this.domain}`;
            this.iframe.contentWindow.postMessage(message, targetOrigin);
        }
    };

    JitsiMeetExternalAPI.prototype.executeCommand = function(command, ...args) {
        this.sendMessage({
            type: 'command',
            command: command,
            args: args
        });
    };

    JitsiMeetExternalAPI.prototype.addEventListener = function(event, handler) {
        if (!this.eventHandlers[event]) {
            this.eventHandlers[event] = [];
        }
        this.eventHandlers[event].push(handler);
    };

    JitsiMeetExternalAPI.prototype.removeEventListener = function(event, handler) {
        if (this.eventHandlers[event]) {
            const index = this.eventHandlers[event].indexOf(handler);
            if (index > -1) {
                this.eventHandlers[event].splice(index, 1);
            }
        }
    };

    JitsiMeetExternalAPI.prototype.triggerEvent = function(event, data) {
        console.log('JitsiMeetExternalAPI: Triggering event:', event, data);

        if (this.eventHandlers[event]) {
            this.eventHandlers[event].forEach(handler => {
                try {
                    handler(data);
                } catch (error) {
                    console.error('Error in event handler for', event, ':', error);
                }
            });
        }
    };

    JitsiMeetExternalAPI.prototype.getNumberOfParticipants = function() {
        return this.participantCount;
    };

    JitsiMeetExternalAPI.prototype.getAvatarURL = function(participantId) {
        const participant = this.participants[participantId];
        return participant ? participant.avatarURL : null;
    };

    JitsiMeetExternalAPI.prototype.getDisplayName = function(participantId) {
        const participant = this.participants[participantId];
        return participant ? participant.displayName : null;
    };

    JitsiMeetExternalAPI.prototype.getEmail = function(participantId) {
        const participant = this.participants[participantId];
        return participant ? participant.email : null;
    };

    JitsiMeetExternalAPI.prototype.getIFrame = function() {
        return this.iframe;
    };

    JitsiMeetExternalAPI.prototype.isAudioMuted = function() {
        return new Promise((resolve) => {
            this.sendMessage({
                type: 'getAudioMuted',
                callback: resolve
            });
        });
    };

    JitsiMeetExternalAPI.prototype.isVideoMuted = function() {
        return new Promise((resolve) => {
            this.sendMessage({
                type: 'getVideoMuted',
                callback: resolve
            });
        });
    };

    JitsiMeetExternalAPI.prototype.dispose = function() {
        console.log('JitsiMeetExternalAPI: Disposing API');

        if (this.iframe && this.iframe.parentNode) {
            this.iframe.parentNode.removeChild(this.iframe);
        }
        this.eventHandlers = {};
        this.participants = {};
        this.participantCount = 0;
        this.isReady = false;
    };

    JitsiMeetExternalAPI.prototype.executeCommands = function(commands) {
        commands.forEach(command => {
            this.executeCommand(command.name, ...command.args);
        });
    };

    JitsiMeetExternalAPI.prototype.setDisplayName = function(displayName) {
        this.executeCommand(COMMANDS.DISPLAY_NAME, displayName);
    };

    JitsiMeetExternalAPI.prototype.setEmail = function(email) {
        this.executeCommand(COMMANDS.EMAIL, email);
    };

    JitsiMeetExternalAPI.prototype.setAvatarUrl = function(avatarUrl) {
        this.executeCommand(COMMANDS.AVATAR_URL, avatarUrl);
    };

    JitsiMeetExternalAPI.prototype.sendChatMessage = function(message) {
        this.executeCommand(COMMANDS.SEND_CHAT_MESSAGE, message);
    };

    JitsiMeetExternalAPI.prototype.toggleAudio = function() {
        this.executeCommand(COMMANDS.TOGGLE_AUDIO);
    };

    JitsiMeetExternalAPI.prototype.toggleVideo = function() {
        this.executeCommand(COMMANDS.TOGGLE_VIDEO);
    };

    JitsiMeetExternalAPI.prototype.toggleFilmStrip = function() {
        this.executeCommand(COMMANDS.TOGGLE_FILM_STRIP);
    };

    JitsiMeetExternalAPI.prototype.toggleChat = function() {
        this.executeCommand(COMMANDS.TOGGLE_CHAT);
    };

    JitsiMeetExternalAPI.prototype.toggleShareScreen = function() {
        this.executeCommand(COMMANDS.TOGGLE_SHARE_SCREEN);
    };

    JitsiMeetExternalAPI.prototype.toggleTileView = function() {
        this.executeCommand(COMMANDS.TOGGLE_TILE_VIEW);
    };

    JitsiMeetExternalAPI.prototype.hangup = function() {
        this.executeCommand(COMMANDS.HANG_UP);
    };

    JitsiMeetExternalAPI.prototype.muteAudio = function() {
        this.executeCommand(COMMANDS.MUTE_AUDIO);
    };

    JitsiMeetExternalAPI.prototype.unmuteAudio = function() {
        this.executeCommand(COMMANDS.UNMUTE_AUDIO);
    };

    JitsiMeetExternalAPI.prototype.muteVideo = function() {
        this.executeCommand(COMMANDS.MUTE_VIDEO);
    };

    JitsiMeetExternalAPI.prototype.unmuteVideo = function() {
        this.executeCommand(COMMANDS.UNMUTE_VIDEO);
    };

    JitsiMeetExternalAPI.prototype.resizeFilmStrip = function() {
        this.executeCommand(COMMANDS.RESIZE_FILM_STRIP);
    };

    window.JitsiMeetExternalAPI = JitsiMeetExternalAPI;
    window.JitsiMeetExternalAPI.events = EVENTS;
    window.JitsiMeetExternalAPI.commands = COMMANDS;

    console.log('JitsiMeetExternalAPI: API loaded and ready');

})();