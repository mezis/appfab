form = $('form#new_comment')
$(form)[0].reset()
$(form).after '<%=j render(@comment) %>'

comment = $('#comment_<%= @comment.id %>')
comment.flash(
  start:'af-pop'
)
comment.activateUnobtrusiveJavascript()
