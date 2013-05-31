require 'spec_helper'

describe User::Bookmark do
  fixtures :users

  before { users(:abigale_balisteri) }
  let(:user) { users(:abigale_balisteri) }
  let(:idea) { Idea.make!(author: User.make!)}

  it "should be valid" do
    User::Bookmark.new.should be_valid
  end

  describe User::Bookmark::UserMethods do
    it 'provides #bookmarks' do
      user.should respond_to(:bookmarks)
      user.bookmarks.create!(idea: idea)
      user.bookmarks.first.idea.should == idea
    end

    it 'provides #bookmarked_idea' do
      user.should respond_to(:bookmarked_ideas)
      user.bookmarks.create!(idea: idea)
      user.bookmarked_ideas.first.should == idea
    end
  end

  describe User::Bookmark::AssociationMethods do
    describe '#add!' do
      it 'bookmarks ideas' do
        user.bookmarked_ideas.add!(idea)
        user.bookmarked_ideas.should == [idea]
      end

      it 'is idempotent' do
        2.times { user.bookmarked_ideas.add!(idea) }
        user.bookmarked_ideas.should == [idea]
      end
    end

    describe '#remove!' do
      it 'removes bookmarks' do
        user.bookmarked_ideas.add!(idea)
        user.bookmarked_ideas.remove!(idea)
        user.bookmarked_ideas.should be_empty
      end

      it 'is idempotent' do
        user.bookmarked_ideas.add!(idea)
        2.times { user.bookmarked_ideas.remove!(idea) }
        user.bookmarked_ideas.should be_empty
      end
    end
  end
end
