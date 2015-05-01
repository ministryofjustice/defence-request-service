//= require jquery
//= require jasmine-jquery
//= require date_chooser

expectDateValuesToEqual = (day, month, year, chooserDiv) ->
  expect( chooserDiv.find('.day').eq(0).val() ).toEqual day
  expect( chooserDiv.find('.month').eq(0).val() ).toEqual month
  expect( chooserDiv.find('.year').eq(0).val() ).toEqual year

expectDateDisplayToEqual = (text, chooserDiv) ->
  expect( chooserDiv.find('.date-display').eq(0).text() ).toEqual text

describe "DateChooser", ->
  element = null
  track = null

  beforeEach ->
    element = $("""
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
      <div class="date-select date-field-wrapper js-only-inline-block">
        <label>
          <span class="today" data-date-display="30 April 2015" data-day="30" data-month="4" data-year="2015">Today</span>
          <span class="tomorrow" data-date-display="01 May 2015"data-day="1" data-month="5" data-year="2015">Tomorrow</span>
        </label>
        <p class="date-display text-field">30 April 2015</p>
      </div>
      <div class="hide date-values">
        <div class="date-field-wrapper">-</div>
        <div class="date-field-wrapper">
          <label for="defence_request_solicitor_time_of_arrival_Day">Day</label>
          <input size="2" placeholder="DD" class="day text-field" value="30" type="text" name="defence_request[solicitor_time_of_arrival][day]" id="defence_request_solicitor_time_of_arrival_day" />
        </div>
        <div class="date-field-wrapper">
          <label for="defence_request_solicitor_time_of_arrival_Month">Month</label>
          <input size="2" placeholder="MM" class="month text-field" value="4" type="text" name="defence_request[solicitor_time_of_arrival][month]" id="defence_request_solicitor_time_of_arrival_month" />
        </div>
        <div class="date-field-wrapper">
          <label for="defence_request_solicitor_time_of_arrival_Year">Year</label>
          <input size="4" placeholder="YYYY" class="year text-field" value="2015" type="text" name="defence_request[solicitor_time_of_arrival][year]" id="defence_request_solicitor_time_of_arrival_year" />
        </div>
      </div>
    </fieldset>
    </body>
    """)
    $(document.body).append(element)

    chooserDivs = $(".date-chooser")
    @chooserDiv = chooserDivs.eq(0)
    @chooser = new window.DateChooser( @chooserDiv )
    @today = @chooserDiv.find('.today')
    @tomorrow = @chooserDiv.find('.tomorrow')

  afterEach ->
    element.remove()
    element = null

  describe "after initialization", ->
    it "leaves date values defaulted to today's date", ->
      expectDateValuesToEqual( "30", "4", "2015", @chooserDiv )

    it "leaves date display defaulted to today's date", ->
      expectDateDisplayToEqual( "30 April 2015", @chooserDiv )

    it "makes Tomorrow a link", ->
      expect( @tomorrow.find('a').size() ).toEqual 1

    it "does not make Today a link", ->
      expect( @today.find('a').size() ).toEqual 0

  describe "clicking 'Tomorrow'", ->
    beforeEach ->
      @tomorrow.find('a').click()

    it "changes date values to tomorrow's date", ->
      expectDateValuesToEqual( "1", "5", "2015", @chooserDiv )

    it "changes date display to tomorrow's date", ->
      expectDateDisplayToEqual( "01 May 2015", @chooserDiv )

    it "makes Today a link", ->
      expect( @today.find('a').size() ).toEqual 1

    it "removes link from Tomorrow", ->
      expect( @tomorrow.find('a').size() ).toEqual 0

  describe "click 'Tomorrow' and then click 'Today'", ->
    beforeEach ->
      @tomorrow.find('a').click()
      @today.find('a').click()

    it "changes date values to today's date", ->
      expectDateValuesToEqual( "30", "4", "2015", @chooserDiv )

    it "changes date display to today's date", ->
      expectDateDisplayToEqual( "30 April 2015", @chooserDiv )

    it "makes Tomorrow a link", ->
      expect( @tomorrow.find('a').size() ).toEqual 1

    it "removes link from Today", ->
      expect( @today.find('a').size() ).toEqual 0
