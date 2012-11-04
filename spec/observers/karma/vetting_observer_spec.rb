# encoding: UTF-8
require 'spec_helper'

describe Karma::VettingObserver do
  context 'when an idea is vetted' do
    let(:author)  { User.make! }
    let(:idea)    { Idea.make! }
    let(:vetting) { Vetting.make! user: author, idea: idea }

    it 'the vetter gains karma' do
      idea # make sure the idea is created outside the 'should' block
      lambda { vetting }.should change(author, :karma).by(1)
    end

    it 'loses karma when the vetting is canceled' do
      idea ; vetting
      lambda { vetting.destroy }.should change{ author.reload.karma }.by(-1)
    end
  end
end
