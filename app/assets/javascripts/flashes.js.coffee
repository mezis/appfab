# Render flashes even from XHR updates.
# 
$(document).ajaxComplete (event, request) ->
  flash_data = request.getResponseHeader('X-Flash-Data')
  return unless flash_data
  $('#flashes').prepend(flash_data)
  $('#flashes').activateUnobtrusiveJavascript()