module Traits::RequiresLogin
  extend ActiveSupport::Concern

  included do
    before_filter :memorize_return_to
    before_filter :show_return_to
    before_filter :authenticate_login!
  end

  def memorize_return_to
    return if login_signed_in? || request.method != 'GET'
    session[:return_to] = request.path
  end

  def show_return_to
    Rails.logger.info "Return to: #{session[:return_to]}"
  end
end