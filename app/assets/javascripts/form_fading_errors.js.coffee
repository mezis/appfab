$.unobtrusive () ->
  $('.js-fading-errors').each ->
    that = $(this).find('.field_with_errors')
    that.closest('.control-group').addClass('error')
    that.find('textarea').on('focus', () ->
      control = $(this).closest('.control-group')
      control.removeClass('error')
      control.find('.help-block.error').fadeOut()
    )
