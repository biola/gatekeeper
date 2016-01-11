class NonBiolan < User
  include ActiveModel::SecurePassword

  field :password_digest, type: String
  field :confirmation_key, type: String
  field :confirmed_at, type: DateTime

  has_secure_password

  validates :password, length: {minimum: Settings.password.min_length}, allow_nil: true
  validates :email, format: {
    without: Regexp.new(Settings.users.reject_email_domain),
    message: "is not allowed to be from #{Settings.users.reject_email_domain}"
  }

  before_create :set_confirmation_key

  alias :confirmed? :confirmed_at?
  alias :active? :confirmed?

  def unconfirmed?
    !confirmed?
  end

  def backup_and_destroy!
    shared_attrs = [:uuid, :username, :email, :first_name, :last_name, :confirmed_at, :user_agent, :ip_address]

    DeletedUser.create!(attributes.slice(*shared_attrs)).tap do
      destroy!
    end
  end

  private

  def set_confirmation_key
    self.confirmation_key = SecureRandom.hex
  end
end
