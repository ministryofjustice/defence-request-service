//= require jquery
//= require jasmine-jquery
//= require date_chooser

expectDateValueToEqual = (date, chooserDiv) ->
  expect(chooserDiv.find('.date').val()).toEqual date

dateChooserHtml = (initialDateIndex, dateValue) ->
  $("""
  <body>
  <fieldset class="inline time-select date-chooser">
    <h1>Arrival time</h1>
    <div class="date-field-wrapper">
      <label for="defence_request_solicitor_time_of_arrival_Hour">Hour</label>
      <input size="2" maxlength="2" class="hour text-field" type="text" name="defence_request[solicitor_time_of_arrival][hour]" id="defence_request_solicitor_time_of_arrival_hour" />
    </div>
    <div class="date-field-wrapper">
      <label for="defence_request_solicitor_time_of_arrival_Min">Min</label>
      <input size="2" maxlength="2" class="minute text-field" type="text" name="defence_request[solicitor_time_of_arrival][min]" id="defence_request_solicitor_time_of_arrival_min" />
    </div>
    <div class="date-chooser-values">
      <label class="date-chooser-select form-label js-only" data-initial-date-index="#{ initialDateIndex }">
        <span id="yesterday" class="date-chooser-link" data-date-display="30 April 2015">Yesterday</span>
        <span id="today" class="date-chooser-link" data-date-display="1 May 2015">Today</span>
        <span id="tomorrow" class="date-chooser-link" data-date-display="2 May 2015">Tomorrow</span>
      </label>
      <div class="date-field-wrapper">
        <label for="defence_request_solicitor_time_of_arrival_Date">Date</label>
        <input class="date text-field" value="#{ dateValue }" type="text" name="defence_request[solicitor_time_of_arrival][date]" id="defence_request_solicitor_time_of_arrival_date" />
      </div>
    </div>
  </fieldset>
  </body>
  """)

dateChooserSetup = (element, context) ->
  $(document.body).append(element)

  chooserDivs = $(".date-chooser")
  context.chooserDiv = chooserDivs.eq(0)
  context.chooser = new window.DateChooser(context.chooserDiv)
  context.today = context.chooserDiv.find('#today')
  context.yesterday = context.chooserDiv.find('#yesterday')
  context.tomorrow = context.chooserDiv.find('#tomorrow')

sharedBehaviourForClickingYesterday = (element, context) ->
  describe "clicking 'Yesterday'", ->
    beforeEach ->
      dateChooserSetup(element, context)
      context.yesterday.find('a').click()

    it "changes date values to yesterday's date", ->
      expectDateValueToEqual("30 April 2015", context.chooserDiv)

    it "makes Today a link", ->
      expect(context.today.find('a').size()).toEqual 1

    it "removes link from Yesterday", ->
      expect(context.yesterday.find('a').size()).toEqual 0

sharedBehaviourForClickingYesterdayThenToday = (element, context) ->
  describe "click 'Yesterday' and then click 'Today'", ->
    beforeEach ->
      dateChooserSetup(element, context)
      @yesterday.find('a').click()
      @today.find('a').click()

    it "changes date values to today's date", ->
      expectDateValueToEqual("1 May 2015", @chooserDiv)

    it "makes Yesterday a link", ->
      expect(@yesterday.find('a').size()).toEqual 1

    it "removes link from Today", ->
      expect(@today.find('a').size()).toEqual 0

enablesTodayLink = (element, context) ->
  it "makes Today a link", ->
    dateChooserSetup(element, context)
    expect(context.today.find('a').size()).toEqual 1

enablesYesterday = (element, context) ->
  it "makes Yesterday a link", ->
    dateChooserSetup(element, context)
    expect(@yesterday.find('a').size()).toEqual 1


describe "DateChooser", ->
  element = null

  afterEach ->
    element.remove()
    element = null

  describe "when initial date blank", ->
    beforeEach ->
      element = dateChooserHtml("", "")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTodayLink(element, this)
      enablesYesterday(element, this)

      it "leaves date values unchanged", ->
        expectDateValueToEqual("", @chooserDiv)

    sharedBehaviourForClickingYesterday(element, this)

    sharedBehaviourForClickingYesterday(element, this)

  describe "when initial date not 'today' or 'yesterday'", ->
    beforeEach ->
      element = dateChooserHtml("", "1 Jan 2014")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTodayLink(element, this)
      enablesYesterday(element, this)

      it "leaves date values unchanged", ->
        expectDateValueToEqual("1 Jan 2014", @chooserDiv)

    sharedBehaviourForClickingYesterday(element, this)

    sharedBehaviourForClickingYesterdayThenToday(element, this)

  describe "when initial date 'yesterday'", ->
    beforeEach ->
      element = dateChooserHtml("yesterday", "30 April 2015")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTodayLink(element, this)

      it "does not make Yesterday a link", ->
        expect(@yesterday.find('a').size()).toEqual 0

      it "leaves date values unchanged", ->
        expectDateValueToEqual("30 April 2015", @chooserDiv)

  describe "when initial date 'today'", ->
    beforeEach ->
      element = dateChooserHtml("today", "1 May 2015")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesYesterday(element, this)

      it "does not make Today a link", ->
        expect(@today.find('a').size()).toEqual 0

      it "leaves date values unchanged", ->
        expectDateValueToEqual("1 May 2015", @chooserDiv)

    sharedBehaviourForClickingYesterday(element, this)

    sharedBehaviourForClickingYesterdayThenToday(element, this)
