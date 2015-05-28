root = exports ? this

class DisableChecker

  constructor: (checkInput) ->
    inputId = checkInput.data("disable-when-checked")
    @inputToDisable = $( "#" + inputId ).eq(0)

    checkInput.change (event) =>
      @toggleDisable(event.target)

    @toggleDisable(checkInput)

  toggleDisable: (checkInput) =>
    if $(checkInput).is(":checked")
      @inputToDisable.prop('disabled', true)
    else
      @inputToDisable.prop('disabled', false)

root.DisableChecker = DisableChecker
