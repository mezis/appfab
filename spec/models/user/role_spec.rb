# encoding: UTF-8
require 'spec_helper'

describe User::Role do
  fixtures :users

  its 'factory should work' do
    described_class.make.should be_valid
  end

  it "should not be valid by default" do
    described_class.new.should_not be_valid
  end

  it 'does not allow duplicates' do
    user = users(:abigale_balisteri)
    user.roles.create!(name: :developer)
    user.roles.build(name: :developer).should_not be_valid
  end
end

describe User::Role::UserMethods do
  fixtures :users

  describe '#plays?' do
    before do
      @user = users(:abigale_balisteri)
      @user.roles.create!(name: :developer)
    end

    it 'tests for the named role' do
      @user.plays?(:developer).should be_true
      @user.plays?(:product_manager).should be_false
    end

    it 'accepts strings' do
      @user.plays?('developer').should be_true
    end

    it 'fails on unknown roles' do
      expect {
        @user.plays?(:foobar)
      }.to raise_error(ArgumentError)
    end
  end

  describe '#plays!' do
    it 'adds the role to the user' do
      user = users(:abigale_balisteri)
      user.plays!(:developer)
      user.roles.should_not be_empty
      user.roles.first.name.should == 'developer'
    end

    it 'is idempotent' do
      user = users(:abigale_balisteri)
      user.plays!(:developer)
      user.plays!(:developer)
      user.plays?(:developer).should be_true
    end
  end

  describe '.playing' do
    it 'returns users with the given roles' do
      User.make!.plays!(:developer)
      User.make!.plays!(:product_manager)
      User.playing(:developer).length.should == 1
      User.playing(:developer, :product_manager).length.should == 2
    end
  end
end
