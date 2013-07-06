# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require fineuploader
#= require_tree .


$.unobtrusive () ->
  # only enable tooltips on non-touch devices

  return if ('ontouchstart' in document.documentElement)
  $('[title]').tooltip(
    delay: { show:500, hide:150 }
    html:  true
  )


  # remote tooltips

  $('[data-tooltip-url]').on 'mouseover', () ->
    url = $(this).data('tooltip-url')
    # console.log url
    $(this).tooltip('destroy')
    $(this).removeAttr('data-original-title')
    $(this).removeAttr('title')
    $(this).addClass('af-loading')
    $.ajax
      type:     'GET'
      url:      url
      dataType: 'html'
      context:  this
      success:  (data) ->
        console.log data
        $(this).attr('title', data)
        $(this).tooltip
          trigger: 'manual'
          html:    true
        .tooltip('show')
      complete: () ->
        $(this).removeClass('af-loading')

  $('[data-tooltip-url]').on 'mouseout', () ->
    $(this).tooltip('hide')
