# For XHR requests, copy the first flash message to HTTP headers.
module Traits::FlashesInHeaders
  extend ActiveSupport::Concern

  included do
    after_filter :flashes_in_headers
  end

  def flashes_in_headers
    return unless request.xhr?
    return unless flash.any?

    # FIXME: disabled, as render_to_string causes the "main" view not to be sent to the client.
    # Should use the "standalone" controller from the Pusher branch once it's in master.
    # response.headers['X-Flash-Data'] = render_to_string(partial:'flashes').gsub("\n"," ")
    flash.discard  # don't want the flash to appear when you reload page
    return true
  end

end