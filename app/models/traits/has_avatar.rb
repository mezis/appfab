require 'digest/md5'
require 'gravtastic'

module Traits::HasAvatar
  extend ActiveSupport::Concern

  included do
    include Gravtastic
    has_gravatar :email, size: 80, filetype: :jpg, default: :retro, secure:true

    if Rails.env.test?
      def gravatar_url(*args)
        "/favicon.ico"
      end
    end
  end
end
