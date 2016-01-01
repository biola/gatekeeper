class User
  include Mongoid::Document

  field :uuid, type: String
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :deleted, type: Boolean

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true

  alias :username :email

  before_save :set_uuid

  scope :active, -> { where(:deleted.ne => true) }

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
