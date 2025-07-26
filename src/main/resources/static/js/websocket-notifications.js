var socket = new SockJS('/ws');
var stompClient = Stomp.over(socket);

stompClient.connect({}, function () {
    fetch('/api/notifications/current-user-id')
        .then(response => response.json())
        .then(userId => {
            console.log('userId from server: ', userId);
            if (userId > 0) {
                stompClient.subscribe('/topic/notifications/' + userId, function (message) {
                    let data = JSON.parse(message.body);
                    let notification = data.notification;
                    let unreadCount = data.unreadCount;

                    console.log('WebSocket data:', data);
                    showFlash("info", `${notification.title}: ${notification.body}`);
                    if (notification.link && notification.link.trim() !== '') {
                        setTimeout(() => {
                            const toast = document.querySelector('.toast:last-of-type');
                            if (toast) {
                                toast.style.cursor = 'pointer';
                                toast.addEventListener('click', () => {
                                    window.location.href = notification.link;
                                });
                            }
                        }, 100);
                    }

                    updateNotificationCounter(unreadCount);
                });
            }
        });
});

function updateNotificationCounter(count) {
    const countElements = [
        document.getElementById('notificationCount'),
        document.getElementById('notificationCountHeader'),
        document.getElementById('notificationCountStudent')
    ];

    countElements.forEach(countElement => {
        if (countElement) {
            if (count > 0) {
                countElement.style.display = 'inline-block';
                countElement.textContent = count;
            } else {
                countElement.style.display = 'none';
            }
        }
    });
}

function updateNotificationCount() {
    fetch('/api/notifications/unread-count')
        .then(response => response.json())
        .then(count => {
            updateNotificationCounter(count);
        });
}

document.addEventListener('DOMContentLoaded', function () {
    updateNotificationCount();
});
