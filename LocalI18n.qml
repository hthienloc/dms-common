import QtQuick
import qs.Common

QtObject {
    id: root

    // Absolute URL of the plugin directory (must be bound to Qt.resolvedUrl("."))
    property url baseUrl: ""
    property var translations: ({})
    property bool loaded: false

    // Sync with DMS core active locale, falling back to system locale
    readonly property string activeLocale: {
        if (typeof I18n !== "undefined" && I18n._resolvedLocale) {
            return I18n._resolvedLocale;
        }
        return Qt.locale().name.split(/[_-]/)[0]; // e.g. "vi"
    }

    onActiveLocaleChanged: loadTranslations()
    Component.onCompleted: loadTranslations()

    function loadTranslations() {
        if (!baseUrl) return;
        
        let lang = activeLocale.toLowerCase();
        let fileUrl = baseUrl + "/translations/" + lang + ".json";
        
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    try {
                        root.translations = JSON.parse(xhr.responseText);
                        root.loaded = true;
                    } catch (e) {
                        root.translations = {};
                        root.loaded = false;
                    }
                } else {
                    // Fallback to primary language tag if regional code failed (e.g. vi_VN -> vi)
                    if (lang.includes("_") || lang.includes("-")) {
                        let baseLang = lang.split(/[_-]/)[0];
                        let fallbackUrl = baseUrl + "/translations/" + baseLang + ".json";
                        xhr.open("GET", fallbackUrl);
                        xhr.send();
                    } else {
                        root.translations = {};
                        root.loaded = false;
                    }
                }
            }
        }
        xhr.open("GET", fileUrl);
        xhr.send();
    }

    // Translation function
    function tr(term, context) {
        // 1. Try plugin-local translation first
        if (loaded && translations && translations[term]) {
            return translations[term];
        }
        // 2. Fall back to core DMS translation singleton
        if (typeof I18n !== "undefined" && I18n.translationsLoaded) {
            return I18n.tr(term, context);
        }
        // 3. Fall back to original English term
        return term;
    }
}
