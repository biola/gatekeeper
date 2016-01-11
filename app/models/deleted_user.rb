class DeletedUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uuid, type: String
  field :username, type: String
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :confirmed, type: Boolean

  def name
    [first_name, last_name].reject(&:blank?).join (' ')
  end
end
