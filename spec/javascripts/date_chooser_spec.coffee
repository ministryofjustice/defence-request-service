//= require jquery
//= require jasmine-jquery
//= require date_chooser

expectDateValuesToEqual = (day, month, year, chooserDiv) ->
  expect(chooserDiv.find('.day').eq(0).val()).toEqual day
  expect(chooserDiv.find('.month').eq(0).val()).toEqual month
  expect(chooserDiv.find('.year').eq(0).val()).toEqual year

dateChooserHtml = (initialDate, dayValue, monthValue, yearValue) ->
  $("""
  <body>
  <fieldset class="inline time-select date-chooser">
    <h1>Arrival time</h1>
    <div class="date-field-wrapper">
      <label for="defence_request_solicitor_time_of_arrival_Hour">Hour</label>
      <input size="2" placeholder="HH" class="hour text-field" type="text" name="defence_request[solicitor_time_of_arrival][hour]" id="defence_request_solicitor_time_of_arrival_hour" />
    </div>
    <div class="date-field-wrapper">
      <label for="defence_request_solicitor_time_of_arrival_Min">Min</label>
      <input size="2" placeholder="MM" class="minute text-field" type="text" name="defence_request[solicitor_time_of_arrival][min]" id="defence_request_solicitor_time_of_arrival_min" />
    </div>
    <div class="date-chooser-values">
      <label class="date-chooser-select form-label js-only" data-initial-date="#{ initialDate }">
        <span class="today" data-date-display="30 April 2015" data-day="30" data-month="4" data-year="2015">Today</span>
        <span class="tomorrow" data-date-display="01 May 2015"data-day="1" data-month="5" data-year="2015">Tomorrow</span>
      </label>
      <div class="date-field-wrapper">
        <label for="defence_request_solicitor_time_of_arrival_Day">Day</label>
        <input size="2" placeholder="DD" class="day text-field" value="#{ dayValue }" type="text" name="defence_request[solicitor_time_of_arrival][day]" id="defence_request_solicitor_time_of_arrival_day" />
      </div>
      <div class="date-field-wrapper">
        <label for="defence_request_solicitor_time_of_arrival_Month">Month</label>
        <input size="2" placeholder="MM" class="month text-field" value="#{ monthValue }" type="text" name="defence_request[solicitor_time_of_arrival][month]" id="defence_request_solicitor_time_of_arrival_month" />
      </div>
      <div class="date-field-wrapper">
        <label for="defence_request_solicitor_time_of_arrival_Year">Year</label>
        <input size="4" placeholder="YYYY" class="year text-field" value="#{ yearValue }" type="text" name="defence_request[solicitor_time_of_arrival][year]" id="defence_request_solicitor_time_of_arrival_year" />
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
  context.today = context.chooserDiv.find('.today')
  context.tomorrow = context.chooserDiv.find('.tomorrow')
  context.day = context.chooserDiv.find('.day')

sharedBehaviourForClickingTomorrow = (element, context) ->
  describe "clicking 'Tomorrow'", ->
    beforeEach ->
      dateChooserSetup(element, context)
      context.tomorrow.find('a').click()

    it "changes date values to tomorrow's date", ->
      expectDateValuesToEqual("1", "5", "2015", context.chooserDiv)

    it "makes Today a link", ->
      expect(context.today.find('a').size()).toEqual 1

    it "removes link from Tomorrow", ->
      expect(context.tomorrow.find('a').size()).toEqual 0

    it "sets focus on day input field", ->
      expect(context.day).toBeFocused()

sharedBehaviourForClickingTomorrowThenToday = (element, context) ->
  describe "click 'Tomorrow' and then click 'Today'", ->
    beforeEach ->
      dateChooserSetup(element, context)
      @tomorrow.find('a').click()
      @today.find('a').click()

    it "changes date values to today's date", ->
      expectDateValuesToEqual("30", "4", "2015", @chooserDiv)

    it "makes Tomorrow a link", ->
      expect(@tomorrow.find('a').size()).toEqual 1

    it "removes link from Today", ->
      expect(@today.find('a').size()).toEqual 0

enablesTodayLink = (element, context) ->
  it "makes Today a link", ->
    dateChooserSetup(element, context)
    expect(context.today.find('a').size()).toEqual 1

enablesTomorrowLink = (element, context) ->
  it "makes Tomorrow a link", ->
    dateChooserSetup(element, context)
    expect(@tomorrow.find('a').size()).toEqual 1


describe "DateChooser", ->
  element = null
  track = null

  afterEach ->
    element.remove()
    element = null

  describe "when initial date blank", ->
    beforeEach ->
      element = dateChooserHtml("any_other_value", "", "", "")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTodayLink(element, this)
      enablesTomorrowLink(element, this)

      it "leaves date values unchanged", ->
        expectDateValuesToEqual("", "", "", @chooserDiv)

    sharedBehaviourForClickingTomorrow(element, this)

    sharedBehaviourForClickingTomorrowThenToday(element, this)

  describe "when initial date not 'today' or 'tomorrow'", ->
    beforeEach ->
      element = dateChooserHtml("any_other_value", "1", "1", "2014")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTodayLink(element, this)
      enablesTomorrowLink(element, this)

      it "leaves date values unchanged", ->
        expectDateValuesToEqual("1", "1", "2014", @chooserDiv)

    sharedBehaviourForClickingTomorrow(element, this)

    sharedBehaviourForClickingTomorrowThenToday(element, this)

  describe "when initial date 'tomorrow'", ->
    beforeEach ->
      element = dateChooserHtml("tomorrow", "1", "5", "2015")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTodayLink(element, this)

      it "does not make Tomorrow a link", ->
        expect(@tomorrow.find('a').size()).toEqual 0

      it "leaves date values unchanged", ->
        expectDateValuesToEqual("1", "5", "2015", @chooserDiv)

  describe "when initial date 'today'", ->
    beforeEach ->
      element = dateChooserHtml("today", "31", "4", "2015")
      dateChooserSetup(element, this)

    describe "after initialization", ->
      enablesTomorrowLink(element, this)

      it "does not make Today a link", ->
        expect(@today.find('a').size()).toEqual 0

      it "leaves date values unchanged", ->
        expectDateValuesToEqual("31", "4", "2015", @chooserDiv)

    sharedBehaviourForClickingTomorrow(element, this)

    sharedBehaviourForClickingTomorrowThenToday(element, this)
