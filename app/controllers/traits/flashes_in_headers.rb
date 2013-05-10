# For XHR requests, copy the first flash message to HTTP headers.
module Traits::FlashesInHeaders
  extend ActiveSupport::Concern

  included do
    after_filter :flashes_in_headers
  end

  def flashes_in_headers
    return unless request.xhr?

    return unless flash.any?

    response.headers['X-Flash-Data'] = side_render(
      partial: 'application/flashes',
      locals:  { flash:flash }
    ).gsub(/[\r\n]+/," ")
    flash.discard  # don't want the flash to appear when you reload page
    return true
  end

end