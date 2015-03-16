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
        scope.not_draft
      elsif user.solicitor?
        scope.has_solicitor(user).accepted
      end
    end
  end

  def index?
    cso || cco || solicitor
  end

  def refresh_dashboard?
    index?
  end

  def show?
    ((cso || cco) && !record.closed?) || user_is_the_assigned_solicitor
  end

  def new?
    cso
  end

  def create?
    cso
  end

  def edit?
    (cso || user_is_the_assigned_cco) && !record.closed?
  end

  def update?
    edit?
  end

  def solicitors_search?
    cso
  end

  def add_case_time_of_arrival?
    create? && record.new_record?
  end

  def feedback?
    (cso || cco) && record.can_execute_close?
  end

  def close?
    (cso || cco) && record.can_execute_close?
  end

  def dscc_number_edit?
    record.opened? && user_is_the_assigned_cco
  end

  def interview_start_time_edit?
    cso && !record.new_record? && record.draft?
  end

  def case_details_edit?
    edit? && (cso || (!record.draft? && user_is_the_assigned_cco))
  end

  def detainee_details_edit?
    edit? && (cso || (!record.draft? && user_is_the_assigned_cco))
  end

  def solicitor_details_edit?
    edit? && ((cso && record.draft?) || (record.opened? && user_is_the_assigned_cco))
  end

  def open?
    cco && record.can_execute_open?
  end

  def accept?
    cco && record.can_execute_accept?
  end

  def resend_details?
    (cco || cso) && record.accepted?
  end

  def solicitor_time_of_arrival?
    (user_is_the_assigned_solicitor && !record.closed?) || (record.accepted? && (cco || cso))
  end

  def solicitor_time_of_arrival_from_show?
    user_is_the_assigned_solicitor && !record.closed?
  end

  private

  def cso
    user.cso?
  end

  def cco
    user.cco?
  end

  def user_is_the_assigned_cco
    cco && record.cco == user
  end

  def user_is_the_assigned_solicitor
    solicitor && record.solicitor == user
  end

  def solicitor
    user.solicitor?
  end

end
