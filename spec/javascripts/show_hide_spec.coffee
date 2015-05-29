//= require jquery
//= require jasmine-jquery
//= require show_hide

fixtureHtml = (inputId, disabledRadioChecked, enabledRadioChecked) ->
  disabledChecked = if disabledRadioChecked then 'checked="checked"' else ""
  enabledChecked = if enabledRadioChecked then 'checked="checked"' else ""

  $("""
  <body>
  <div>
    <fieldset>
      <label for="defence_request_appropriate_adult">Appropriate adult</label>
      <label for="defence_request_appropriate_adult_true">
        <input name="defence_request[appropriate_adult]" value="true" #{ enabledChecked } id="defence_request_appropriate_adult_true" type="radio">
        Yes
      </label>
      <label for="defence_request_appropriate_adult_false">
        <input name="defence_request[appropriate_adult]" value="false" #{ disabledChecked } id="defence_request_appropriate_adult_false" type="radio">
        No
      </label>
    </fieldset>
  </div>

  <div data-show-when="defence_request_appropriate_adult_true">
    <label for="defence_request_appropriate_adult_reason">Reason for appropriate adult</label>
    <textarea name="defence_request[appropriate_adult_reason]" id="#{ inputId }"></textarea>
    <input name="defence_request[appropriate_adult_reason_etc]" id="#{ inputId }_etc" type="text"></input>
  </div>
  </body>
  """)

fixtureSetup = (element, inputId, context) ->
  $(document.body).append(element)

  context.otherRadio = $("#defence_request_appropriate_adult_false").eq(0)
  context.showRadio = $("#defence_request_appropriate_adult_true").eq(0)
  context.elementToShow = $("[data-show-when]" ).eq(0)
  context.disableChecker = new window.ShowHide(context.elementToShow )

describe "ShowHide", ->
  element = null

  afterEach ->
    element.remove()
    element = null

  describe "when no radio checked", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, false, false)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "hides input", ->
        expect(@elementToShow).toBeHidden()

    describe "show radio is checked", ->
      it "shows input", ->
        @showRadio.trigger("click")
        expect(@elementToShow).not.toBeHidden()

    describe "other radio is checked", ->
      it "leaves input hidden", ->
        @otherRadio.trigger("click")
        expect(@elementToShow).toBeHidden()

    describe "other radio is checked then show radio is checked", ->
      it "shows input", ->
        @otherRadio.trigger("click")
        @showRadio.trigger("click")
        expect(@elementToShow).not.toBeHidden()

    describe "show radio is checked then other radio is checked", ->
      it "hides input", ->
        @showRadio.trigger("click")
        @otherRadio.trigger("click")
        expect(@elementToShow).toBeHidden()

      it "removes text from input", ->
        @showRadio.trigger("click")

        textArea = @elementToShow.find('textarea')
        textArea.val("some text")
        expect(textArea.val()).toEqual "some text"

        input = @elementToShow.find('input')
        input.val("etc text")
        expect(input.val()).toEqual "etc text"

        @otherRadio.trigger("click")
        expect(textArea.val()).toEqual ""
        expect(input.val()).toEqual ""

  describe "when other radio checked on load", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, true, false)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "hides input", ->
        expect(@elementToShow).toBeHidden()

  describe "when show radio checked on load", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, false, true)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "leaves input shown", ->
        expect(@elementToShow).not.toBeHidden()
