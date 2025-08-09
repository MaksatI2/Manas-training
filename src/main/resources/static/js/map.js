const locationData = {
    latitude: 42.8746,
    longitude: 74.5698,
    address: "RHRG+9W3, ул. Ахунбаева, Бишкек",
    placeName: "Манас Тренинг Центр"
};

function showOnMap() {
    const mapUrls = {
        google: `https://www.google.com/maps/place/${encodeURIComponent(locationData.address)}/@${locationData.latitude},${locationData.longitude},17z`,
        yandex: `https://yandex.ru/maps/?text=${encodeURIComponent(locationData.placeName + " " + locationData.address)}&z=17&ll=${locationData.longitude},${locationData.latitude}`,
        osm: `https://www.openstreetmap.org/?mlat=${locationData.latitude}&mlon=${locationData.longitude}#map=17/${locationData.latitude}/${locationData.longitude}`
    };

    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    const isIOS = /iPhone|iPad|iPod/i.test(navigator.userAgent);

    if (isMobile) {
        if (isIOS) {
            try {
                window.open(`maps://?q=${encodeURIComponent(locationData.address)}&ll=${locationData.latitude},${locationData.longitude}`);
                return;
            } catch (e) {
                console.log("Apple Maps not available");
            }
        }

        if (/Android/i.test(navigator.userAgent)) {
            try {
                window.open(`geo:${locationData.latitude},${locationData.longitude}?q=${encodeURIComponent(locationData.address)}`);
                setTimeout(() => {
                    window.open(mapUrls.google, '_blank');
                }, 500);
                return;
            } catch (e) {
                console.log("Google Maps app not available");
            }
        }

        const useGoogle = confirm(`${locationData.placeName}\n\nОткрыть карту в:\n\nOK - Google Maps\nОтмена - Яндекс.Карты`);
        window.open(useGoogle ? mapUrls.google : mapUrls.yandex, '_blank');
    } else {
        const choice = prompt(
            `${locationData.placeName}\n${locationData.address}\n\nВыберите картографический сервис:\n1 - Google Maps\n2 - Яндекс.Карты\n3 - OpenStreetMap`,
            "1"
        );

        switch(choice) {
            case "2":
                window.open(mapUrls.yandex, '_blank');
                break;
            case "3":
                window.open(mapUrls.osm, '_blank');
                break;
            default:
                window.open(mapUrls.google, '_blank');
        }
    }

    trackMapOpen();
}

function trackMapOpen() {
    if (typeof gtag !== 'undefined') {
        gtag('event', 'map_open', {
            'event_category': 'engagement',
            'event_label': 'address_click'
        });
    }

    if (typeof ym !== 'undefined') {
        ym(XXXXXX, 'reachGoal', 'MAP_OPEN');
    }
}