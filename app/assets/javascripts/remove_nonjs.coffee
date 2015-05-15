# Remove .nonjs elements when JS enabled
$('.nonjs').each ->
  $(this).remove()
  return