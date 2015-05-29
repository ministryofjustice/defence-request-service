root = exports ? this

class DisableChecker

  constructor: (inputToDisable) ->
    @inputToDisable = inputToDisable
    checkInputId = @inputToDisable.data("disable-when")
    @checkInput = $( "#" + checkInputId ).eq(0)

    @checkInput.change (event) =>
      @toggleDisable()

    @toggleDisable()

  toggleDisable: =>
    if @checkInput.is(":checked")
      @inputToDisable.prop('disabled', true)
    else
      @inputToDisable.prop('disabled', false)

root.DisableChecker = DisableChecker
