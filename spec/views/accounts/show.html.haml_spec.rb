require 'spec_helper'

describe "accounts/show.html.haml" do

  subject { render ; rendered }
  let(:user) { User.make! }
  login_user :user

  before do
    assign :account, user.account
  end

  describe '(user state)' do
    before do
      login = Login.make!(first_name:'Johnnyboy')
      User.make!(state:User.state_value(:hidden), login:login, account:user.account)
    end

    context 'when I am an account owner' do
      it 'displays hidden users' do
        user.plays! :account_owner
        subject.should have_content('Johnnyboy')
        subject.should have_selector('.user-hidden')
      end
    end

    context 'when I am an regular user' do
      it 'does not display hidden users' do
        subject.should_not have_content('Johnnyboy')
        subject.should_not have_selector('.user-hidden')
      end
    end
  end
end
