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
        scope.has_solicitor(user)
      end
    end
  end

  def index?
    user.cso? || user.cco? || user.solicitor?
  end

  def show?
    user.cso? || user.cco? || user.solicitor?
  end

  def new?
    user.cso?
  end

  def create?
    user.cso?
  end

  def edit?
    (user.cso? && record.created?) || (user.cco? && record.opened? && record.cco == user)
  end

  def update?
    edit?
  end

  def solicitors_search?
    user.cso?
  end

  def refresh_dashboard?
    user.cso? || user.cco? || user.solicitor?
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

  def accept?
    user.cco? && record.can_transition?(:accept) && record.dscc_number?
  end

  def accepted?
    user.cco? && record.can_transition?(:accept) && record.dscc_number?
  end

  def view_open_requests?
    user.cco? || user.cso?
  end

  def view_created_requests?
    user.cco? || user.cso?
  end

  def view_accepted_requests?
    user.cco? || user.cso? || user.solicitor?
  end

  def resend_details?
    (user.cco? || user.cso?) && record.accepted?
  end

end
