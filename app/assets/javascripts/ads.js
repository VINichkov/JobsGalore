(function (G){
    function isRussia() {
        console.log("Вызвали");
        let lang = ['ru', 'ru-RU'];
        let include = function (element) {
            return lang.includes(element);
        }.bind(lang);
        return navigator.languages.some(include) || lang.includes(navigator.language) || lang.includes(navigator.userLanguage);
    };
    G.isRussia = isRussia();
}(this));



