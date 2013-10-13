# encoding: UTF-8
require 'spec_helper'

describe Rating::VoteObserver do
  context 'voting on comments' do
    before do
      @comment = Comment.make!
      @voter   = User.make!
    end

    let(:vote) { Vote.make! subject: @comment, user: @voter, up: up }

    context 'when a comment is upvoted' do
      let(:up) { true }
      it 'increases the comment rating' do
        lambda { vote }.should change { @comment.reload.rating }.by(1)
      end

      it 'increases it more for powerful voters' do
        @voter.update_attributes! voting_power:10
        lambda { vote }.should change { @comment.reload.rating }.by(10)
      end
    end

    context 'when a comment is downvoted' do
      let(:up) { false }
      it 'decreases the comment rating' do
        lambda { vote }.should change { @comment.reload.rating }.by(-1)
      end
    end
  end


  context 'voting on ideas' do
    before do
      @idea  = Idea.make!(:vetted)
      @voter = User.make!
    end

    let(:vote) { Vote.make! subject: @idea, user: @voter, up: true }

    context 'when an idea is voted on' do
      it 'increases the idea rating' do
        lambda { vote }.should change { @idea.reload.rating }.by(1)
      end

      it 'increases it more for powerful voters' do
        @voter.update_attributes! voting_power:10
        lambda { vote }.should change { @idea.reload.rating }.by(10)
      end
    end
  end
end
