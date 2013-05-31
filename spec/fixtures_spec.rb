require 'spec_helper'

describe 'fixtures' do
  fixtures :all

  it 'has only valid fixtures' do
    records_to_check = {} # name -> model
    ActiveRecord::Fixtures.all_loaded_fixtures.each_pair do |model_name, fixture_list|
      fixture_list.fixtures.keys.each do |record_name|
        records_to_check[record_name] = model_name
      end
    end

    records_to_check.each_pair do |record_name, model_name|
      record = send(model_name.to_sym, record_name.to_sym)
      record.should be_a_kind_of(ActiveRecord::Base)
      record.should be_valid
    end
  end
end