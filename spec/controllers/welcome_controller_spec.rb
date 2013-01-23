# encoding: UTF-8
require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe '#static_page' do
    it 'returns not found for unknown pages'
    it 'shows content for known pages'
  end

end
