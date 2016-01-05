class EmailConfirmationPolicy < ApplicationPolicy
  def confirm?
    true
  end

  def resend?
    record == user
  end
end
