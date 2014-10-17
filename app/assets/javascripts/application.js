// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require twitter/bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require locales/bootstrap-datetimepicker.ru.js
//= require turbolinks
//= require_tree .

function online(){
  $("input#route-form").trigger("click");
  setTimeout(online, 10000);
}

var olmap = new OLMap();
function drawPath()
{
  var ccc = '{"data":'+$("#map").attr('points')+"}";
var coords = (JSON.parse(ccc)).data;
// var coords = [{lat:56.2, lon:38.5},{lat:55.5, lon:38}];
 var coords2 = [{lat:55, lon:37},{lat:56, lon:38},{lat:55, lon:37},{lat:56, lon:38},{lat:55, lon:37},{lat:56, lon:38},{lat:55, lon:37},{lat:56, lon:38},{lat:55, lon:37},{lat:56, lon:38},{lat:55, lon:37},{lat:56, lon:38},{lat:56.1, lon:38.5}];
 //console.log(coords);
 $('.total_way').html(olmap.drawPath(coords));
//alert(olmap.drawPath(coords));
}

function continuePathExample()
{
 var coords = [{lat:56.2, lon:38.5},{lat:55.5, lon:38}];
  //alert(olmap.continuePath(coords));
  $('.total_way').html(olmap.drawPath(coords));
}


$(document).ready(function(){
  olmap.init('map');
  drawPath();
    $(document).on("click", "input.datetime", function(){
        $(this).datetimepicker({
            language: 'ru'

        });
        $(this).trigger('focus');
    });



    $("input#is_online").on("click", function(){
       console.log("click!")
       if($(this).prop('checked')) {
           console.log("checked!")
           $("#date_to").attr('disabled', true);
           online();
       }else{
           console.log("unchecked!")
            $("#date_to").removeAttr('disabled');
       }
    });
});

