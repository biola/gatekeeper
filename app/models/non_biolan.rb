class NonBiolan < User
  include ActiveModel::SecurePassword

  field :password_digest, type: String
  field :confirmation_key, type: String
  field :confirmed, type: Boolean

  has_secure_password

  validates :password, length: {minimum: Settings.password.min_length}, allow_nil: true
  # TODO: validate not an @biola.edu email

  before_create :set_confirmation_key

  private

  def set_confirmation_key
    self.confirmation_key = SecureRandom.hex
  end
end
