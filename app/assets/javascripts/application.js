//= require react
//= require components
//= require jquery
//= require jquery_ujs
//= require react_ujs

//= require bootstrap
//= require social-share-button
//= require social-share-button/wechat
//= require bootstrap-datepicker
//=require bootstrap-select
//=require bootstrap-markdown
//=require markdown
//=require jasny-bootstrap

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
});