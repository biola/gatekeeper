class User
  include Mongoid::Document

  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :deleted, type: Boolean

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
end
