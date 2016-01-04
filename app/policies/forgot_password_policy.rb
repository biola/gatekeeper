class ForgotPasswordPolicy < ApplicationPolicy
  def new?
    true
  end

  alias :create? :new?
end
