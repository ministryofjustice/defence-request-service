# Enable any date choosers on page
jQuery ->

  $(document).on "drs:init_form_components", (e) ->
    $target = $(e.target)

    $target.find(".date-chooser").each ->
      new window.DateChooser($(this))

    $target.find("form [data-show-when]").each ->
      new window.ShowHide($(this))

    $target.find("form [data-disable-when]").each ->
      new window.DisableChecker($(this))

    $target.find(".time-select").each ->
      new window.TimeTabber($(this))


  $("table tr.clickable-row").each ->
    $(this).addClass("clickable-row-active")
    $(this).on "click", ->
      window.location = $(this).data("link")

  $("body").on "ajax:success", "a[data-remote][data-container], form[data-remote][data-container]", (e, data, status, xhr) ->
    container = $(e.target).data("container")
    $(container).html(data)
    $(container).trigger("drs:init_form_components")

  $("body").trigger("drs:init_form_components")

  return
