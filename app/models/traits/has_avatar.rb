require 'digest/md5'

module Traits::HasAvatar
  extend ActiveSupport::Concern

  included do
    include Gravtastic
    has_gravatar :email, size: 80, filetype: :jpg, default: :retro, secure:false
  end
end
