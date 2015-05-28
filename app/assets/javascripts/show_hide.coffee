root = exports ? this

# Enables input with given ID when checked input is checked
class ShowHide

  constructor: (elementToShow) ->
    @elementToShow = elementToShow
    checkInputId = elementToShow.data("show-when")

    @showCheckInput = $( "#" + checkInputId ).eq(0)
    fieldset = @showCheckInput.closest("fieldset")

    inputs = fieldset.find('input[type="radio"]')
    inputs.change (event) =>
      @toggleShowHide()

    @toggleShowHide()

  toggleShowHide: =>
    if @showCheckInput.is(":checked")
      @elementToShow.show()
    else
      @elementToShow.hide()

root.ShowHide = ShowHide
