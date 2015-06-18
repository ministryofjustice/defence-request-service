(function () {
  'use strict';

  moj.Modules.LabelSelect = {
    el: 'fieldset.radio',

    init: function() {
      this.cacheEls();
      this.bindEvents();

      this.render();
    },

    cacheEls: function() {
      this.$options = $(this.el).find('input[type=radio], input[type=checkbox]');
    },

    bindEvents: function() {
      this.$options
        .on('change label-select', function () {
          var $el = $(this),
              $parent = $el.parent('label');

          // clear out all other selections on radio elements
          if ($el.attr('type') === 'radio') {
            $('[name="' + $el.attr('name') + '"]').parent('label').removeClass('s-selected');
          }

          // set s-selected state on check
          if($el.is(':checked')) {
            $parent.addClass('s-selected').focus();
          } else {
            $parent.removeClass('s-selected');
          }
        });
    },

    render: function() {
      this.$options.filter(':checked').each(function(){
        $(this).parent().addClass('s-selected');
      });
    }
  };
}());
