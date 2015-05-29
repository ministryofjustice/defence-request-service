root = exports ? this

# Disables supplied input when input with ID equal to 'data-disable-when' value is checked.
class DisableChecker

  constructor: (inputToDisable) ->
    @inputToDisable = inputToDisable
    checkInputId = @inputToDisable.data("disable-when")
    @checkInput = $( "#" + checkInputId ).eq(0)

    @checkInput.change =>
      @toggleDisable()

    @toggleDisable()

  toggleDisable: =>
    if @checkInput.is(":checked")
      @inputToDisable.val("")
      @inputToDisable.prop("disabled", true)
    else
      @inputToDisable.prop("disabled", false)

root.DisableChecker = DisableChecker
