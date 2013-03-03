$("#<%= dom_id @attachment %>").flash({
  end:'af-poof'
  after: (target) ->
    $(target).slideUp()
})
