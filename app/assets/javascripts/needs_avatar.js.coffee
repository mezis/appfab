$(document).ready () ->
  that = $('#needs-avatar')
  that.hide()
  $.ajax
    url:  that.data('gravatar-url')
    type: 'HEAD'
    data:
      s:  1
      d:  404
  .success (data) ->
    that.remove()
  .fail (data) ->
    that.slideDown()
