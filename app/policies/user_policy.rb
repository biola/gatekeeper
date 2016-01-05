class UserPolicy < ApplicationPolicy
    def show?
      user == record
    end

    def new?
      true
    end

    alias :create? :new?
    alias :edit? :show?
    alias :update? :show?
    alias :destroy? :show?
end
