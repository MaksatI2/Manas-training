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
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-lg border-0 rounded-3">
                    <div class="card-header bg-primary text-white text-center py-4">
                        <h2 class="mb-0 fw-bold">
                            <i class="fas fa-video me-2"></i>
                            <@spring.message code="meeting.start.title"/>
                        </h2>
                    </div>
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <div class="meeting-icon mb-3">
                                <i class="fas fa-chalkboard-teacher display-1 text-primary"></i>
                            </div>
                            <h4 class="fw-semibold text-dark mb-3"><@spring.message code="meeting.start.ready"/></h4>
                            <p class="text-muted"><@spring.message code="meeting.start.checkDevices"/></p>
                        </div>

                        <div class="pre-meeting-checks mb-4">
                            <h6 class="fw-semibold mb-3"><@spring.message code="meeting.start.equipmentCheck"/></h6>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="check-item p-3 border rounded-3 bg-light">
                                        <i class="fas fa-video text-primary me-2"></i>
                                        <span><@spring.message code="meeting.start.camera"/></span>
                                        <div class="form-check form-switch float-end">
                                            <input class="form-check-input" type="checkbox" id="cameraCheck" checked>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="check-item p-3 border rounded-3 bg-light">
                                        <i class="fas fa-microphone text-primary me-2"></i>
                                        <span><@spring.message code="meeting.start.microphone"/></span>
                                        <div class="form-check form-switch float-end">
                                            <input class="form-check-input" type="checkbox" id="micCheck" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="meeting-info mb-4">
                            <h6 class="fw-semibold mb-3"><@spring.message code="meeting.start.meetingInfo"/></h6>
                            <div class="info-box p-3 bg-light rounded-3">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <small class="text-muted"><@spring.message code="meeting.start.scheduleId"/></small>
                                        <div class="fw-semibold">${scheduleId}</div>
                                    </div>
                                    <div class="col-sm-6">
                                        <small class="text-muted"><@spring.message code="meeting.start.teacher"/></small>
                                        <div class="fw-semibold">${name}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button id="startMeetingBtn" class="btn btn-success btn-lg rounded-pill py-3">
                                <i class="fas fa-play me-2"></i>
                                <@spring.message code="meeting.start.startButton"/>
                            </button>
                            <a href="<@spring.url '/schedules'/>" class="btn btn-outline-secondary rounded-pill">
                                <i class="fas fa-arrow-left me-2"></i>
                                <@spring.message code="meeting.start.backToSchedule"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .card {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95);
        }

        .card-header {
            background: linear-gradient(135deg, #007bff, #0056b3) !important;
            border-radius: 0.5rem 0.5rem 0 0 !important;
        }

        .meeting-icon {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }

        .check-item {
            transition: all 0.3s ease;
        }

        .check-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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

        .btn-outline-secondary {
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            transform: translateY(-2px);
        }

        .info-box {
            border-left: 4px solid #007bff;
        }

        .form-check-input:checked {
            background-color: #28a745;
            border-color: #28a745;
        }
    </style>

    <script>
        document.getElementById('startMeetingBtn').addEventListener('click', function () {
            const btn = this;
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i><@spring.message code="meeting.start.creatingMeeting"/>';

            fetch('/api/jitsi/meetings/start', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
                },
                body: JSON.stringify({
                    scheduleId: ${scheduleId},
                    teacherId: ${teacherId},
                    meetingName: 'Урок - ' + new Date().toLocaleString()
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.meetingId) {
                        window.location.href = `/jitsi/meeting/` + data.meetingId + `/join?userId=${teacherId}&userRole=TEACHER`;
                    } else {
                        throw new Error('<@spring.message code="meeting.start.error.create"/>');
                    }
                })
                .catch(error => {
                    console.error('Ошибка:', error);
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-play me-2"></i><@spring.message code="meeting.start.startButton"/>';
                    alert('<@spring.message code="meeting.start.error.general"/>');
                });
        });

        document.addEventListener('DOMContentLoaded', function () {
            navigator.mediaDevices.getUserMedia({video: true, audio: true})
                .then(stream => {
                    stream.getTracks().forEach(track => track.stop());
                    console.log('Камера и микрофон доступны');
                })
                .catch(error => {
                    console.warn('Проблема с доступом к устройствам:', error);
                    document.getElementById('cameraCheck').checked = false;
                    document.getElementById('micCheck').checked = false;

                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-warning mt-3';
                    alertDiv.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i><@spring.message code="meeting.start.deviceError"/>';
                    document.querySelector('.pre-meeting-checks').appendChild(alertDiv);
                });
        });
    </script>
</@layout.page>
