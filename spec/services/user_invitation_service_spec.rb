require 'spec_helper'

describe UserInvitationService do
  fixtures :users, :logins, :accounts

  subject { described_class.new(inviter:@inviter, login:@login) }
  let(:perform) { subject.run }

  before { @inviter = User.last }

  context "when the login doesn't exist" do
    before do
      @login = OpenStruct.new(
        email:      Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name)
    end

    its(:run) { should be_true }

    it "creates the login" do
      expect { perform }.to change { Login.count }.by(1)
      User.last.login.email.should == @login.email
    end

    it "creates the user" do
      perform
      User.last.account.should == @inviter.account
      User.last.login.email.should == @login.email
    end

    it "sends an email" do
      expect { perform }.
      to change { ActionMailer::Base.deliveries.length }.
      by(1)
    end

    it_should_send_emails(1)
  end

  context "when the login exists but is not a member" do
    before do
      @login = Login.make!
    end

    its(:run) { should be_true }
    it_should_send_emails(1)

    it "creates the user" do
      perform
      @login.users.last.account.should == @inviter.account
    end
  end

  context "when the login already is a member" do
    before do
      @login = User.last.login
    end

    its(:run) { should be_false }
    it_should_send_emails(0)

    it "does not create a user" do
      expect { perform }.not_to change { User.count }
    end
  end
end

