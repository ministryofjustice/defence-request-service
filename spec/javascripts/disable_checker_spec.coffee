//= require jquery
//= require jasmine-jquery
//= require disable_checker

fixtureHtml = (inputId, radioChecked) ->
  if radioChecked
    checked = 'checked="checked"'
  else
    checked = ""

  $("""
  <body>
  <div>
    <fieldset>
      <label for="defence_request_appropriate_adult">Appropriate adult</label>
      <label for="defence_request_appropriate_adult_true">
        <input name="defence_request[appropriate_adult]" value="true" id="defence_request_appropriate_adult_true" type="radio">
        Yes
      </label>
      <label for="defence_request_appropriate_adult_false">
        <input name="defence_request[appropriate_adult]" data-disable-when-checked="#{ inputId }" value="false" #{ checked }" id="defence_request_appropriate_adult_false" type="radio">
        No
      </label>
    </fieldset>
  </div>

  <div>
    <label for="defence_request_appropriate_adult_reason">Reason for appropriate adult</label>
    <textarea name="defence_request[appropriate_adult_reason]" id="#{ inputId }"></textarea>
  </div>
  </body>
  """)

fixtureSetup = (element, inputId, context) ->
  $(document.body).append(element)

  context.checkInput = $("[data-disable-when-checked]").eq(0)
  context.inputToDisable = $( "#" + inputId )[0]
  context.disableChecker = new window.DisableChecker( context.checkInput )

describe "DisableChecker", ->
  element = null

  afterEach ->
    element.remove()
    element = null

  describe "when radio not checked", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, false)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "leaves input enabled", ->
        expect( @inputToDisable ).not.toBeDisabled()

    describe "radio is checked", ->
      it "disables input", ->
        @checkInput.prop("checked", true)
        @checkInput.trigger("change")
        expect( @inputToDisable ).toBeDisabled()

    describe "radio is checked then unchecked", ->
      it "enables input", ->
        @checkInput.prop("checked", true)
        @checkInput.trigger("change")
        @checkInput.prop("checked", false)
        @checkInput.trigger("change")
        expect( @inputToDisable ).not.toBeDisabled()

  describe "when radio checked", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, true)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "disables input", ->
        expect( @inputToDisable ).toBeDisabled()
