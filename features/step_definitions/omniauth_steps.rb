# encoding: UTF-8
Given /I authorise the app with my Google account "(.*?)"/ do |full_name|
  first_name, last_name = full_name.split
  email = full_name.downcase.split.join('.') + '@gmail.com'

  omniauth_test_mode
  setup_omniauth_filter

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider:"google_oauth2",
    uid:"12345678",
    info:{
      name:full_name,
      email:email,
      first_name:first_name,
      last_name:last_name,
      image:"https://lh3.googleusercontent.com/blabla/photo.jpg"
    },
    credentials:{
      token:"ya29.AHES6ZT5hexqVMS15XnzR_eKwsEnrwklihgrourweghfkauef",
      refresh_token:"1/-wufaliwuegfluawghelfigu-msAYBEKZvWsTs",
      expires_at:2351615640,
      expires:true
    },
    extra:{
      raw_info:{
        id:"12345678",
        email:email,
        verified_email:true,
        name:full_name,
        given_name:first_name,
        family_name:last_name,
        link:"https://plus.google.com/12345678",
        picture:"https://lh3.googleusercontent.com/blabla/photo.jpg",
        gender:"male",
        locale:"en-GB"
      }
    }
  })
end


Given /I do not authorise the app with my Google account/ do
  omniauth_test_mode
  setup_omniauth_filter
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
end


Given /I sign in with Google/ do
  visit '/users/sign_in'
  click_link 'Sign in with Google Oauth2'
end


Given /I sign in as the developer "(.*?)"/ do |full_name|
  email = full_name.downcase.split.join('.') + '@example.com'

  visit '/users/sign_in'
  click_link 'Sign in with Developer'
  fill_in 'name',  with:full_name
  fill_in 'email', with:email
  click_on 'Sign In'
end


# helpers ######################################################################


def setup_omniauth_filter
  ApplicationController.class_eval do
    unless @setup_omniauth_filter
      prepend_before_filter :stub_omniauth
      @setup_omniauth_filter = true
    end

    def stub_omniauth
      request.env["devise.mapping"] = Devise.mappings[:user] 
      request.env["omniauth.auth"]  = OmniAuth.config.mock_auth[:google_oauth2] 
    end
  end
end


After do
  ApplicationController.class_eval do
    def stub_omniauth ; end
  end
end


def omniauth_test_mode
  OmniAuth.config.test_mode = true
end


After do
  OmniAuth.config.test_mode = false
end

