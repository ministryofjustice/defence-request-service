# Enable any date choosers on page
jQuery ->
  $(".date-chooser").each ->
    new window.DateChooser($(this))

  $("form [data-show-when]").each ->
    new window.ShowHide($(this))

  $("form [data-disable-when]").each ->
    new window.DisableChecker($(this))

  $("table tr.clickable-row").each ->
    $(this).addClass("clickable-row-active")
    $(this).on "click", ->
      window.location = $(this).data("link")

  $(".time-select").each ->
    new window.TimeTabber($(this))

  return
