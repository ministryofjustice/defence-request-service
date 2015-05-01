/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

// Module to replace certain pieces of copy with alternatives or remove them entirely if JS is present

moj.Modules.jsAlt = (function() {
  "use strict";

  var init, replaceText;

  init = function() {
    $( '.nonjs' ).each( function() {
      replaceText( $( this ) );
    } );
  };

  replaceText = function( $el ) {
    if( $el.data( 'jsalt' ) ) {
      $el.text( $el.data( 'jsalt' ) );
    } else {
      $el.remove();
    }
  };

  return {
    init: init
  };

}());
