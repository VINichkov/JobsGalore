
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require social-share-button
//=require jasny-bootstrap
//=require medium-editor.min
//=require me-markdown.standalone.min
//=require datalist-polyfill.min
//= require react
//= require components
//= require react_ujs

//$(document).on('page:load', function () {
//    ReactRailsUJS.mountComponents()
//});
//$(document).on('page:render', function () {
//    ReactRailsUJS.mountComponents()
//});
//$(document).on('page:before-render', function () {
//    ReactRailsUJS.unmountComponents()
//});

$(function() {
    $('.datepicker_reg').datepicker({
        orientation: "bottom auto",
        language: "en-AU",
        autoclose: true
    });
    var markDownEl = document.querySelector(".markdown"),
        elements = document.querySelectorAll('.editable'),
        editor = new MediumEditor(elements, {
            extensions: {
                markdown: new MeMarkdown(function (md) {
                    markDownEl.textContent = md;
                })
            },
            placeholder: {
                /* This example includes the default options for placeholder,
                   if nothing is passed this is what it used */
                text: 'Type your text here',
                hideOnClick: true
            },
            toolbar: {
                /* These are the default options for the toolbar,
                   if nothing is passed this is what is used */
                allowMultiParagraphSelection: true,
                buttons: ['bold', 'italic', 'underline', 'anchor', 'h4', 'orderedlist', 'unorderedlist'],
                diffLeft: 0,
                diffTop: -10,
                firstButtonClass: 'medium-editor-button-first',
                lastButtonClass: 'medium-editor-button-last',
                relativeContainer: null,
                standardizeSelectionStart: false,
                static: false,
                /* options which only apply when static is true */
                align: 'center',
                sticky: false,
                updateOnEmptySelection: false
            }
        });
});