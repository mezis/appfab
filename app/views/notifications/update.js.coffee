node = $('#notification<%= @notification.id %>')

$(node).replaceWith '<%=j render("notification/base", notification:@notification) %>'

node.flash
  start:'af-pop'

node.activateUnobtrusiveJavascript()
