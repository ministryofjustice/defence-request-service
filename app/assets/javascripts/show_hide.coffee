root = exports ? this

# Shows supplied element when radio with ID equal to 'data-show-when' value is checked.
# Hides supplied element when any other radio in fieldset is checked.
class ShowHide

  constructor: (elementToShow) ->
    @elementToShow = elementToShow
    checkInputId = elementToShow.data("show-when")

    @checkInput = $( "#" + checkInputId )
    fieldset = @checkInput.closest("fieldset")

    inputs = fieldset.find('input[type="radio"]')
    inputs.change (event) =>
      @toggleShowHide()

    @toggleShowHide()

  toggleShowHide: =>
    if @checkInput.is(":checked")
      @elementToShow.show()
    else
      @elementToShow.find("textarea").val("")
      @elementToShow.find("input[type='text']").val("")
      @elementToShow.hide()

root.ShowHide = ShowHide
