class ForgotPasswordPolicy < ApplicationPolicy
  def new?
    true
  end

  alias :create? :new?
  alias :edit? :new?
  alias :update? :new?
end
