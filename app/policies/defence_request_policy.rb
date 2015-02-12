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
        scope.none
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
    (user.cso? && record.created?) || (user.cco? && record.opened?)
  end

  def update?
    edit?
  end

  def solicitors_search?
    user.cso?
  end

  def refresh_dashboard?
    user.cso? || user.cco?
  end

  def feedback?
    (user.cso? || user.cco?) && record.can_transition?(:close)
  end

  def close?
    (user.cso? || user.cco?) && record.can_transition?(:close)
  end

  def dscc_number_edit?
    user.cco? && record.opened?
  end

  def interview_start_time_edit?
    user.cso? && !record.new_record? && record.created?
  end

  def open?
    user.cco? && record.can_transition?(:open)
  end

  def dashboard_view?
    user.cco? || user.cso?
  end

end
