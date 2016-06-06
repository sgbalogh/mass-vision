// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets

//= require leaflet
//= require leaflet-iiif
//= require_tree .

var uhd_ify_images = function () {
    if (window.devicePixelRatio > 1) {
        var images = document.getElementsByTagName('img');
        for (var i = 0; i < images.length; i++) {
            if (images[i].src.indexOf('iiif') > -1) {
                var start_pos = images[i].src.indexOf('full/') + 5;
                var end_pos = images[i].src.indexOf(',/0/default.jpg');
                var orig_size = images[i].src.substring(start_pos, end_pos);
                var new_size = parseInt(images[i].src.substring(start_pos, end_pos)) * 2;
                images[i].src = images[i].src.replace('full/' + orig_size, 'full/' + new_size.toString());
            }
        }
    }
};

var send_retina_param = function () {
    var uhd;
    if (window.devicePixelRatio > 1) {
        uhd = 'retina=true'
    } else {
        uhd = 'retina=false'
    }
    var links = document.getElementsByTagName('a');
    for (var i = 0; i < links.length; i++) {
		var param_char = '?';
        if (links[i].href.indexOf('?') > -1) {
            param_char = '&';
        }
        links[i].href = links[i].href + param_char + uhd
    }
};
