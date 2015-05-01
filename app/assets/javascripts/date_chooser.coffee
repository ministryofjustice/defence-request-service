root = exports ? this

class DateChooser

  constructor: (chooser) ->
    @chooser = chooser
    selectors = chooser.find(".date-select") # Today/Tomorrow selection
    @dateDisplay = chooser.find(".date-display")
    @values = chooser.find(".date-values")
    @today = selectors.find(".today")
    @tomorrow = selectors.find(".tomorrow")

    @enableLink @tomorrow, @today

  enableLink: (selector, otherSelector) =>
    selector.html( "<a href>" + selector.text() + "</a>" )
    selector.on 'click', (event) =>
      @toggleDate( selector, otherSelector )
      event.preventDefault()

  toggleDate: (selector, otherSelector) =>
    selector.html( selector.text() )
    @setDate selector
    @enableLink otherSelector, selector

  setDate: (selector) =>
    day = selector.data('day')
    month = selector.data('month')
    year = selector.data('year')
    display = selector.data('date-display')
    @values.find('.day').eq(0).val(day)
    @values.find('.month').eq(0).val(month)
    @values.find('.year').eq(0).val(year)
    @dateDisplay.text(display)

root.DateChooser = DateChooser
