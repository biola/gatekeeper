class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # We don't need a complicated email matcher since we confirm the email on the
  # account anyway but it's good to make sure up front that people don't try to
  # use a simple username that's not an email.
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
  field :username, type: String
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :deleted, type: Boolean

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true, format: {with: VALID_EMAIL_MATCHER}

  before_save :set_uuid, :set_username

  scope :active, -> { where(:deleted.ne => true) }

  def name
    [first_name, last_name].reject(&:blank?).join (' ')
  end

  def active?
    !deleted?
  end

  def new?
    created_at.to_i > (Time.now - Settings.users.new_before).to_i
  end

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def set_username
    self.username ||= email
  end
end
