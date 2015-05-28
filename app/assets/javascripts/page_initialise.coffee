# Enable any date choosers on page
jQuery ->
  $(".date-chooser").each ->
    new window.DateChooser($(this))

  $("[data-show-when]").each ->
    new window.ShowHide($(this))

  return