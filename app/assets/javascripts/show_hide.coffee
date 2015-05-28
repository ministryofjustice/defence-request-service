root = exports ? this

# Enables input with given ID when checked input is checked
class ShowHide

  constructor: (inputToShow) ->
    @inputToShow = inputToShow
    checkInputId = inputToShow.data("show-when")
    @showCheckInput = $( "#" + checkInputId ).eq(0)

    @showCheckInput.change (event) =>
      @toggleShowHide(event.target)
    @toggleShowHide(@showCheckInput)

  toggleShowHide: (showCheckInput) =>
    if $(showCheckInput).is(":checked")
      @inputToShow.show()
    else
      @inputToShow.hide()

root.ShowHide = ShowHide
