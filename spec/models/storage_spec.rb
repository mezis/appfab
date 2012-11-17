require 'spec_helper'

describe Storage::DataStore do
  let(:fake_file) { OpenStruct.new data: data, meta: metadata }
  let(:metadata) { {a:1} }

  share_examples_for 'store and retrieve' do
    it 'retrieves the data' do
      id = subject.store(fake_file)
      returned_data, returned_meta = subject.retrieve(id)

      returned_data.length.should == data.length
      returned_data.should == data
    end
  end


  context 'for small chunks of text data' do
    let(:data) { "foobar" }
    it_should_behave_like 'store and retrieve'
  end

  context 'for small chunks of binary data' do
    let(:data) { SecureRandom.random_bytes(64) }
    it_should_behave_like 'store and retrieve'
  end

  context 'for large chunks of binary data' do
    let(:data) { SecureRandom.random_bytes(2_000_000) }
    it_should_behave_like 'store and retrieve'
  end
end
