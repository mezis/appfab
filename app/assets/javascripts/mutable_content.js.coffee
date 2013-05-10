$.unobtrusive () ->
  $('.af-mutable-content :input')
  .bind 'focus', () ->
    $(this).closest('.af-mutable-content').addClass('focused')
  .bind 'blur', () ->
    $(this).closest('.af-mutable-content').removeClass('focused')
