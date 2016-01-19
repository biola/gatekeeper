require 'spec_helper'

describe ForgotPassword do
  it { is_expected.to belong_to :non_biolan }
  it { is_expected.to have_field(:key).of_type String }
  it { is_expected.to have_field(:expires_at).of_type Time }
  it { is_expected.to have_field(:used).of_type Mongoid::Boolean }
  it { is_expected.to have_field(:created_at).of_type Time }
  it { is_expected.to have_field(:updated_at).of_type Time }

  it { is_expected.to validate_presence_of :non_biolan_id }
  it { is_expected.to validate_presence_of :key }
  it { is_expected.to validate_presence_of :expires_at }

  context 'before validation' do
    subject { ForgotPassword.new }
    describe '#key' do
      it 'generates a random key' do
        expect { subject.valid? }.to change { subject.key }.from(nil)
        expect(subject.key).to match /\A[0-9a-f]{32}\Z/
      end
    end

    describe '#expires_at' do
      it 'sets the expires_at time' do
        expect { subject.valid? }.to change { subject.expires_at }.from(nil)
        expect(subject.expires_at).to be > 23.hours.from_now
        expect(subject.expires_at).to be < 25.hours.from_now
      end
    end
  end
end
