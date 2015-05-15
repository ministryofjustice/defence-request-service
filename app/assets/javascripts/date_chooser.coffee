root = exports ? this

class DateChooser

  constructor: (chooser) ->
    @dateDisplay = chooser.find(".date-chooser-display")
    @values = chooser.find(".date-chooser-values")
    @dayInput = chooser.find(".day")

    selectors = chooser.find(".date-chooser-select") # Today/Tomorrow selection
    today = selectors.find(".today")
    tomorrow = selectors.find(".tomorrow")
    initialDate = selectors.data("initial-date")
    @bindOnClickEvents(today, tomorrow)
    @initializeLinks(initialDate, today, tomorrow)

  bindOnClickEvents: (today, tomorrow) =>
    today.on "click", (event) =>
      @toggleDate( today, tomorrow )
      event.preventDefault()

    tomorrow.on "click", (event) =>
      @toggleDate( tomorrow, today )
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
    selector.html( "<a href>" + selector.text() + "</a>" )

  toggleDate: (selector, otherSelector) =>
    selector.html( selector.text() )
    @setDate selector
    @enableLink otherSelector
    @dayInput.focus()

  setDate: (selector) =>
    day = selector.data("day")
    month = selector.data("month")
    year = selector.data("year")
    display = selector.data("date-display")
    @values.find(".day").eq(0).val(day)
    @values.find(".month").eq(0).val(month)
    @values.find(".year").eq(0).val(year)
    @dateDisplay.text(display)

root.DateChooser = DateChooser
