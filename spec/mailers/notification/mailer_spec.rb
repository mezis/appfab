require "spec_helper"

describe Notification::Mailer do
  fixtures :users, :accounts

  describe "digest" do
    let(:user) { users(:abigale_balisteri) }
    let(:notifications) { [Notification::NewIdea.make!] }
    let(:mail) { Notification::Mailer.digest(user, notifications) }

    it "renders the headers" do
      mail.subject.should include("AppFab")
      mail.to.should == [user.email]
      mail.from.first.should include("noreply")
    end

    it "renders the body" do
      mail.body.encoded.should match(notifications.first.subject.title)
    end

    it "contains a URL to the app" do
      mail.body.encoded.should include('http://example.com:1234')
    end
  end

end
