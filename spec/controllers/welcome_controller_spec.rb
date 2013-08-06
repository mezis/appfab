# encoding: UTF-8
require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe '#static_page' do
    around do |example|
      described_class.with_constants :STATIC_PAGES => %w(foo-bar hello-world) do
        example.run
      end
    end

    it 'returns not found for unknown pages' do
      get :static_page, page:'unknown'
      response.should be_not_found
    end

    it 'shows content for known pages' do
      controller.stub(:render)
      controller.should_receive(:render).with('foo_bar')
      get :static_page, page:'foo-bar'

      response.should be_success
    end
  end

end
