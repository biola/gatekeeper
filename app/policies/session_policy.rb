class SessionPolicy < ApplicationPolicy
  def create?
    true
  end

  alias :destroy? :create?
end
