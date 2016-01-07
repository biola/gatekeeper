class NonBiolan < User
  include ActiveModel::SecurePassword

  field :password_digest, type: String
  field :confirmation_key, type: String
  field :confirmed, type: Boolean

  has_secure_password

  validates :password, length: {minimum: Settings.password.min_length}, allow_nil: true
  validates :email, format: {
    without: Regexp.new(Settings.users.reject_email_domain),
    message: "is not allowed to be from #{Settings.users.reject_email_domain}"
  }

  before_create :set_confirmation_key

  def unconfirmed?
    !confirmed?
  end

  def active?
    !deleted? && confirmed?
  end

  private

  def set_confirmation_key
    self.confirmation_key = SecureRandom.hex
  end
end
