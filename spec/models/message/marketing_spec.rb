require 'spec_helper'

describe Message::Marketing do
  describe 'notify!' do
    it 'creates notifications'
    it 'is idempotent'
    it 'validates all locales are present in summary'
  end
end
