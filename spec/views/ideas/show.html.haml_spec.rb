# encoding: UTF-8
require 'spec_helper'

describe "ideas/show.html.haml" do
  fixtures :users, :logins

  subject { render ; rendered }
  let(:user) { users :abigale_balisteri }
  login_user :user

  before do
    Timecop.travel(3.days.ago) do
      @idea = Idea.make!(state:-1)
    end

    Timecop.travel(2.hours.ago) do
      @idea.comments.make!(body:'hello world', author:user)
    end

    Timecop.travel(10.minutes.ago) do    
      @idea.submit»
    end
  end

  describe 'histories' do
    it 'displays creation date' do
      subject.should =~ /Idea created.*3 days ago/
    end

    it 'displays comments' do
      subject.should include('hello world')
    end

    it 'displays state changes' do
      subject.should include('draft → submitted')      
    end
  end
end
