//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require social-share-button
//=require jasny-bootstrap
//=require medium-editor.min
//=require datalist-polyfill.min
//= require react
//= require components
//= require react_ujs
//*require npm-pdfreader-master/PdfReader

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
    var markDownEl = $(".markdown")[0],
        elements = $('.editable')[0],
        editor = new MediumEditor(elements, {
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
                buttons: ['bold', 'italic', 'underline', 'anchor', 'h3' ,'h4' , 'orderedlist', 'unorderedlist'],
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
    editor.subscribe('editableInput', function (event, editable) {
        markDownEl.textContent = editable.innerHTML;
    });

    $("#inp").change(function() {
        readURL(this);
    });

    var uploadTXT = function(uploadFile) {
        let reader = new FileReader();
        reader.onload = function (e) {
            let html = e.target.result;
            html = html.replace(new RegExp('<','g'), "&lt;");
            html = html.replace(new RegExp('>','g'), "&gt;");
            editor.setContent(html,0);
            markDownEl.innerHTML = html;
        };
        reader.readAsText(uploadFile);
    };

    function readURL(input) {
        if (input.files) {
            let uploadFile = input.files[0];
            console.log(uploadFile);
            switch(uploadFile.type){
                case 'text/plain':
                    uploadTXT(uploadFile);
                    break;
                default:
                    fd = new FormData;
                    fd.append('file', uploadFile);
                    $.ajax({
                        type: 'POST',
                        url: "http://0.0.0.0:3000/file_to_html",
                        data: fd,
                        success: function( data ) {
                            editor.setContent(data.description,0);
                        },
                        contentType: false,
                        processData: false
                    });
            }
        }
    }

    $(".linkedin_click").click( function () {
        $.get('https://www.jobsgalore.eu/linkedin_resume_update', function(data) {
            $("[name='resume[title]']").val(data.title);
            editor.setContent(data.description,0);
            $("[name='resume[industry_id]']").val(data.industry_id);
        });
    });

});