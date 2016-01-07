class Admin::ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.try(:admin?) || user.try(:developer?)
  end

  alias :show? :index?
  alias :new? :index?
  alias :create? :index?
  alias :edit? :index?
  alias :update? :index?
  alias :destroy? :index?

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
