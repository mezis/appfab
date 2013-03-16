# encoding: UTF-8
require 'spec_helper'

describe CommentsController do
  login_user
  render_views


  describe "#create" do
    context "when model is invalid" do
      before { Comment.any_instance.stub(:valid? => false) }

      context '(html)' do
        let(:perform) { post :create }

        it "redirects to idea list" do
          perform
          response.should redirect_to(ideas_path)
        end

        it "flashes" do
          perform
          flash[:error].should_not be_empty
        end
      end

      context '(js)' do
        let(:perform) { xhr :post, :create }

        it "errors bad request" do
          perform
          response.status.should == 400
        end
      end
    end

    context "when model is valid" do
      let(:idea) { Idea.make! }
      let(:data) { { comment: { body:'hello', idea_id:idea.id } }  }

      context '(html)' do
        let(:perform) { post :create, data }

        it "creates a comment" do
          expect { perform }.to change { Comment.count }.by(1)
        end
      end

      context '(js)' do
        let(:perform) { xhr :post, :create, data }

        it "creates a comment" do
          expect { perform }.to change { Comment.count }.by(1)
        end
      end
    end
  end

  it "update action should redirect to idea when model is invalid" do
    comment = Comment.make!
    Comment.any_instance.stub(:valid? => false)
    put :update, :id => comment.id
    response.should redirect_to(idea_path(comment.idea))
  end

  it "update action should redirect to idea when model is valid" do
    put :update, :id => Comment.make!
    response.should redirect_to(idea_path(Comment.last.idea))
  end

  it "destroy action should destroy model and redirect to idea action" do
    comment = Comment.make!
    delete :destroy, :id => comment
    response.should redirect_to(idea_url(comment.idea))
    Comment.exists?(comment.id).should be_false
  end

end
