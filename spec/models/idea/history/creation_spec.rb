require 'spec_helper'

describe Idea::History::Creation do
  fixtures :users

  context 'idea creation' do
    let(:idea) { Idea.make! }

    it 'gets logged as history' do
      expect { idea }.to change{ described_class.count }.by(1)
    end
  end
end
