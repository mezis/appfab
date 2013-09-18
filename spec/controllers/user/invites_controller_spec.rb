require 'spec_helper'
require 'user_invitation_service'

describe User::InvitesController do
  login_user
  render_views

  fixtures :users, :accounts, :logins

  describe '#create' do
    let(:mock_service) { double run: true }

    it 'calls invitation service' do
      UserInvitationService.should_receive(:new).and_return(mock_service)
      request.env["HTTP_REFERER"] = "http://example.com"

      post :create, login: {
        email:      Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name
      }
    end
  end
end