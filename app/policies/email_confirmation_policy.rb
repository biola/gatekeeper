class EmailConfirmationPolicy < ApplicationPolicy
  def confirm?
    true
  end

  def resend?
    user.present? && record == user
  end
end
