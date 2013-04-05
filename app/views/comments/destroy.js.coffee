$("#<%= dom_id @comment %>").flash({
  end:'af-poof'
  after: (target) ->
    $(target).slideUp()
})
