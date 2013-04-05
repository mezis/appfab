#  Custom unobtrusiveness helpers

$.unobtrusive = (callback) ->
  $(document).bind('activate-unobtrusive-javascript', (event, root) ->
    $(root).each(callback)
  )

$.fn.activateUnobtrusiveJavascript = () ->
  return this.each(() ->
    $(document).trigger('activate-unobtrusive-javascript', this)
  )

$(document).ready () ->
  $(document).activateUnobtrusiveJavascript()


# Fixes Bootstrap dropdownmenus on iOS

$.unobtrusive () ->
  $('.dropdown-menu').on('touchstart.dropdown.data-api', (e) ->
    e.stopPropagation()
  )

  $('a.dropdown-toggle, .dropdown-menu a').on('touchstart', (e) ->
    e.stopPropagation()
  )


# Fixes data-dismiss

$.unobtrusive () ->
  $('[data-dismiss]').on 'click', () ->
    selector = '.' + $(this).data('dismiss')
    target = $(this).closest(selector)
    target.fadeOut 'fast', () ->
      $(this).remove()
