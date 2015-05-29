//= require jquery
//= require jasmine-jquery
//= require disable_checker

fixtureHtml = (inputId, isChecked) ->
  if isChecked
    checked = 'checked="checked"'
  else
    checked = ""

  $("""
  <body>
  <div class="form-group">
    <label for="defence_request_detainee_name">Full Name</label>
    <input data-disable-when="defence_request_detainee_name_not_given"
           class="text-field text-field-wide not-given-check"
           name="defence_request[detainee_name]" id="defence_request_detainee_name"
           type="text">
    <label class="form-checkbox" for="defence_request_detainee_name_not_given">
      <input name="defence_request[detainee_name_not_given]" value="0" type="hidden">
      <input value="1" name="defence_request[detainee_name_not_given]" id="defence_request_detainee_name_not_given" type="checkbox" #{checked}>
      not given</label>
  </div>
  </body>
  """)

fixtureSetup = (element, inputId, context) ->
  $(document.body).append(element)

  context.disableCheckbox = $("#defence_request_detainee_name_not_given").eq(0)
  context.inputToDisable = $("[data-disable-when]").eq(0)
  context.disableChecker = new window.DisableChecker(context.inputToDisable)

describe "DisableChecker", ->
  element = null

  afterEach ->
    element.remove()
    element = null

  describe "when checkbox not checked", ->
    beforeEach ->
      inputId = "defence_request_appropriate_adult_reason"
      element = fixtureHtml(inputId, false)
      fixtureSetup(element, inputId, this)

    describe "after initialization", ->
      it "leaves input enabled", ->
        expect(@inputToDisable).not.toBeDisabled()

    describe "radio is checked", ->
      it "disables input", ->
        @disableCheckbox.trigger("click")
        expect(@inputToDisable).toBeDisabled()

      it "removes text from input", ->
        @inputToDisable.val("some text")
        expect(@inputToDisable.val()).toEqual "some text"

        @disableCheckbox.trigger("click")
        expect(@inputToDisable.val()).toEqual ""

    describe "radio is checked then unchecked", ->
      it "enables input", ->
        @disableCheckbox.trigger("click")
        @disableCheckbox.trigger("click")
        expect(@inputToDisable).not.toBeDisabled()

  describe "when radio checked", ->
    describe "after initialization", ->
      it "disables input", ->
        inputId = "defence_request_appropriate_adult_reason"
        element = fixtureHtml(inputId, true)
        fixtureSetup(element, inputId, this)
        expect(@inputToDisable).toBeDisabled()
