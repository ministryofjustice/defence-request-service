root = exports ? this

class DateChooser

  constructor: (chooser) ->
    @dateInput = chooser.find(".date-chooser-values").find(".date")

    selectors = chooser.find(".date-chooser-select") # Today/Yesterday selection

    today = selectors.find(".today")
    yesterday = selectors.find(".yesterday")
    initialDate = selectors.data("initial-date")

    @bindOnClickEvents(today, yesterday)
    @initializeLinks(initialDate, today, yesterday)

  bindOnClickEvents: (today, yesterday) =>
    today.on "click", (event) =>
      @toggleDate(today, yesterday)
      event.preventDefault()

    yesterday.on "click", (event) =>
      @toggleDate(yesterday, today)
      event.preventDefault()

  initializeLinks: (initialDate, today, yesterday) =>
    switch initialDate
      when "today"
        @enableLink yesterday
      when "yesterday"
        @enableLink today
      else
        @enableLink today
        @enableLink yesterday

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
