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
    var uploadDOCX = function(uploadFile) {
        var zip = new JSZip().loadAsync(uploadFile);
        console.log(zip.file('document.xml').async('string'));
        /*
        zip.loadAsync(uploadFile).then(function (f) {
            f.forEach(function (relativePath, zipEntry) {
                if (relativePath == "word/document.xml") {
                    console.log(zipEntry.as);
                    console.log('Зашли1');
                    console.log(zip.file(relativePath));
                    zip.file(relativePath).async('text').then(function(content) {
                        console.log('Зашли');
                        console.log(content);
                    });
                }
            });
        });
        */
        //JSZip.loadAsync(uploadFile).then(function(f) {
        //   zip = f;
        //});

        //let text= doc.getFullText();
        //console.log(text);
    };

    var uploadPDF = function(uploadFile) {
        let zip = new JSZip.loadAsync(uploadFile);
        console.log(zip);
        let doc= new Docxtemplater().loadZip(uploadFile);
        console.log(doc);
        let text= doc.getFullText();
        console.log(text);
    };

    function readURL(input) {
        if (input.files) {
            let uploadFile = input.files[0];
            console.log(uploadFile);
            switch(uploadFile.type){
                case 'text/plain':
                    uploadTXT(uploadFile);
                    break;
                case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
                    uploadDOCX(uploadFile);
                    break;
                case   'application/pdf' :
                    uploadPDF(uploadFile);
                    break;
                default:
                    console.log("другой тип")
            }

            //let reader = new FileReader();
            //reader.onload = uploadTXT;
            //reader.rea
            //reader.readAsText(input.files[0]);
        }
    }


});