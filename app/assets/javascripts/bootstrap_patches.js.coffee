# Fixes Bootstrap dropdownmenus on iOS

$(document).ready () ->
  $('.dropdown-menu').on('touchstart.dropdown.data-api', (e) ->
    e.stopPropagation()
  )

  $('a.dropdown-toggle, .dropdown-menu a').on('touchstart', (e) ->
    e.stopPropagation()
  )


# Fixes data-dismiss

$(document).ready () ->
  $('[data-dismiss]').on('click', () ->
    selector = '.' + $(this).data('dismiss')
    $(this).closest(selector).fadeOut('fast')
  )
