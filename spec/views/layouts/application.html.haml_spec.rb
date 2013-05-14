# encoding: UTF-8
require 'spec_helper'

describe "layouts/application.html.haml" do
  fixtures :users, :logins

  let(:user) { users :abigale_balisteri }
  login_user :user

  subject { render ; rendered }

  before do
    # enough setup to make the view path
    # TODO: woudln't need this if acting_real_user was in a helper
    view.lookup_context.prefixes << 'application'
    view.stub acting_real_user:nil
  end


  context 'with complex titles' do
    before do
      view.title 'Un titre en "Français" <blabla>'
    end

    it "preserves diacritics" do
      subject.should have_selector('title', text:/"Français"/, visible:false)
    end

    it "strips tags" do
      subject.should_not =~ /blabla/
    end
  end
end
