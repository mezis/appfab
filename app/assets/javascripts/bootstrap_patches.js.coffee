# Fixes Bootstrap dropdownmenus on iOS

$(document).ready () ->
  $('.dropdown-menu').on('touchstart.dropdown.data-api', (e) ->
    e.stopPropagation()
  )

  $('a.dropdown-toggle, .dropdown-menu a').on('touchstart', (e) ->
    e.stopPropagation()
  )
