# encoding: UTF-8
require 'spec_helper'

describe "ideas/_idea.html.haml" do
  fixtures :users, :logins, :accounts

  let(:local_assigns) { { idea:idea } }
  let(:user)          { users(:abigale_balisteri) }

  login_user :user

  subject do
    render partial:'ideas/idea', locals:local_assigns
    rendered
  end

  context 'long problem statement' do
    let(:problem) { "this is a very long\n\nand spammy problem statement" }
    let(:options) { { problem:problem } }
    let(:idea) { Idea.make!(options) }

    context '(collapsed)' do
      it 'only shows the first paragraph' do
        local_assigns[:collapsed] = true
        subject.should_not include('spammy')
      end

      it 'even with CRLF' do
        problem.gsub!("\n", "\r\n")
        local_assigns[:collapsed] = true
        subject.should_not include('spammy')
      end
    end

    context '(not collapsed - default)' do
      it 'shows all paragraphs' do
        subject.should include('spammy')
      end
    end
  end
end
