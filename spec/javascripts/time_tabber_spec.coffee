//= require jquery
//= require jasmine-jquery
//= require time_tabber

DATE_TIME_CHOOSER_HTML =
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
      <label class="date-chooser-select form-label js-only" data-initial-date="today">
        <span class="today" data-date-display="30 April 2015" data-day="30" data-month="4" data-year="2015">Today</span>
        <span class="tomorrow" data-date-display="1 May 2015"data-day="1" data-month="5" data-year="2015">Tomorrow</span>
      </label>
      <div class="date-field-wrapper">
        <label for="defence_request_solicitor_time_of_arrival_Date">Date</label>
        <input size="2" class="date text-field" value="1 April 2015" type="text" name="defence_request[solicitor_time_of_arrival][date]" id="defence_request_solicitor_time_of_arrival_date" />
      </div>
    </div>
  </fieldset>
  </body>
  """)

DATE_CHOOSER_HTML =
  $("""
  <body>
  <fieldset class="inline time-select">
    <h1>Date of Birth</h1>
    <div class="date-field-wrapper">
      <label for="defence_request_date_of_birth_Day">Hour</label>
      <input size="2" maxlength="2" class="day text-field" type="text" name="defence_request[date_of_birth][day]" id="defence_request_date_of_birth_day" />
    </div>
    <div class="date-field-wrapper">
      <label for="defence_request_date_of_birth_Month">Min</label>
      <input size="2" maxlength="2" class="month text-field" type="text" name="defence_request[date_of_birth][month]" id="defence_request_date_of_birth_month" />
    </div>
    <div class="date-field-wrapper">
      <label for="defence_request_date_of_birth_Year">Year</label>
      <input size="4" maxlength="4" class="year text-field" type="text" name="defence_request[date_of_birth][year]" id="defence_request_date_of_birth_year" />
    </div>
  </fieldset>
  </body>
  """)


dateTimeChooserSetup = (element, context) ->
  $(document.body).append(element)

  chooserDivs = $(".date-chooser")
  context.chooserDiv = chooserDivs.eq(0)
  context.tabber = new window.TimeTabber(context.chooserDiv)
  context.hour = context.chooserDiv.find(".hour")
  context.minute = context.chooserDiv.find(".minute")
  context.date = context.chooserDiv.find(".date")

dateTimeChooserTeardown = (element) ->
  element.remove()

dateChooserSetup = (element, context) ->
  $(document.body).append(element)

  chooserDivs = $(".time-select")
  context.chooserDiv = chooserDivs.eq(0)
  context.tabber = new window.TimeTabber(context.chooserDiv)
  context.day = context.chooserDiv.find(".day")
  context.month = context.chooserDiv.find(".month")
  context.year = context.chooserDiv.find(".year")

dateChooserTeardown = (element) ->
  element.remove()

describe "TimeTabber", ->

  describe "date time choosers", ->
    beforeEach ->
      dateTimeChooserSetup(DATE_TIME_CHOOSER_HTML, this)

    afterEach ->
      dateTimeChooserTeardown(DATE_TIME_CHOOSER_HTML)

    describe "when hour is filled in", ->
      beforeEach ->
        @hour.val("12")
        @hour.focus()
        @hour.trigger("keyup")

      it "focuses the minute field", ->
        expect(@minute.get(0)).toBe document.activeElement

    describe "when minute is filled in", ->
      beforeEach ->
        @minute.val("12")
        @minute.focus()
        @minute.trigger("keyup")

      it "focuses the date field", ->
        expect(@date.get(0)).toBe document.activeElement

  describe "date choosers", ->
    beforeEach ->
      dateChooserSetup(DATE_CHOOSER_HTML, this)

    afterEach ->
      dateChooserTeardown(DATE_CHOOSER_HTML)

    describe "when day is filled in", ->
      beforeEach ->
        @day.val("12")
        @day.focus()
        @day.trigger("keyup")

      it "focuses the month field", ->
        expect(@month.get(0)).toBe document.activeElement

    describe "when month is filled in", ->
      beforeEach ->
        @month.val("12")
        @month.focus()
        @month.trigger("keyup")

      it "focuses the year field", ->
        expect(@year.get(0)).toBe document.activeElement

