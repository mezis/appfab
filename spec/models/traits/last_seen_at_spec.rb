# encoding: UTF-8
require 'spec_helper'

describe Traits::LastSeenAt do
  describe 'timestamping write cache' do
    let(:stamp) { Time.zone.parse('2011-04-05 11:00:00') }
    let(:new_stamp) { stamp + 1.day }
    let(:result) { subject.reload.last_seen_at }

    subject { User.make! last_seen_at:stamp }

    describe '#last_seen_at' do
      context 'when uncached' do
        it 'returns the attribute' do
          result.should == stamp
        end
      end

      context 'when cache value more recent' do
        it 'returns the cached value' do
          Timecop.travel(new_stamp) { subject.update_attribute(:last_seen_at, Time.current) }
          result.should > stamp
        end
      end
    end

    describe '#last_seen_at=' do
      before do
        subject.last_seen_at = new_stamp
      end

      it 'does not touch the model' do
        subject.reload.attributes['last_seen_at'].should == stamp
      end

      it 'is preserved' do
        subject.save!
        subject.reload.last_seen_at.should == new_stamp
      end

      it 'depends on the main cache' do
        Rails.cache.clear
        subject.reload.last_seen_at.should == stamp
      end
    end

    describe 'update_last_seen_at!' do
      it 'updates the stored timestamp' do
        subject.update_attribute(:last_seen_at, new_stamp)
        subject.update_last_seen_at!
        Rails.cache.clear
        subject.reload.last_seen_at.should == new_stamp
      end
    end
  end
end

