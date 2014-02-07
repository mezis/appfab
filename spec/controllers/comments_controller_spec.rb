# encoding: UTF-8
require 'spec_helper'

describe CommentsController do
  login_user
  render_views

  fixtures :ideas

  let(:idea) { ideas(:idea_submitted) }

  describe "#create" do
    context "when model is invalid" do
      let(:data) {{ comment: { idea_id:idea.id, body:'' } }}

      context '(html)' do
        let(:perform) { post :create, data }

        it "redirects to idea list" do
          perform
          response.should redirect_to(idea_path(idea, anchor:'new_comment'))
        end

        it "flashes" do
          perform
          flash[:error].should_not be_empty
        end
      end

      context '(js)' do
        let(:perform) { xhr :post, :create, data }

        it "mentions the error" do
          perform
          response.body.should =~ /Blank comments are not permitted/
        end
      end
    end

    context "when model is valid" do
      let(:data) {{ comment: { body:'hello', idea_id:idea.id } }}

      share_examples_for 'comment creation' do
        it "creates a comment" do
          expect { perform }.to change { Comment.count }.by(1)
        end
      end

      context '(html)' do
        let(:perform) { post :create, data }
        it_should_behave_like 'comment creation'
      end

      context '(js)' do
        let(:perform) { xhr :post, :create, data }
        it_should_behave_like 'comment creation'
      end
    end
  end

  describe '#update' do
    let(:comment) { Comment.make! }
    let(:perform) { put :update, :id => comment, comment: { body: 'foobar' } }

    it "update action should redirect to idea when model is invalid" do
      comment
      Comment.any_instance.stub(:valid? => false)
      perform
      response.should be_success
    end

    it "update action should redirect to idea when model is valid" do
      perform
      response.should redirect_to(idea_path(comment.idea))
    end
  end

  it "edits a recent enough comment" do
    comment = Comment.make!
    get :edit, :id => comment
    assert_select ".test-editable"
  end

  it "does not edit an old comment" do
    comment = Comment.make!
    Comment.any_instance.stub(:recently_created? => false)
    get :edit, :id => comment
    assert_select ".test-editable", count: 0
  end

  it "destroy action should destroy model and redirect to idea action" do
    comment = Comment.make!
    delete :destroy, :id => comment
    response.should redirect_to(idea_url(comment.idea))
    Comment.exists?(comment.id).should be_false
  end

end
