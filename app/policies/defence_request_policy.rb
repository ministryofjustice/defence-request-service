class DefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.cso?
        scope.not_aborted
      elsif user.cco?
        scope.not_draft
      elsif user.solicitor?
        scope.has_solicitor(user).accepted_or_aborted
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
    (cso && !record.aborted?) || ((cco  || user_is_the_assigned_solicitor) && !record.draft?)
  end

  def new?
    cso
  end

  def create?
    cso
  end

  def edit?
    ((cso && record.draft?) || (user_is_the_assigned_cco && !record.draft? && !record.queued?)) && !record.aborted?
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

  def interview_start_time_edit?
    cso && !record.new_record? && record.draft?
  end

  def acknowledge?
    cco && record.can_execute_acknowledge?
  end

  def accept?
    cco && record.cco == user && record.can_execute_accept?
  end

  def resend_details?
    (cco || cso) && record.accepted?
  end

  def solicitor_time_of_arrival?
    (user_is_the_assigned_solicitor && !record.aborted?) || (record.accepted? && (cco || cso))
  end

  def solicitor_time_of_arrival_from_show?
    user_is_the_assigned_solicitor && !record.aborted?
  end

  def queue?
    cso && record.draft?
  end

  def abort?
    cso && record.can_execute_abort?
  end

  def reason_aborted?
    abort?
  end

  def update_and_accept?
    cco && record.cco == user && record.acknowledged?
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
