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
//= require jquery_ujs
//= require dsds
//= require date_chooser
//= require govuk/selection-buttons.js
//= require js_alt_text.js

// Prevents MOJ console spam
moj.Modules.devs = {
  init: function() {
  }
};

// Enable any date choosers on page
jQuery(function() {
  $( ".date-chooser" ).each(function( index ) {
    new window.DateChooser($(this));
    console.log( index + ": " + $( this ).text() );
  });
});

