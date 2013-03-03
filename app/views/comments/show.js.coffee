form = $('form#new_comment')
comment_selector = '#comment_<%= @comment.id %>'
content = '<%=j render(@comment) %>'

if $(comment_selector).length
  $(comment_selector).hide()
  $(comment_selector).before(content)
else
  $(form).after(content)

$(comment_selector).eq(0).flash
  start:'af-pop'
#  after: () ->
#    $(comment_selector).eq(0).remove()

$(comment_selector).activateUnobtrusiveJavascript()
