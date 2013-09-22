require 'spec_helper'

describe LoginService do
  fixtures :users, :logins, :accounts

  let(:email)     { Faker::Internet.email }
  let(:auth_hash) { build_auth_hash(email:email) }

  subject { described_class.new(auth_hash) }

  context 'login user does not exist' do
    it 'creates login' do
      expect { subject.run }.to change { Login.count }.by(1)
    end

    it 'is idempotent' do
      login = subject.run
      subject.run.should == login
    end

    it 'returns login' do
      subject.run.should be_a_kind_of(Login)
    end

    it 'gets login adopted by an account based on email' do
      account = Account.make!(domain:'example.com', auto_adopt:true)
      email.replace "john@example.com"
      
      new_login = subject.run
      new_login.accounts.should include(account)
    end
  end
end