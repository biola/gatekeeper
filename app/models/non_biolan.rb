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

  alias :active? :confirmed?

  def backup_and_destroy!
    shared_attrs = [:uuid, :username, :email, :first_name, :last_name, :confirmed, :user_agent, :ip_address]

    DeletedUser.create!(attributes.slice(*shared_attrs)).tap do
      destroy!
    end
  end

  private

  def set_confirmation_key
    self.confirmation_key = SecureRandom.hex
  end
end
