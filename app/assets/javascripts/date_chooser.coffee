root = exports ? this

class DateChooser

  constructor: (chooser) ->
    @dateInput = chooser.find(".date-chooser-values").find ".date"

    selectors = chooser.find ".date-chooser-select"
    @initialDate = chooser.find(".date").val()
    @links = selectors.find ".date-chooser-link"
    @initialDateIndex = selectors.data "initial-date-index"

    @bindOnClickEvents()
    @initializeLinks()

  bindOnClickEvents:  =>
    for link in @links
      $(link).on "click", @createEvent $ link

  createEvent: (link) =>
    (event) =>
      event.preventDefault()
      @toggleDate link

  initializeLinks: =>
    for link, i in @links
      date = $(link).data "date-display"
      if @initialDate is ""
        unless i == @initialDateIndex
          @enableLink $ link
      else
        unless date is @initialDate
          @enableLink $ link


  enableLink: (selector) =>
    selector.html("<a href>" + selector.text() + "</a>")

  toggleDate: (selector) =>
    selector.html selector.text()
    @setDate selector
    @dateInput.focus()
    for link in @links
      @enableLink $(link) unless link == selector[0]

  setDate: (selector) =>
    date = selector.data "date-display"
    @dateInput.val date

root.DateChooser = DateChooser
