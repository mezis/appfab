node = $('#<%= dom_id @notification %>')

$(node).replaceWith '<%=j render(@notification) %>'

node.flash
  start:'af-pop'

node.activateUnobtrusiveJavascript()
