# duration (250ms)
# start/end (css classes)
# after (callback)
$.fn.flash = (options) ->
  options            ||= {}
  options.duration   ||= 250
  target = $(this)

  target.addClass(options.start) if options.start

  $.when(target.delay(1)).done ->
    target.addClass('af-flashable')

    $.when(target.delay(options.duration)).done ->
      target.removeClass(options.start) if options.start
      target.addClass(options.end)      if options.end

      $.when(target.delay(2*options.duration)).done ->
        target.removeClass(options.end) if options.end
        target.removeClass('af-flashable')
        options.after(target) if options.after
