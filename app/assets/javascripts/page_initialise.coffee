# Enable any date choosers on page
jQuery ->
  $('.date-chooser').each (index) ->
    new (window.DateChooser)($(this))
  return