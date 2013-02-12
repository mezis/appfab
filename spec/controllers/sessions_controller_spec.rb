require 'spec_helper'

describe SessionsController do

  describe '#update' do
    login_user

    context '(switching accounts)' do
      let(:other_account) { Account.make! }
      let(:other_user)    { other_account.users.create! login:@current_user.login }

      it 'switches the account context' do
        put :update, account_id:other_user.account.id

        controller.send(:current_user).should    == other_user
        controller.send(:current_account).should == other_account
      end

      it 'switches to default account when passed a bad account id' do
        initial_account = @current_user.account
        put :update, account_id:666

        controller.send(:current_account).should == initial_account
      end
    end

    context '(acting as user)' do
      let(:other_user) { User.make! }

      it 'does not work for normal users' do
        put :update, user_id:other_user.id
        flash[:error].should_not be_empty
      end

      context '(when account owner)' do
        before { @current_user.plays! :account_owner }
        before { @original_user = @current_user }

        it 'changes the current user' do
          controller.should_receive(:sign_in).with(other_user.login)
          put :update, user_id:other_user.id
          session[:real_user_id].should == @original_user.id
        end

        it 'can change back' do
          sign_in other_user.login
          session[:real_user_id] = @original_user.id

          controller.should_receive(:sign_in).with(@original_user.login)
          put :update, user_id:@original_user.id
        end
      end
    end
  end
end
