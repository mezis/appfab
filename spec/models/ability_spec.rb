require "spec_helper"
require "cancan/matchers"


describe Ability do
  fixtures :users, :accounts, :logins

  before { Idea.delete_all }

  describe "comments" do
    let(:current_user) { users(:abigale_balisteri) }
    subject { described_class.new current_user }

    context "permissions when comment belongs to someone else" do
      let(:comment)  { Comment.make!(author: someone_else) }
      let(:someone_else) { users(:joseph_fourier)}

      it "cannot update comment made by someone else" do
        should_not be_able_to(:update, comment)
      end

      it "cannot destroy comment made by someone else" do
        should_not be_able_to(:destroy, comment)
      end

      it "can vote on comment made by someone else" do
        should be_able_to(:vote, comment)
      end
    end

    context "permissions on comments made by the current user" do
      let(:comment)  { Comment.make!(author: current_user) }
      it "can update recent comment" do
        should be_able_to(:update, comment)
      end

      it "can destroy recent comment" do
        should be_able_to(:destroy, comment)
      end

      it "cannot vote on her own comments" do
        should_not be_able_to(:vote, comment)
      end
    end

    context "permissions on old comments made by the current user" do
      let(:comment)  { Comment.make!(author: current_user, created_at: 1.week.ago) }
      it "cannot update old comment" do
        should_not be_able_to(:update, comment)
      end

      it "cannot destroy old comment" do
        should_not be_able_to(:destroy, comment)
      end
    end
  end
end
