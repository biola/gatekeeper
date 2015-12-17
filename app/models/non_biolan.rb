class NonBiolan < User
  include ActiveModel::SecurePassword

  has_secure_password

  field :password_digest, type: String
  field :confirmation_key, type: String
  field :confirmed, type: Boolean

  validates :password_digest, presence: true

  # TODO: validate not an @biola.edu email

  before_create :set_confirmation_key

  private

  def set_confirmation_key
    self.confirmation_key = SecureRandom.hex
  end
end
