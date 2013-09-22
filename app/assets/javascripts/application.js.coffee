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
#= require jquery.turbolinks
#= require jquery_ujs
#= require bootstrap
#= require fineuploader
#= require turbolinks
#= require_tree .


$.unobtrusive () ->
  # only enable tooltips on non-touch devices
  return if ('ontouchstart' in document.documentElement)
  $('[title]').tooltip
    delay:     { show:500, hide:150 }
    container: 'body'
    html:      true


$(document).on 'page:fetch', () ->
  $('[data-barberpole]').addClass('af-barberpole')

$(document).on 'page:change', () ->
  $('[title]').tooltip('destroy')
  $('.tooltip').remove()

$(document).on 'page:restore', () ->
  $('[data-barberpole]').removeClass('af-barberpole')
  $('[title]').tooltip('destroy')
  $('.tooltip').remove()

$(document).ready () ->
  $(document).ajaxStart () ->
    $('[data-barberpole]').addClass('af-barberpole')
  $(document).ajaxComplete () ->
    $('[data-barberpole]').removeClass('af-barberpole')
