# encoding: UTF-8
require 'spec_helper'

describe "ideas/_idea.html.haml" do

  let(:local_assigns) { { idea:idea } }
  let(:user)          { User.make! }

  login_user :user

  subject do
    render partial:'ideas/idea', locals:local_assigns
    rendered
  end

  context 'long problem statement' do
    let(:idea) { Idea.make!(problem:"this is a very long\n\nspammy problem statement") }

    context '(collapsed)' do
      before { local_assigns.merge! collapsed:true }

      it 'only shows the first paragraph' do
        subject.should_not include('spammy')
      end
    end

    context '(not collepsed - default)' do
      it 'shows all paragraphs' do
        subject.should include('spammy')
      end
    end
  end
end
