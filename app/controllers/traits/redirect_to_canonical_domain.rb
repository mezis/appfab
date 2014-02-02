# When used,
# All HTTP GET request will be redirected to the canonical app domain
# ENV['APP_DOMAIN']
module Traits::RedirectToCanonicalDomain
  def self.included(by)
    by.before_filter :redirect_to_canonical_domain
  end

  private

  def redirect_to_canonical_domain
    return unless request.method == 'GET'
    return if Rails.env.test? # FIXME: this should not be necessary
    return if request.host == ENV['APP_DOMAIN']

    uri = URI.parse(request.url)
    uri.host   = ENV['APP_DOMAIN']
    uri.scheme = 'https'

    redirect_to uri.to_s
  end
end
