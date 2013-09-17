# needs to be reloaded at eash page, as user may change
# TODO: only reload if first load or user changed.
$.unobtrusive () ->
  pusher_key = $('body').data('pusher-key')
  user_id    = $('body').data('user-id')
  unless $('html').data('pusher-loaded')
    $.getScript "https://d3dy5gmtp8yhk7.cloudfront.net/2.0/pusher.min.js", ->
      pusher     = new Pusher(pusher_key)
      channel    = pusher.subscribe("user-#{user_id}")
      channel.bind 'echo', (data) ->
        console.log data
      channel.bind 'notification', (data) ->
        container = $('#flashes')
        container.prepend(data.html)
      channel.bind 'reload', (data) ->
        node = $(data.selector)
        uri = node.data('reload-url')
        node.load(url)
      channel.bind 'update-user', (data) ->
        node = $("#current_user")
        if value = data.karma
          n = node.find('.karma .figure')
          n.text(value)
          n.flash(start: 'af-flashable-burnin', end: 'af-flashable-burnout')
        if value = data.notifications
          n  = node.find('.notifications .figure')
          n.text(data.notifications)
          n.flash(start: 'af-flashable-burnin', end: 'af-flashable-burnout')
      $('html').data('pusher-loaded', true)
