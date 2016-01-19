class ForgotPassword
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :non_biolan
  field :key, type: String
  field :expires_at, type: Time
  field :used, type: Boolean

  scope :active, -> { where(:used.ne => true, :expires_at.gte => Time.now) }

  validates :non_biolan_id, :key, :expires_at, presence: true

  before_validation :set_key, :set_expires_at

  private

  def set_key
    self.key ||= SecureRandom.hex
  end

  def set_expires_at
    self.expires_at = Time.now + Settings.password.reset_expire
  end
end
