jQuery(function($) {
  var form_action = $('#form_name').attr('action');
    
    $('#form_name').submit(function(ev) {
      ev.preventDefault();
      var subject = $('#email_subject').val(),
        body = $('#email_body').val();
      
      window.location.href = form_action + '?subject=' + encodeURIComponent(subject) + '&body=' + encodeURIComponent(body);
    });
});
