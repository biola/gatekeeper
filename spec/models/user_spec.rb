require 'spec_helper'

describe User do
  it { is_expected.to have_fields(:uuid).of_type String }
  it { is_expected.to have_fields(:username).of_type String }
  it { is_expected.to have_fields(:email).of_type String }
  it { is_expected.to have_fields(:first_name).of_type String }
  it { is_expected.to have_fields(:last_name).of_type String }
  it { is_expected.to have_fields(:user_agent).of_type String }
  it { is_expected.to have_fields(:ip_address).of_type String }
  it { is_expected.to have_fields(:created_at).of_type Time }
  it { is_expected.to have_fields(:updated_at).of_type Time }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_uniqueness_of :email }

  describe '#email' do
    describe 'format validation' do
      subject { build :user, email: email }

      it { expect(build(:user, email: 'strongmad@example.com')).to be_valid }
      it { expect(build(:user, email: 'strongmad@bogus')).to be_invalid }
      it { expect(build(:user, email: 'strongmad@')).to be_invalid }
      it { expect(build(:user, email: 'strongmad')).to be_invalid }
      it { expect(build(:user, email: '@bogus.com')).to be_invalid }
    end
  end

  describe '#uuid' do
    subject { build :user }

    it 'auto generates' do
      expect { subject.save! }.to change { subject.uuid? }.from(false).to true
    end
  end

  describe '#username' do
    let(:email) { Faker::Internet.email }
    subject { build :user, email: email }

    it 'automatically gets set to the email' do
      expect { subject.save! }.to change { subject.username? }.from(false).to true
      expect(subject.tap{ |u| u.save!}.username).to eql email
    end

    it "doesn't change when the email changes" do
      subject.save!
      expect { subject.update email: Faker::Internet.email }.to_not change { subject.username }
    end
  end

  describe '#name' do
    subject { build :user, first_name: 'Trogdor', last_name: 'the Burninator' }
    it 'is the first name and last name combined' do
      expect(subject.name).to eql 'Trogdor the Burninator'
    end
  end

  describe '#new?' do
    it { expect(build(:user, created_at: Time.now )).to be_new }
    it { expect(build(:user, created_at: 29.days.ago )).to be_new }
    it { expect(build(:user, created_at: 31.days.ago )).to_not be_new }
  end
end
