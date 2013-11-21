# encoding: UTF-8
require 'spec_helper'

describe "ideas/_board.html.haml" do
  fixtures :users, :logins, :accounts

  let(:ideas) { Array.new }
  let(:idea_counts) { Hash.new }
  let(:local_assigns) { Hash.new }
  let(:user)          { users(:abigale_balisteri) }

  login_user :user

  subject do
    render partial:'ideas/board', locals:local_assigns
    rendered
  end

  before do
    stub_template 'ideas/_idea_mini.html.haml' => '= idea.title'
    assign :ideas, ideas
    assign :idea_counts, idea_counts
  end

  it 'should render submitted and picked ideas' do
    ideas.push double(state: 0, title: 'submitted idea')
    ideas.push double(state: 3, title: 'picked idea')
    subject.should =~ /submitted idea/
    subject.should =~ /picked idea/
  end

  it 'should not render drafts' do
    ideas.push double(state: -1, title: 'draft idea')
    subject.should_not =~ /draft idea/
  end

  it 'should display the number of hidden ideas' do
    ideas.push double(state: 0, title: 'submitted idea')
    idea_counts[:submitted] = 999
    subject.should =~ /\b998\b/
  end

end
