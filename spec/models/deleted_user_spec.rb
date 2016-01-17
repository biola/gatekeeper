require 'spec_helper'

describe DeletedUser do
  it { is_expected.to have_fields(:uuid).of_type String }
  it { is_expected.to have_fields(:username).of_type String }
  it { is_expected.to have_fields(:email).of_type String }
  it { is_expected.to have_fields(:first_name).of_type String }
  it { is_expected.to have_fields(:last_name).of_type String }
  it { is_expected.to have_fields(:user_agent).of_type String }
  it { is_expected.to have_fields(:ip_address).of_type String }
  it { is_expected.to have_fields(:confirmed_at).of_type DateTime }
  it { is_expected.to have_fields(:referring_url).of_type String }
  it { is_expected.to have_fields(:created_at).of_type Time }
  it { is_expected.to have_fields(:updated_at).of_type Time }

  describe '#confirmed?' do
    let(:confirm_time) { Time.now }
    subject { build :deleted_user, confirmed_at: confirm_time }

    context 'when confirmed_at is nil' do
      let(:confirm_time) { nil }
      it { expect(subject.confirmed?).to be false }
    end

    context 'when confirmed_at is a time' do
      it { expect(subject.confirmed?).to be true }
    end
  end

  describe '#name' do
    subject { build :deleted_user, first_name: 'Trogdor', last_name: 'the Burninator' }
    it 'is the first name and last name combined' do
      expect(subject.name).to eql 'Trogdor the Burninator'
    end
  end
end
