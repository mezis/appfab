require 'spec_helper'

describe Traits::Idea::StarRating do
  fixtures :users

  let(:described_module) { Traits::Idea::StarRating }

  it 'is part of the ancestor chain' do
    Idea.new.should be_a_kind_of(described_module)
  end

  context 'given an idea' do
    subject { Idea.make!(:voted) }

    describe '#impact_rating' do
      let(:result) { subject.impact_rating }

      it 'is nil when design_size is missing' do
        subject.design_size = nil
        result.should be_nil
      end

      it 'is nil when development_size is missing' do
        subject.development_size = nil
        result.should be_nil
      end

      it 'is nil when idea is unrated' do
        subject.rating = nil
        result.should be_nil
      end

      it 'is calculated when all present' do
        subject.design_size = 1
        subject.development_size = 2
        subject.rating = 4
        result.should == 1333
      end

      it 'is saved on the idea' do
        subject.update_attributes! design_size:1, development_size:2, rating:4
        subject.reload
        subject.impact_cache.should == 1333
      end

      it 'gets updated when a vote is cast' do
        subject.update_attributes! design_size:1, development_size:2
        subject.votes.create! user:subject.author
        subject.reload
        result.should == 333
      end
    end
  end

  describe '.update_stars_cache!' do
    before do
      Idea.delete_all

      @idea1    = Idea.make!(:voted)
      @idea2    = Idea.make!(:voted)
      @idea3    = Idea.make!(:voted)
      @idea4    = Idea.make!(:voted)
      @idea5    = Idea.make!(:voted)
      @nil_idea = Idea.make!(:voted)

      Idea.update_all stars_cache:2 # force 'bad' values in

      @idea1.update_attributes!     rating:3
      @idea2.update_attributes!     rating:2
      @idea3.update_attributes!     rating:2
      @idea4.update_attributes!     rating:2
      @idea5.update_attributes!     rating:1
      @nil_idea.update_attributes!  rating:0
    end

    it 'gives the best idea 4 stars' do
      @idea1.reload.stars_cache.should == 4
    end

    it 'gives the worse idea 0 stars' do
      @idea5.reload.stars_cache.should == 0
    end

    it 'resets star count of unrated ideas' do
      @nil_idea.reload.stars_cache.should be_nil
    end
  end
end
