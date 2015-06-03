root = exports ? this

class DateChooser

  constructor: (chooser) ->
    @dateInput = chooser.find(".date-chooser-values").find(".date")

    selectors = chooser.find(".date-chooser-select") # Today/Tomorrow selection

    today = selectors.find(".today")
    tomorrow = selectors.find(".tomorrow")
    initialDate = selectors.data("initial-date")

    @bindOnClickEvents(today, tomorrow)
    @initializeLinks(initialDate, today, tomorrow)

  bindOnClickEvents: (today, tomorrow) =>
    today.on "click", (event) =>
      @toggleDate(today, tomorrow)
      event.preventDefault()

    tomorrow.on "click", (event) =>
      @toggleDate(tomorrow, today)
      event.preventDefault()

  initializeLinks: (initialDate, today, tomorrow) =>
    switch initialDate
      when "today"
        @enableLink tomorrow
      when "tomorrow"
        @enableLink today
      else
        @enableLink today
        @enableLink tomorrow

  enableLink: (selector) =>
    selector.html("<a href>" + selector.text() + "</a>")

  toggleDate: (selector, otherSelector) =>
    selector.html(selector.text())
    @setDate selector
    @dateInput.focus()
    @enableLink otherSelector

  setDate: (selector) =>
    date = selector.data("date-display")
    @dateInput.val(date)

root.DateChooser = DateChooser
