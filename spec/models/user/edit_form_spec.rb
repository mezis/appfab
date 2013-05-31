require 'spec_helper'

describe User::EditForm do
  fixtures :users, :logins, :accounts

  subject { described_class.new(user) }
  let(:user) { users(:abigale_balisteri) }

  describe '#initialize' do
    it 'requires a user' do
      expect { described_class.new(nil) }.
      to raise_error(ArgumentError)
    end
  end

  describe '(attributes)' do
    it 'picks up user attributes' do
      user.voting_power = 123
      subject.voting_power.should eq(123)
    end

    it 'picks up login attributes' do
      subject.first_name.should eq('Abigale')
    end
  end

  describe '(validation)' do
    it 'is invalid id user is invalid' do
      User.any_instance.stub(:valid? => false)
      subject.should_not be_valid
    end

    it 'exposes login errors' do
      subject.first_name = ''
      subject.save.should be_false
      subject.errors[:first_name].should_not be_empty
    end

    it 'exposes user errors' do
      subject.state = 1337
      subject.save.should be_false
      subject.errors[:state].should_not be_empty
    end
  end

  describe '#save' do
    it 'persists login changes' do
      subject.first_name = 'Leetbuffz'
      subject.save.should be_true
      user.login.reload.first_name.should == 'Leetbuffz'
    end

    it 'persists login changes' do
      subject.voting_power = 1337
      subject.save.should be_true
      user.reload.voting_power.should == 1337
    end
  end
end

