# 
# remote tooltips
# TODO: this could make for a nice class instead of this spaghetti!
# 
$.unobtrusive ->
  $('[data-tooltip-url]').on 'mouseover', () ->
    url = $(this).attr('data-tooltip-url')
    this.clearForTooltip = ->
      $(this).tooltip('destroy')
      $(this).removeAttr('data-original-title')
      $(this).removeAttr('title')
      $(this).addClass('af-loading')
    this.clearForTooltip()
    $(this).data('should-show', true)
    $.ajax
      type:     'GET'
      url:      url
      dataType: 'html'
      context:  this
      success:  (data) ->
        this.clearForTooltip()
        $(this).attr('title', data)
        $(this).tooltip
          trigger:   'manual hover'
          delay:     { show:500, hide:250 }
          container: 'body'
          html:      true
        $(this).tooltip('show') if $(this).data('should-show')
      complete: () ->
        $(this).removeClass('af-loading')

  $('[data-tooltip-url]').on 'mouseout', () ->
    $(this).data('should-show', false)
