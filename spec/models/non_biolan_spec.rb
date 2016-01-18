require 'spec_helper'

describe NonBiolan do
  it { is_expected.to have_fields(:uuid).of_type String }
  it { is_expected.to have_fields(:username).of_type String }
  it { is_expected.to have_fields(:email).of_type String }
  it { is_expected.to have_fields(:first_name).of_type String }
  it { is_expected.to have_fields(:last_name).of_type String }
  it { is_expected.to have_fields(:user_agent).of_type String }
  it { is_expected.to have_fields(:ip_address).of_type String }
  it { is_expected.to have_fields(:password_digest).of_type String }
  it { is_expected.to have_fields(:confirmation_key).of_type String }
  it { is_expected.to have_fields(:confirmed_at).of_type DateTime }
  it { is_expected.to have_fields(:trogdir_uuid).of_type String }
  it { is_expected.to have_fields(:referring_url).of_type String }
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

  describe '#confirmed?' do
    let(:confirm_time) { Time.now }
    subject { build :non_biolan, confirmed_at: confirm_time }

    context 'when confirmed_at is nil' do
      let(:confirm_time) { nil }
      it { expect(subject.confirmed?).to be false }
    end

    context 'when confirmed_at is a time' do
      it { expect(subject.confirmed?).to be true }
    end
  end

  describe '#active?' do
    let(:confirm_time) { Time.now }
    subject { build :non_biolan, confirmed_at: confirm_time }

    context 'when confirmed_at is nil' do
      let(:confirm_time) { nil }
      it { expect(subject.active?).to be false }
    end

    context 'when confirmed_at is a time' do
      it { expect(subject.active?).to be true }
    end
  end

  describe '#unconfirmed?' do
    let(:confirm_time) { Time.now }
    subject { build :non_biolan, confirmed_at: confirm_time }

    context 'when confirmed_at is nil' do
      let(:confirm_time) { nil }
      it { expect(subject.unconfirmed?).to be true }
    end

    context 'when confirmed_at is a time' do
      it { expect(subject.unconfirmed?).to be false }
    end
  end

  describe '#backup_and_destroy' do
    let!(:non_biolan) { create :non_biolan }
    subject { non_biolan }

    it 'destroys the non_biolan record' do
      expect { subject.backup_and_destroy! }.to change { NonBiolan.count }.by -1
    end

    it 'creates a DeletedUser' do
      expect { subject.backup_and_destroy! }.to change { DeletedUser.count }.by 1
    end

    it 'copies the relevant attributes to the DeletedUser' do
      user = subject.dup
      subject.backup_and_destroy!

      del_user = DeletedUser.find_by(uuid: user.uuid)
      expect(del_user.username).to eql user.username
      expect(del_user.email).to eql user.email
      expect(del_user.first_name).to eql user.first_name
      expect(del_user.last_name).to eql user.last_name
      expect(del_user.confirmed_at).to eql user.confirmed_at
      expect(del_user.user_agent).to eql user.user_agent
      expect(del_user.ip_address).to eql user.ip_address
      expect(del_user.referring_url).to eql user.referring_url
    end
  end

  describe '#confirmation_key' do
    subject { build :non_biolan }

    it 'is automatically generated' do
      expect { subject.save! }.to change { subject.confirmation_key? }.from(false).to true
    end

    it 'is a 32 caracter long random string' do
      subject.save!
      expect(subject.confirmation_key).to match /[0-9a-f]{32}/
    end
  end
end
