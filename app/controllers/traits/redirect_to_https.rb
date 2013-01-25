# When used,
# All HTTP GET requests will be redirected to HTTPS.
module Traits::RedirectToHttps
  def self.included(by)
    by.before_filter :redirect_to_https
  end

  private

  def redirect_to_https
    return if request.method != 'GET'
    return if request.ssl?
    return if Rails.env.development? || Rails.env.test?

    redirect_to request.url.gsub(/^http:/, 'https:')
  end
end
