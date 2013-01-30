require 'spec_helper'

describe SessionsController do

  describe 'update' do
    login_user

    let(:other_account) { Account.make! }
    let(:other_user)    { other_account.users.create! login:@current_user.login }

    it 'switches the account context' do
      put :update, account_id:other_user.account.id

      controller.send(:current_account).should == other_account
      controller.send(:current_user).should    == other_user
    end

    it 'switches to default account when passed a bad account id' do
      initial_account = @current_user.account
      put :update, account_id:666

      controller.send(:current_account).should == initial_account
    end
  end
end
