# encoding: UTF-8
require 'spec_helper'

describe NotificationsController do
  login_user
  render_views

  describe '#index' do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    context '(angles)' do
      before do
        Notification::NewUser.create! recipient:@current_user, subject:@current_user, unread:false
      end

      it "'all' angle shows read notifications" do
        get :index, angle:'all'
        assigns[:notifications].should_not be_empty
      end

      it "'unread' angle does not show read notifications" do
        get :index, angle:'unread'
        assigns[:notifications].should be_empty
      end
    end

    context '(pagination)' do
      around do |example|
        NotificationsController.with_constants PER_PAGE: 2 do
          example.run
        end
      end

      def notifications(count)
        (1..count).map do
          Notification::NewUser.create! recipient:@current_user, subject:@current_user
        end
      end

      it 'limits the notifications per page' do
        notifications 3
        get :index
        assigns[:notifications].size.should == 2
      end

      it 'paginates' do
        notifications 3
        get :index, page:2
        assigns[:notifications].size.should == 1
      end
    end
  end

  describe '#update' do
    it "renders edit template when model is invalid" do
      notification = Notification::Base.make!
      Notification::Base.any_instance.stub(:valid? => false)
      put :update, :id => notification.id
      response.should redirect_to(notifications_path)
    end

    it "redirects when model is valid" do
      put :update, :id => Notification::Base.make!
      response.should redirect_to(notifications_path)
    end

    it "allows 'all' as id" do
      n1,n2 = [1,2].map { Notification::Base.make! recipient:@current_user, unread:true }
      put :update, id: 'all', notification: { unread:false }
      n1.reload.should_not be_unread
      n2.reload.should_not be_unread
    end

    it "bails when any parameter but 'id' and 'unread' are passed" do
      notification = Notification::Base.make!
      expect {
        put :update, id: notification.id, notification: { recipient_id:123 }
      }.to raise_exception(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe '#destroy' do
    it "destroys model and redirect to index action" do
      notification = Notification::Base.make!
      delete :destroy, :id => notification
      Notification::Base.exists?(notification.id).should be_false
    end
  end
end
