# encoding: UTF-8
require 'spec_helper'

describe "ideas/index.html.haml" do
  fixtures :users, :accounts

  let(:ideas)     { Array.new }
  let(:category)  { 'all' }
  let(:user)      { users(:abigale_balisteri) }

  subject { render ; rendered }
  login_user :user

  before :each do
    assign :ideas,    ideas
    assign :category, category
    assign :view,     'cards'
    assign :order,    'activity'
    assign :angle,    'discussable'
    assign :filter,   'all'
  end

  describe "'sorry' banner" do
    BANNER_RE =  /there are no.*ideas/

    context '(when there are no ideas)' do
      it 'displays' do
        subject.should =~ BANNER_RE
      end
    end

    context '(when there is one idea)' do
      before { ideas << Idea.make! }
      it 'does not display' do
        subject.should_not =~ BANNER_RE
      end
    end

    context '(with a category filter)' do
      before { category.replace 'foobar' }

      it 'displays' do
        subject.should =~ BANNER_RE
      end

      it 'contains the category name' do
        subject.should =~ /foobar/
      end
    end
  end
end
