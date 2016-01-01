class User
  include Mongoid::Document

  # We don't need a complicated email matcher since we confirm the email on the
  # account anyway but it's good to make sure up front that people don't try to
  # use a simple username.
  VALID_EMAIL_MATCHER = /
    \A # beginning of string
    .+ # any one or more characters
    @  # a literal "@"
    .+ # any one or more characters
    \. # a literal period
    .+ # any one or more characters
    \Z # end of string
  /x

  field :uuid, type: String
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :deleted, type: Boolean

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true, format: {with: VALID_EMAIL_MATCHER}

  alias :username :email

  before_save :set_uuid

  scope :active, -> { where(:deleted.ne => true) }

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
