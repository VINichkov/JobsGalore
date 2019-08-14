(() => {
    stimulus.register("toggle_button_in_header", class extends Stimulus.Controller {

        click() {
            const open = 'open';
            const elem = this.element;
            if (elem.classList.contains('open')){
                elem.classList.remove('open')
            } else{
                elem.classList.add('open')
            }
        }
    })
})();