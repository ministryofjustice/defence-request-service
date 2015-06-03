root = exports ? this

class TimeTabber

  constructor: (chooser) ->
    date = chooser.find(".date")
    hour = chooser.find(".hour")
    minute = chooser.find(".minute")
    @autoTab(hour, minute)
    @autoTab(minute, date)

    day = chooser.find(".day")
    month = chooser.find(".month")
    year = chooser.find(".year")
    @autoTab(day, month)
    @autoTab(month, year)


  autoTab: (selector, nextSelector) =>
    return if selector.length == 0 || nextSelector.length == 0
    maxlength = parseInt(selector.attr("maxlength"), 10)
    selector.on "keyup", (event) =>
      if selector.val().length == maxlength
        nextSelector.focus()

root.TimeTabber = TimeTabber
