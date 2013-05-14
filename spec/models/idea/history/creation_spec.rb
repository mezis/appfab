require 'spec_helper'

describe Idea::History::Creation do
  fixtures :users

  context 'idea creation' do
    it 'gets logged as history' do
      expect { Idea.make! }.to change{ described_class.count }.by(1)
    end
  end
end
