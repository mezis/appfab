# duration (250ms)
# start/end (css classes)
# after (callback)
$.fn.flash = (options) ->
  options            ||= {}
  options.duration   ||= 250
  target = this

  $(target).addClass('af-flashable')
  $(target).addClass(options.start) if options.start
  effect = $(target).delay(1)
  $.when(effect).done ->
    $(target).removeClass(options.start) if options.start
    $(target).addClass(options.end) if options.end
    options.after(target) if options.after