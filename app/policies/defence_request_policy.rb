class DefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.cso?
        scope.all
      elsif user.cco?
        scope.all
      elsif user.solicitor?
        []
      end
    end
  end

  def index?
    user.cso? || user.cco? || user.solicitor?
  end

  def new?
    user.cso?
  end

  def create?
    user.cso?
  end

  def edit?
    user.cso? || user.cco?
  end

  def update?
    user.cso? || user.cco?
  end

  def solicitors_search?
    user.cso?
  end

  def refresh_dashboard?
    user.cso? || user.cco?
  end

  def close?
    user.cso?
  end

end
